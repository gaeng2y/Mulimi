import DomainLayerInterface
import Foundation

public final class MockChallengeUseCaseForTesting: ChallengeUseCase, @unchecked Sendable {
    public init() {}

    public func fetchChallenges(referenceDate: Date, calendar: Calendar) async -> [HydrationChallenge] {
        []
    }

    public func fetchBadgeHistories() async -> [HydrationChallengeBadgeHistory] {
        []
    }
}
