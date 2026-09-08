import Foundation
import HydrationReminderDomain
import Utils

public protocol HydrationReminderStorageDataSource: Sendable {
    func hasSeenPermissionPriming() -> Bool
    func setHasSeenPermissionPriming(_ seen: Bool)
}

public final class HydrationReminderStorageDataSourceImpl: HydrationReminderStorageDataSource,
                                                           @unchecked Sendable {
    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func hasSeenPermissionPriming() -> Bool {
        userDefaults.bool(forKey: .hasSeenHydrationReminderPriming)
    }

    public func setHasSeenPermissionPriming(_ seen: Bool) {
        userDefaults.set(seen, forKey: .hasSeenHydrationReminderPriming)
        userDefaults.synchronize()
    }
}
