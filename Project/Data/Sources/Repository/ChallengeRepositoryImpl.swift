import DomainLayerInterface
import Foundation

public struct ChallengeRepositoryImpl: ChallengeRepository {
    private let storageDataSource: ChallengeStorageDataSource

    public init(storageDataSource: ChallengeStorageDataSource) {
        self.storageDataSource = storageDataSource
    }

    public func fetchChallengeStates() -> [HydrationChallengeState] {
        storageDataSource.fetchChallengeStates()
    }

    public func saveChallengeStates(_ states: [HydrationChallengeState]) {
        storageDataSource.saveChallengeStates(states)
    }

    public func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory] {
        storageDataSource.fetchBadgeHistories()
    }

    public func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory]) {
        storageDataSource.saveBadgeHistories(histories)
    }
}
