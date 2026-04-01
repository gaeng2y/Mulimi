import DomainLayerInterface
import Foundation

final class MockChallengeRepository: ChallengeRepository, @unchecked Sendable {
    private var badgeHistories: [HydrationChallengeBadgeHistory] = []

    private(set) var fetchBadgeHistoriesCallCount = 0
    private(set) var saveBadgeHistoriesCallCount = 0
    private(set) var lastSavedBadgeHistories: [HydrationChallengeBadgeHistory] = []

    func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory] {
        fetchBadgeHistoriesCallCount += 1
        return badgeHistories
    }

    func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory]) {
        saveBadgeHistoriesCallCount += 1
        badgeHistories = histories
        lastSavedBadgeHistories = histories
    }

    func setBadgeHistories(_ histories: [HydrationChallengeBadgeHistory]) {
        badgeHistories = histories
    }
}
