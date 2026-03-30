//
//  HydrationGoalRecommendationUseCaseImpl.swift
//  DomainLayer
//
//  Created by Codex on 3/30/26.
//

import DomainLayerInterface
import Foundation

public struct HydrationGoalRecommendationUseCaseImpl: HydrationGoalRecommendationUseCase {
    private enum Constants {
        static let analysisDays = 7
    }

    private let bodyProfileUseCase: BodyProfileUseCase
    private let drinkWaterRepository: DrinkWaterRepository
    private let userPreferencesRepository: UserPreferencesRepository
    private let recommendationRepository: HydrationGoalRecommendationRepository
    private let calendar: Calendar

    public init(
        bodyProfileUseCase: BodyProfileUseCase,
        drinkWaterRepository: DrinkWaterRepository,
        userPreferencesRepository: UserPreferencesRepository,
        recommendationRepository: HydrationGoalRecommendationRepository,
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.bodyProfileUseCase = bodyProfileUseCase
        self.drinkWaterRepository = drinkWaterRepository
        self.userPreferencesRepository = userPreferencesRepository
        self.recommendationRepository = recommendationRepository
        self.calendar = calendar
    }

    public func availability(referenceDate: Date) async -> HydrationGoalRecommendationAvailability {
        let snapshot = await bodyProfileUseCase.loadBodyProfile()

        guard snapshot.resolvedBodyProfile.isComplete else {
            return .bodyProfileRequired(snapshot.availability)
        }

        if let unavailableReason = recommendationRepository.availability() {
            return .modelUnavailable(unavailableReason)
        }

        return .ready
    }

    public func generateRecommendation(referenceDate: Date) async throws -> HydrationGoalRecommendation {
        let snapshot = await bodyProfileUseCase.loadBodyProfile()

        guard snapshot.resolvedBodyProfile.isComplete else {
            throw HydrationGoalRecommendationError.bodyProfileRequired(snapshot.availability)
        }

        if let unavailableReason = recommendationRepository.availability() {
            throw HydrationGoalRecommendationError.modelUnavailable(unavailableReason)
        }

        let input = await buildInput(
            from: snapshot.resolvedBodyProfile,
            referenceDate: referenceDate
        )

        return try await recommendationRepository.generateRecommendation(for: input)
    }

    private func buildInput(
        from bodyProfile: BodyProfile,
        referenceDate: Date
    ) async -> HydrationGoalRecommendationInput {
        let dayInterval = analysisInterval(for: referenceDate)
        let events = await drinkWaterRepository.hydrationEvents(in: dayInterval)
        let dailyTotals = aggregateDailyTotals(from: events)

        let analysisDays = Constants.analysisDays
        let currentGoalML = Int(userPreferencesRepository.getDailyWaterLimit().rounded())
        let totalIntakeML = dailyTotals.values.reduce(0, +)
        let recentAverageIntakeML = totalIntakeML / analysisDays
        let recentRecordedDays = dailyTotals.values.filter { $0 > 0 }.count
        let recentGoalAchievementDays = dailyTotals.values.filter { $0 >= currentGoalML }.count

        return HydrationGoalRecommendationInput(
            heightCM: Int((bodyProfile.heightCM?.value ?? 0).rounded()),
            weightKG: Int((bodyProfile.weightKG?.value ?? 0).rounded()),
            currentGoalML: currentGoalML,
            recentAverageIntakeML: recentAverageIntakeML,
            recentRecordedDays: recentRecordedDays,
            recentGoalAchievementDays: recentGoalAchievementDays,
            analysisDays: analysisDays
        )
    }

    private func analysisInterval(for referenceDate: Date) -> DateInterval {
        let end = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: referenceDate)
        ) ?? referenceDate
        let start = calendar.date(
            byAdding: .day,
            value: -(Constants.analysisDays - 1),
            to: calendar.startOfDay(for: referenceDate)
        ) ?? referenceDate
        return DateInterval(start: start, end: end)
    }

    private func aggregateDailyTotals(from events: [HydrationEvent]) -> [Date: Int] {
        events.reduce(into: [:]) { partialResult, event in
            let dayStart = calendar.startOfDay(for: event.consumedAt)
            partialResult[dayStart, default: 0] += event.volumeML
        }
    }
}
