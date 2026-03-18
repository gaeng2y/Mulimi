import DomainLayerInterface
import Foundation

final class MockChallengeUseCase: ChallengeUseCase, @unchecked Sendable {
    var challenges: [HydrationChallenge] = []
    private(set) var requestedReferenceDate: Date?

    func fetchChallenges(referenceDate: Date, calendar: Calendar) async -> [HydrationChallenge] {
        requestedReferenceDate = referenceDate
        return challenges
    }
}
