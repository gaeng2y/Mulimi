import Foundation

public protocol ChallengeRepository: Sendable {
    func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory]
    func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory])
}
