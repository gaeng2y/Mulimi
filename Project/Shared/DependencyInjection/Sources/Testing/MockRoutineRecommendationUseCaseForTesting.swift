import AccountDomain
import ChallengeDomain
import MulimiAnalytics
import HydrationDomain
import RoutineDomain
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
