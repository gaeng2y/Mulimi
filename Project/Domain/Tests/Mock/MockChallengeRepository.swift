import DomainLayerInterface
import Foundation

final class MockChallengeRepository: ChallengeRepository, @unchecked Sendable {
    private var states: [HydrationChallengeState] = []

    private(set) var fetchChallengeStatesCallCount = 0
    private(set) var saveChallengeStatesCallCount = 0
    private(set) var lastSavedStates: [HydrationChallengeState] = []

    func fetchChallengeStates() -> [HydrationChallengeState] {
        fetchChallengeStatesCallCount += 1
        return states
    }

    func saveChallengeStates(_ states: [HydrationChallengeState]) {
        saveChallengeStatesCallCount += 1
        self.states = states
        lastSavedStates = states
    }

    func setChallengeStates(_ states: [HydrationChallengeState]) {
        self.states = states
    }
}
