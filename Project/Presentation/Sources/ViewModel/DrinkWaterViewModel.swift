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
    private let widgetTimelineReloader: any WidgetTimelineReloading
    
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
    
    var progress: CGFloat {
        guard currentDailyLimit > 0 else {
            return 0
        }

        return min(CGFloat(currentWaterIntakeML / currentDailyLimit), 1.0)
    }
    
    public init(
        waterUseCase: DrinkWaterUseCase,
        userPreferencesUseCase: UserPreferencesUseCase,
        widgetTimelineReloader: any WidgetTimelineReloading
    ) {
        self.waterUseCase = waterUseCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.widgetTimelineReloader = widgetTimelineReloader
        self.currentWaterIntakeML = 0
        self.mainIcon = userPreferencesUseCase.getMainIcon()
        self.currentDailyLimit = userPreferencesUseCase.getDailyWaterLimit()
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

    public func loadInitialState() async {
        await waterUseCase.migrateLegacyDataIfNeeded()
        await refreshState()
    }

    func drinkWater() async {
        let nextIntake = currentWaterIntakeML + HydrationServing.defaultGlassML

        if nextIntake.rounded() > dailyLimit.rounded() {
            return
        }
        
        await waterUseCase.drinkWater()
        await refreshState()
        widgetTimelineReloader.reloadAllTimelines()
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
    }
}
