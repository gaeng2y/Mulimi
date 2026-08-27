import Foundation

public protocol RoutineRecommendationUseCase: Sendable {
    func fetchRecommendations(
        referenceDate: Date,
        calendar: Calendar
    ) async -> [HydrationRoutineRecommendation]
}
