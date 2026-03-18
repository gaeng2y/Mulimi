import Foundation

public protocol ChallengeRepository: Sendable {
    func fetchChallengeStates() -> [HydrationChallengeState]
    func saveChallengeStates(_ states: [HydrationChallengeState])
}
