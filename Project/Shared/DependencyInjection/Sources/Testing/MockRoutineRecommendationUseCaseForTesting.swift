import AccountDomain
import ChallengeDomain
import CoreDomain
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
