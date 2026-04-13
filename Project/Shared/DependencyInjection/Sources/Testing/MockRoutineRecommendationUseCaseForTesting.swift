import DomainLayerInterface
import Foundation

public final class MockRoutineRecommendationUseCaseForTesting: RoutineRecommendationUseCase, @unchecked Sendable {
    public var recommendations: [HydrationRoutineRecommendation] = []

    public init() {}

    public func fetchRecommendations(
        referenceDate: Date,
        calendar: Calendar
    ) async -> [HydrationRoutineRecommendation] {
        recommendations
    }
}
