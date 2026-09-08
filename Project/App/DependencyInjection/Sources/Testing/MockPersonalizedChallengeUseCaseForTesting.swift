import AccountDomain
import ChallengeDomain
import MulimiAnalytics
import HydrationDomain
import RoutineDomain
import Foundation

public final class MockPersonalizedChallengeUseCaseForTesting: PersonalizedChallengeUseCase, @unchecked Sendable {
    public var challenges: [PersonalizedHydrationChallenge] = []

    public init() {}

    public func fetchPersonalizedChallenges(
        snapshot: HydrationProgressSnapshot,
        referenceDate: Date,
        calendar: Calendar
    ) async -> [PersonalizedHydrationChallenge] {
        challenges
    }
}
