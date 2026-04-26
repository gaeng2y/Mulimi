//
//  DrinkWaterViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import CoreGraphics
import DomainLayerInterface
import Foundation
import Localization
import Observation

struct HydrationServingOptionModel: Identifiable, Equatable {
    let id: String
    let title: String
    let volumeML: Int

    var volumeText: String {
        L10n.tr("commonMilliliterFormat", volumeML)
    }
}

enum CustomHydrationAmountValidation: Equatable {
    case empty
    case invalid
    case overLimit(remainingML: Int)
    case valid(volumeML: Int)
}

@MainActor
@Observable
public final class DrinkWaterViewModel {
    // MARK: - Published State
    private(set) var currentWaterIntakeML: Double
    private(set) var offset: CGFloat = 0
    private(set) var mainIcon: MainIcon
    private(set) var currentDailyLimit: Double

    private let waterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let nextActionGuideUseCase: HydrationNextActionGuideUseCase
    private let widgetTimelineReloader: any WidgetTimelineReloading
    private let calendar: Calendar
    private let nowProvider: @Sendable () -> Date
    private(set) var nextActionGuide: HydrationNextActionGuide

    var mililiters: String {
        L10n.tr("commonMilliliterFormat", Int(currentWaterIntakeML.rounded()))
    }

    var drinkWaterCount: Int {
        HydrationServing.glassCount(for: currentWaterIntakeML)
    }

    var dailyLimit: Double {
        currentDailyLimit
    }

    var isLimitReached: Bool {
        currentWaterIntakeML.rounded() >= dailyLimit.rounded()
    }

    var servingOptions: [HydrationServingOptionModel] {
        HydrationServing.additionalPresets.map { preset in
            HydrationServingOptionModel(
                id: preset.id,
                title: servingTitle(for: preset),
                volumeML: preset.volumeML
            )
        }
    }

    var progress: CGFloat {
        guard currentDailyLimit > 0 else {
            return 0
        }

        return min(CGFloat(currentWaterIntakeML / currentDailyLimit), 1.0)
    }

    var nextActionBadgeText: String {
        L10n.tr("drinkWaterNextActionBadge")
    }

    var nextActionHeadline: String {
        switch nextActionGuide.state {
        case .readyToDrink:
            return L10n.tr("drinkWaterNextActionReadyHeadline")
        case .approachingRoutine:
            guard let nextRoutine = nextActionGuide.nextRoutine else {
                return L10n.tr("drinkWaterNextActionReadyHeadline")
            }

            return L10n.tr(
                "drinkWaterNextActionApproachingRoutineHeadlineFormat",
                relativeTimeText(for: nextRoutine.minutesUntil)
            )
        case .goalReached:
            return L10n.tr("drinkWaterNextActionGoalReachedHeadline")
        case .needsGoal:
            return L10n.tr("drinkWaterNextActionNeedsGoalHeadline")
        }
    }

    var nextActionDescription: String {
        switch nextActionGuide.state {
        case .goalReached:
            return L10n.tr("drinkWaterNextActionGoalReachedDescription")
        case .needsGoal:
            return L10n.tr("drinkWaterNextActionNeedsGoalDescription")
        case .readyToDrink, .approachingRoutine:
            let remainingText = L10n.tr("commonMilliliterFormat", nextActionGuide.remainingML)

            if let nextRoutine = nextActionGuide.nextRoutine {
                return L10n.tr(
                    "drinkWaterNextActionRoutineDescriptionFormat",
                    nextRoutine.timeText,
                    relativeTimeText(for: nextRoutine.minutesUntil),
                    remainingText,
                    nextActionGuide.remainingGlassCount
                )
            }

            return L10n.tr(
                "drinkWaterNextActionRemainingDescriptionFormat",
                remainingText,
                nextActionGuide.remainingGlassCount
            )
        }
    }

    public init(
        waterUseCase: DrinkWaterUseCase,
        userPreferencesUseCase: UserPreferencesUseCase,
        nextActionGuideUseCase: HydrationNextActionGuideUseCase,
        widgetTimelineReloader: any WidgetTimelineReloading,
        calendar: Calendar = .current,
        nowProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.waterUseCase = waterUseCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.nextActionGuideUseCase = nextActionGuideUseCase
        self.widgetTimelineReloader = widgetTimelineReloader
        self.calendar = calendar
        self.nowProvider = nowProvider
        let initialWaterIntakeML = 0.0
        let initialDailyLimit = userPreferencesUseCase.getDailyWaterLimit()

        self.currentWaterIntakeML = initialWaterIntakeML
        self.mainIcon = userPreferencesUseCase.getMainIcon()
        self.currentDailyLimit = initialDailyLimit
        self.nextActionGuide = HydrationNextActionGuide.make(
            currentIntakeML: initialWaterIntakeML,
            dailyGoalML: initialDailyLimit,
            calendar: calendar
        )
    }

