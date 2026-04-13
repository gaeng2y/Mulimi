import DomainLayerInterface
import Foundation

public final class MockRoutineRecommendationUseCase: RoutineRecommendationUseCase, @unchecked Sendable {
    public var recommendations: [HydrationRoutineRecommendation]

    public init(
        recommendations: [HydrationRoutineRecommendation] = [
            HydrationRoutineRecommendation(
                kind: .afternoonGap,
                hour: 15,
                minute: 0,
                weekdays: [.monday, .tuesday, .wednesday, .thursday, .friday]
            )
        ]
    ) {
        self.recommendations = recommendations
    }

    public func fetchRecommendations(
        referenceDate: Date,
        calendar: Calendar
    ) async -> [HydrationRoutineRecommendation] {
        recommendations
    }
}
