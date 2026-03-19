import DomainLayerInterface
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
