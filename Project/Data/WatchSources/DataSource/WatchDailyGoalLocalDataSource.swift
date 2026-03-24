import Foundation

protocol WatchDailyGoalLocalDataSource: Sendable {
    func currentGoalML() async -> Int
}

actor WatchDailyGoalUserDefaultsDataSource: WatchDailyGoalLocalDataSource {
    private let userDefaults: UserDefaults?

    init(
        userDefaults: UserDefaults? = UserDefaults(
            suiteName: WatchDataConstants.appGroupIdentifier
        )
    ) {
        self.userDefaults = userDefaults
    }

    func currentGoalML() async -> Int {
        let storedValue = Int((userDefaults?.double(forKey: WatchDataConstants.dailyGoalKey) ?? 0).rounded())
        return storedValue > 0 ? storedValue : WatchDataConstants.defaultDailyGoalML
    }
}
