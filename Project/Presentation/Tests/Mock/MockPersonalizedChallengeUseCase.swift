import DomainLayerInterface
import Foundation

final class MockPersonalizedChallengeUseCase: PersonalizedChallengeUseCase, @unchecked Sendable {
    var challenges: [PersonalizedHydrationChallenge] = []
    private(set) var requestedReferenceDate: Date?

    func fetchPersonalizedChallenges(
        snapshot: HydrationProgressSnapshot,
        referenceDate: Date,
        calendar: Calendar
    ) async -> [PersonalizedHydrationChallenge] {
        requestedReferenceDate = referenceDate
        return challenges
    }
}
