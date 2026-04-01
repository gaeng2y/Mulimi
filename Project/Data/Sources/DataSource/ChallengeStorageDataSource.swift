import DomainLayerInterface
import Foundation
import Utils

public protocol ChallengeStorageDataSource: Sendable {
    func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory]
    func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory])
}

public final class ChallengeStorageDataSourceImpl: ChallengeStorageDataSource, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory] {
        guard let data = userDefaults.data(forKey: .hydrationChallengeBadgeHistories) else {
            return []
        }

        return (try? decoder.decode([HydrationChallengeBadgeHistory].self, from: data)) ?? []
    }

    public func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory]) {
        guard let data = try? encoder.encode(histories) else {
            return
        }

        userDefaults.set(data, forKey: .hydrationChallengeBadgeHistories)
        userDefaults.synchronize()
    }
}
