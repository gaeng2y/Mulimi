import DomainLayerInterface
import Foundation

final class MockChallengeRepository: ChallengeRepository, @unchecked Sendable {
    private var states: [HydrationChallengeState] = []
    private var badgeHistories: [HydrationChallengeBadgeHistory] = []

    private(set) var fetchChallengeStatesCallCount = 0
    private(set) var saveChallengeStatesCallCount = 0
    private(set) var lastSavedStates: [HydrationChallengeState] = []
    private(set) var fetchBadgeHistoriesCallCount = 0
    private(set) var saveBadgeHistoriesCallCount = 0
    private(set) var lastSavedBadgeHistories: [HydrationChallengeBadgeHistory] = []

    func fetchChallengeStates() -> [HydrationChallengeState] {
        fetchChallengeStatesCallCount += 1
        return states
    }

    func saveChallengeStates(_ states: [HydrationChallengeState]) {
        saveChallengeStatesCallCount += 1
        self.states = states
        lastSavedStates = states
    }

    func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory] {
        fetchBadgeHistoriesCallCount += 1
        return badgeHistories
    }

    func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory]) {
        saveBadgeHistoriesCallCount += 1
        badgeHistories = histories
        lastSavedBadgeHistories = histories
    }

    func setChallengeStates(_ states: [HydrationChallengeState]) {
        self.states = states
    }

    func setBadgeHistories(_ histories: [HydrationChallengeBadgeHistory]) {
        badgeHistories = histories
    }
}
