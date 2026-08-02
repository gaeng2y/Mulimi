import Foundation

public protocol HydrationReminderUseCase: Sendable {
    func authorizationStatus() async -> HydrationReminderAuthorizationStatus
    func requestAuthorizationAndSyncReminders() async throws -> HydrationReminderAuthorizationStatus
    func syncReminders() async
    func hasSeenPermissionPriming() -> Bool
    func markPermissionPrimingSeen()
}
