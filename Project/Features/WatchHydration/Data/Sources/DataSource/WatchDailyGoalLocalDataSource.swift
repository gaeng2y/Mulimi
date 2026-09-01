import Foundation
import MulimiCloudKit

protocol WatchDailyGoalLocalDataSource: Sendable {
    func currentGoalML() async -> Int
}

actor WatchDailyGoalUserDefaultsDataSource: WatchDailyGoalLocalDataSource {
    private let syncedStore: SyncedValueStoring

    init(
        userDefaults: UserDefaults? = UserDefaults(suiteName: WatchDataConstants.appGroupIdentifier),
        ubiquitousStore: NSUbiquitousKeyValueStore = .default
    ) {
        self.syncedStore = UbiquitousMirroredStore(
            userDefaults: userDefaults,
            ubiquitousStore: ubiquitousStore
        )
    }

    func currentGoalML() async -> Int {
        Int(
            syncedStore.double(
                forKey: WatchDataConstants.dailyGoalKey,
                default: Double(WatchDataConstants.defaultDailyGoalML)
            ).rounded()
        )
    }
}
