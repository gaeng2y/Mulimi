import Foundation

public protocol HydrationReminderRepository: Sendable {
    func authorizationStatus() async -> HydrationReminderAuthorizationStatus
    func requestAuthorization() async throws -> HydrationReminderAuthorizationStatus
    func scheduleDailyReminders(for slots: [HydrationReminderSlot]) async throws
    func cancelDailyReminders() async
    func hasSeenPermissionPriming() -> Bool
    func setHasSeenPermissionPriming(_ seen: Bool)
}
