import DomainLayerInterface

public struct AppReviewRequestRepositoryImpl: AppReviewRequestRepository {
    private let storageDataSource: AppReviewRequestStorageDataSource

    public init(storageDataSource: AppReviewRequestStorageDataSource) {
        self.storageDataSource = storageDataSource
    }

    public func fetchState() -> AppReviewRequestState {
        storageDataSource.fetchState()
    }

    public func saveState(_ state: AppReviewRequestState) {
        storageDataSource.saveState(state)
    }
}
