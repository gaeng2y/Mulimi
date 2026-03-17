import Foundation

public protocol ChallengeUseCase: Sendable {
    func fetchChallenges(referenceDate: Date, calendar: Calendar) async -> [HydrationChallenge]
}
