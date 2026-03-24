import Foundation

public protocol ChallengeRepository: Sendable {
    func fetchChallengeStates() -> [HydrationChallengeState]
    func saveChallengeStates(_ states: [HydrationChallengeState])
    func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory]
    func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory])
}
