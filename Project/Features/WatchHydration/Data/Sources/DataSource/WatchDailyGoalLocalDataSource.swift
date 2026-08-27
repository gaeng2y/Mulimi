import Foundation

protocol WatchDailyGoalLocalDataSource: Sendable {
    func currentGoalML() async -> Int
}

actor WatchDailyGoalUserDefaultsDataSource: WatchDailyGoalLocalDataSource {
    private let userDefaults: UserDefaults?
    private let ubiquitousStore: NSUbiquitousKeyValueStore

    init(
        userDefaults: UserDefaults? = UserDefaults(suiteName: WatchDataConstants.appGroupIdentifier),
        ubiquitousStore: NSUbiquitousKeyValueStore = .default
    ) {
        self.userDefaults = userDefaults
        self.ubiquitousStore = ubiquitousStore
    }

    func currentGoalML() async -> Int {
        ubiquitousStore.synchronize()

        let syncedValue = Int(ubiquitousStore.double(forKey: WatchDataConstants.dailyGoalKey).rounded())
        if syncedValue > 0 {
            if Int((userDefaults?.double(forKey: WatchDataConstants.dailyGoalKey) ?? 0).rounded()) != syncedValue {
                userDefaults?.set(Double(syncedValue), forKey: WatchDataConstants.dailyGoalKey)
                userDefaults?.synchronize()
            }
            return syncedValue
        }

        let localValue = Int((userDefaults?.double(forKey: WatchDataConstants.dailyGoalKey) ?? 0).rounded())
        if localValue > 0 {
            ubiquitousStore.set(Double(localValue), forKey: WatchDataConstants.dailyGoalKey)
            ubiquitousStore.synchronize()
            return localValue
        }

        return WatchDataConstants.defaultDailyGoalML
    }
}
