//
//  MockHydrationGoalRecommendationUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Codex on 3/30/26.
//

import DomainLayerInterface
import Foundation

public final class MockHydrationGoalRecommendationUseCase: HydrationGoalRecommendationUseCase, @unchecked Sendable {
    public var availabilityValue: HydrationGoalRecommendationAvailability = .ready
    public var recommendationValue = HydrationGoalRecommendation(
        input: HydrationGoalRecommendationInput(
            heightCM: 172,
            weightKG: 64,
            currentGoalML: 2_000,
            recentAverageIntakeML: 1_650,
            recentRecordedDays: 6,
            recentGoalAchievementDays: 3,
            analysisDays: 7
        ),
        recommendedLimitML: 2_250,
        summary: "최근 일주일 섭취량보다 조금 높은 목표가 안정적으로 유지되기 좋아요.",
        reasons: [
            "최근 평균 섭취량과 현재 목표의 차이가 크지 않아요.",
            "신체 정보 기준으로 현재 목표를 약간 올리는 정도가 무리가 적어요."
        ],
        caution: "추천값은 참고용이에요. 컨디션에 따라 조정해 주세요."
    )
    public var generateError: Error?

    public init() {}

    public func availability(referenceDate: Date) async -> HydrationGoalRecommendationAvailability {
        availabilityValue
    }

    public func generateRecommendation(referenceDate: Date) async throws -> HydrationGoalRecommendation {
        if let generateError {
            throw generateError
        }
        return recommendationValue
    }
}
