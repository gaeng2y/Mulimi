import Foundation
import HydrationDomain

public protocol PersonalizedChallengeUseCase: Sendable {
    func fetchPersonalizedChallenges(
        snapshot: HydrationProgressSnapshot,
        referenceDate: Date,
        calendar: Calendar
    ) async -> [PersonalizedHydrationChallenge]
}
