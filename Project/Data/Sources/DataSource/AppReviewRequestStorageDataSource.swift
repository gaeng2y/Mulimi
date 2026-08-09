import DomainLayerInterface
import Foundation
import Utils

public protocol AppReviewRequestStorageDataSource: Sendable {
    func fetchState() -> AppReviewRequestState
    func saveState(_ state: AppReviewRequestState)
}

public final class AppReviewRequestStorageDataSourceImpl: AppReviewRequestStorageDataSource,
                                                          @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func fetchState() -> AppReviewRequestState {
        guard let data = userDefaults.data(forKey: .appReviewRequestState) else {
            return .empty
        }

        return (try? decoder.decode(AppReviewRequestState.self, from: data)) ?? .empty
    }

    public func saveState(_ state: AppReviewRequestState) {
        guard let data = try? encoder.encode(state) else {
            return
        }

        userDefaults.set(data, forKey: .appReviewRequestState)
        userDefaults.synchronize()
    }
}
