//
//  HydrationGoalRecommendationViewModel.swift
//  HydrationPresentation
//
//  Created by Codex on 3/30/26.
//

import AccountDomain
import MulimiAnalytics
import CorePresentation
import HydrationDomain
import RoutineDomain
import Foundation
import Localization
import Observation

@Observable
@MainActor
public final class HydrationGoalRecommendationViewModel {
    public enum State: Equatable {
        case idle
        case loading
        case ready
        case bodyProfileRequired(BodyProfileAvailability)
        case modelUnavailable(HydrationGoalRecommendationUnavailableReason)
    }

    public enum GoalAlignment: Equatable {
        case unknown
        case belowGoal
        case aboveGoal
        case aligned
    }

    public enum EntryDestination: Equatable {
        case dailyLimitSetting
        case bodyProfileSetting
    }

    private enum GoalAlignmentThreshold {
        static let minimumElapsedDays = 3
        static let belowRatio = 0.7
        static let aboveRatio = 1.15
    }

    public private(set) var state: State = .idle
    public private(set) var recommendation: HydrationGoalRecommendation?
    public private(set) var isGenerating = false
    public private(set) var errorMessage: String?
    public private(set) var goalAlignment: GoalAlignment = .unknown

    private let useCase: HydrationGoalRecommendationUseCase
    private let progressUseCase: HydrationProgressUseCase
    private let calendar: Calendar

    public init(
        useCase: HydrationGoalRecommendationUseCase,
        progressUseCase: HydrationProgressUseCase,
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.useCase = useCase
        self.progressUseCase = progressUseCase
        self.calendar = calendar
    }

    public var entryDestination: EntryDestination {
        switch state {
        case .bodyProfileRequired:
            .bodyProfileSetting
        case .idle, .loading, .ready, .modelUnavailable:
            .dailyLimitSetting
        }
    }

    public var entryDescription: String {
        switch state {
        case let .bodyProfileRequired(availability):
            switch availability {
            case .needsPermission, .permissionDenied:
                L10n.tr("profileGoalRecommendationEntryConnectHealthDescription")
            case .noData, .incomplete, .ready:
                L10n.tr("profileGoalRecommendationEntryBodyProfileDescription")
            }
        case .modelUnavailable:
            L10n.tr("profileGoalRecommendationEntryUnavailableDescription")
        case .idle, .loading:
            L10n.tr("profileGoalRecommendationEntryDefaultDescription")
        case .ready:
            switch goalAlignment {
            case .belowGoal:
                L10n.tr("profileGoalRecommendationEntryBelowGoalDescription")
            case .aboveGoal:
                L10n.tr("profileGoalRecommendationEntryAboveGoalDescription")
            case .aligned, .unknown:
                L10n.tr("profileGoalRecommendationEntryDefaultDescription")
            }
        }
    }

    public func load() async {
        state = .loading
        errorMessage = nil
        recommendation = nil

        let referenceDate = Date.now
        async let availability = useCase.availability(referenceDate: referenceDate)
        async let snapshot = progressUseCase.progressSnapshot(
            referenceDate: referenceDate,
            calendar: calendar
        )

        let (resolvedAvailability, resolvedSnapshot) = await (availability, snapshot)
        state = map(resolvedAvailability)
        goalAlignment = makeGoalAlignment(from: resolvedSnapshot)
    }

    public func generateRecommendation() async {
        errorMessage = nil

        let availability = await useCase.availability(referenceDate: .now)
        let mappedState = map(availability)
        state = mappedState

        guard case .ready = availability else {
            recommendation = nil
            return
        }

        isGenerating = true
        defer { isGenerating = false }

        do {
            recommendation = try await useCase.generateRecommendation(referenceDate: .now)
            state = .ready
        } catch let error as HydrationGoalRecommendationError {
            recommendation = nil
            switch error {
            case let .bodyProfileRequired(availability):
                state = .bodyProfileRequired(availability)
            case let .modelUnavailable(reason):
                state = .modelUnavailable(reason)
            }
        } catch {
            recommendation = nil
            errorMessage = L10n.tr("hydrationGoalRecommendationGenerationFailureDescription")
        }
    }

    public func clearRecommendation() {
        recommendation = nil
        errorMessage = nil
    }

    private func map(_ availability: HydrationGoalRecommendationAvailability) -> State {
        switch availability {
        case .ready:
            .ready
        case let .bodyProfileRequired(value):
            .bodyProfileRequired(value)
        case let .modelUnavailable(reason):
            .modelUnavailable(reason)
        }
    }

    private func makeGoalAlignment(from snapshot: HydrationProgressSnapshot) -> GoalAlignment {
        guard !snapshot.isEmpty,
              snapshot.dailyGoalML > 0,
              snapshot.weeklyElapsedDays >= GoalAlignmentThreshold.minimumElapsedDays else {
            return .unknown
        }

        let ratio = snapshot.weeklyAverageML / snapshot.dailyGoalML
        if ratio < GoalAlignmentThreshold.belowRatio {
            return .belowGoal
        }

        if ratio > GoalAlignmentThreshold.aboveRatio {
            return .aboveGoal
        }

        return .aligned
    }
}