    private func updateMainIcon() {
        let newIcon = userPreferencesUseCase.getMainIcon()
        if mainIcon != newIcon {
            mainIcon = newIcon
        }
    }

    private func updateCurrentIntake() async {
        let newIntake = await waterUseCase.currentWaterIntakeML
        if currentWaterIntakeML != newIntake {
            currentWaterIntakeML = newIntake
        }
    }

    private func updateDailyLimit() {
        let newLimit = userPreferencesUseCase.getDailyWaterLimit()
        if currentDailyLimit != newLimit {
            currentDailyLimit = newLimit
        }
    }

    private func updateNextActionGuide() async {
        nextActionGuide = await nextActionGuideUseCase.guide(
            referenceDate: nowProvider(),
            calendar: calendar
        )
    }

    public func loadInitialState() async {
        await waterUseCase.migrateLegacyDataIfNeeded()
        await refreshState()
    }

    func drinkWater() async {
        await recordWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    @discardableResult
    func recordWater(volumeML: Int) async -> Bool {
        guard isRecordable(volumeML: volumeML) else {
            return false
        }

        await waterUseCase.drinkWater(volumeML: volumeML)
        await refreshState()
        widgetTimelineReloader.reloadAllTimelines()
        return true
    }

    func isRecordable(volumeML: Int) -> Bool {
        guard volumeML > 0 else {
            return false
        }

        let nextIntake = currentWaterIntakeML + Double(volumeML)
        return nextIntake.rounded() <= dailyLimit.rounded()
    }

    func customAmountValidation(for text: String) -> CustomHydrationAmountValidation {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedText.isEmpty else {
            return .empty
        }

        guard let volumeML = Int(trimmedText), volumeML > 0 else {
            return .invalid
        }

        guard isRecordable(volumeML: volumeML) else {
            return .overLimit(remainingML: remainingRecordableVolumeML)
        }

        return .valid(volumeML: volumeML)
    }

    func canRecordCustomAmount(_ text: String) -> Bool {
        if case .valid = customAmountValidation(for: text) {
            return true
        }

        return false
    }

    func customAmountErrorMessage(for text: String) -> String? {
        switch customAmountValidation(for: text) {
        case .empty, .valid:
            return nil
        case .invalid:
            return L10n.tr("drinkWaterCustomAmountInvalidDescription")
        case .overLimit(remainingML: let remainingML):
            return L10n.tr("drinkWaterCustomAmountOverLimitDescriptionFormat", remainingML)
        }
    }

    @discardableResult
    func recordCustomAmount(_ text: String) async -> Bool {
        guard case .valid(volumeML: let volumeML) = customAmountValidation(for: text) else {
            return false
        }

        return await recordWater(volumeML: volumeML)
    }

    func reset() async {
        await waterUseCase.reset()
        await refreshState()
        widgetTimelineReloader.reloadAllTimelines()
    }

    func resetAnimation() {
        offset = 0
    }

    func startAnimation() {
        offset = 360
    }

    public func refreshState() async {
        updateMainIcon()
        await updateCurrentIntake()
        updateDailyLimit()
        await updateNextActionGuide()
    }

    private var remainingRecordableVolumeML: Int {
        max(Int(dailyLimit.rounded() - currentWaterIntakeML.rounded()), 0)
    }

    private func servingTitle(for preset: HydrationServingPreset) -> String {
        switch preset {
        case .bottle:
            return L10n.tr("drinkWaterPresetBottleTitle")
        case .tumbler:
            return L10n.tr("drinkWaterPresetTumblerTitle")
        }
    }

    private func relativeTimeText(for minutes: Int) -> String {
        if minutes < 60 {
            return L10n.tr("drinkWaterNextActionMinutesFormat", minutes)
        }

        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        guard remainingMinutes > 0 else {
            return L10n.tr("drinkWaterNextActionHoursFormat", hours)
        }

        return L10n.tr("drinkWaterNextActionHoursMinutesFormat", hours, remainingMinutes)
    }
}
