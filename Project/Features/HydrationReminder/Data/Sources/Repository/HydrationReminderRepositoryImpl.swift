import Foundation
import HydrationReminderDomain

public struct HydrationReminderRepositoryImpl: HydrationReminderRepository {
    private let notificationDataSource: HydrationReminderNotificationDataSource
    private let storageDataSource: HydrationReminderStorageDataSource

    public init(
        notificationDataSource: HydrationReminderNotificationDataSource,
        storageDataSource: HydrationReminderStorageDataSource
    ) {
        self.notificationDataSource = notificationDataSource
        self.storageDataSource = storageDataSource
    }

    public func authorizationStatus() async -> HydrationReminderAuthorizationStatus {
        await notificationDataSource.authorizationStatus()
    }

    public func requestAuthorization() async throws -> HydrationReminderAuthorizationStatus {
        try await notificationDataSource.requestAuthorization()
    }

    public func scheduleDailyReminders(for slots: [HydrationReminderSlot]) async throws {
        try await notificationDataSource.scheduleDailyReminders(for: slots)
    }

    public func cancelDailyReminders() async {
        await notificationDataSource.cancelDailyReminders()
    }

    public func hasSeenPermissionPriming() -> Bool {
        storageDataSource.hasSeenPermissionPriming()
    }

    public func setHasSeenPermissionPriming(_ seen: Bool) {
        storageDataSource.setHasSeenPermissionPriming(seen)
    }
}
