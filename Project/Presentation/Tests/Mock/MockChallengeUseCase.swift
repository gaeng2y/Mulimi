import DomainLayerInterface
import Foundation

final class MockChallengeUseCase: ChallengeUseCase, @unchecked Sendable {
    var challenges: [HydrationChallenge] = []
    var badgeHistories: [HydrationChallengeBadgeHistory] = []
    private(set) var requestedReferenceDate: Date?
    private(set) var fetchBadgeHistoriesCallCount = 0

    func fetchChallenges(referenceDate: Date, calendar: Calendar) async -> [HydrationChallenge] {
        requestedReferenceDate = referenceDate
        return challenges
    }

    func fetchBadgeHistories() async -> [HydrationChallengeBadgeHistory] {
        fetchBadgeHistoriesCallCount += 1
        return badgeHistories
    }
}
