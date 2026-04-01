import DomainLayerInterface
import Foundation

final class MockHydrationGoalRecommendationUseCase: HydrationGoalRecommendationUseCase, @unchecked Sendable {
    var availabilityValue: HydrationGoalRecommendationAvailability = .ready
    var recommendationValue = HydrationGoalRecommendation(
        input: HydrationGoalRecommendationInput(
            heightCM: 172,
            weightKG: 64,
            currentGoalML: 2_000,
            recentAverageIntakeML: 1_700,
            recentRecordedDays: 6,
            recentGoalAchievementDays: 4,
            analysisDays: 7
        ),
        recommendedLimitML: 2_250,
        summary: "최근 기록을 기준으로 현재 목표를 조금 올리는 정도가 적절해 보여요.",
        reasons: [
            "최근 평균 섭취량이 현재 목표에 가까워요.",
            "신체 정보 기준으로 급격한 변화보다 완만한 조정이 자연스러워요."
        ],
        caution: "추천값은 참고용이에요."
    )
    var generateError: Error?

    private(set) var availabilityCallCount = 0
    private(set) var generateRecommendationCallCount = 0

    func availability(referenceDate: Date) async -> HydrationGoalRecommendationAvailability {
        availabilityCallCount += 1
        return availabilityValue
    }

    func generateRecommendation(referenceDate: Date) async throws -> HydrationGoalRecommendation {
        generateRecommendationCallCount += 1
        if let generateError {
            throw generateError
        }
        return recommendationValue
    }
}
