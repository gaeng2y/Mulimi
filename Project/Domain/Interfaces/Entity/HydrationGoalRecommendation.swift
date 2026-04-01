//
//  HydrationGoalRecommendation.swift
//  DomainLayerInterface
//
//  Created by Codex on 3/30/26.
//

import Foundation

public struct HydrationGoalRecommendationInput: Hashable, Sendable {
    public let heightCM: Int
    public let weightKG: Int
    public let currentGoalML: Int
    public let recentAverageIntakeML: Int
    public let recentRecordedDays: Int
    public let recentGoalAchievementDays: Int
    public let analysisDays: Int

    public init(
        heightCM: Int,
        weightKG: Int,
        currentGoalML: Int,
        recentAverageIntakeML: Int,
        recentRecordedDays: Int,
        recentGoalAchievementDays: Int,
        analysisDays: Int
    ) {
        self.heightCM = heightCM
        self.weightKG = weightKG
        self.currentGoalML = currentGoalML
        self.recentAverageIntakeML = recentAverageIntakeML
        self.recentRecordedDays = recentRecordedDays
        self.recentGoalAchievementDays = recentGoalAchievementDays
        self.analysisDays = analysisDays
    }
}

public struct HydrationGoalRecommendation: Hashable, Sendable {
    public let input: HydrationGoalRecommendationInput
    public let recommendedLimitML: Int
    public let summary: String
    public let reasons: [String]
    public let caution: String?

    public init(
        input: HydrationGoalRecommendationInput,
        recommendedLimitML: Int,
        summary: String,
        reasons: [String],
        caution: String?
    ) {
        self.input = input
        self.recommendedLimitML = recommendedLimitML
        self.summary = summary
        self.reasons = reasons
        self.caution = caution
    }
}

public enum HydrationGoalRecommendationUnavailableReason: Hashable, Sendable {
    case deviceNotEligible
    case appleIntelligenceNotEnabled
    case modelNotReady
    case unsupportedLocale
    case unknown
}

public enum HydrationGoalRecommendationAvailability: Hashable, Sendable {
    case ready
    case bodyProfileRequired(BodyProfileAvailability)
    case modelUnavailable(HydrationGoalRecommendationUnavailableReason)
}

public enum HydrationGoalRecommendationError: Error, Hashable, Sendable {
    case bodyProfileRequired(BodyProfileAvailability)
    case modelUnavailable(HydrationGoalRecommendationUnavailableReason)
}
