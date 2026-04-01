import DomainLayerInterface

final class MockHydrationGoalRecommendationRepository: HydrationGoalRecommendationRepository, @unchecked Sendable {
    var unavailableReason: HydrationGoalRecommendationUnavailableReason?
    var recommendationToReturn = HydrationGoalRecommendation(
        input: HydrationGoalRecommendationInput(
            heightCM: 170,
            weightKG: 60,
            currentGoalML: 2_000,
            recentAverageIntakeML: 1_500,
            recentRecordedDays: 6,
            recentGoalAchievementDays: 3,
            analysisDays: 7
        ),
        recommendedLimitML: 2_250,
        summary: "추천 요약",
        reasons: ["이유 1", "이유 2"],
        caution: nil
    )
    var generateRecommendationError: Error?

    private(set) var generateRecommendationCallCount = 0
    private(set) var capturedInput: HydrationGoalRecommendationInput?

    func availability() -> HydrationGoalRecommendationUnavailableReason? {
        unavailableReason
    }

    func generateRecommendation(
        for input: HydrationGoalRecommendationInput
    ) async throws -> HydrationGoalRecommendation {
        generateRecommendationCallCount += 1
        capturedInput = input

        if let generateRecommendationError {
            throw generateRecommendationError
        }

        return recommendationToReturn
    }
}
