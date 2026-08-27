import Foundation
import HydrationReminderDomain

public final class MockHydrationReminderUseCaseForTesting: HydrationReminderUseCase, @unchecked Sendable {
    public var authorizationStatusValue: HydrationReminderAuthorizationStatus = .notDetermined
    public var hasSeenPriming = false

    public init() {}

    public func authorizationStatus() async -> HydrationReminderAuthorizationStatus {
        authorizationStatusValue
    }

    public func requestAuthorizationAndSyncReminders() async throws -> HydrationReminderAuthorizationStatus {
        authorizationStatusValue = .authorized
        return authorizationStatusValue
    }

    public func syncReminders() async {}

    public func cancelReminders() async {}

    public func hasSeenPermissionPriming() -> Bool {
        hasSeenPriming
    }

    public func markPermissionPrimingSeen() {
        hasSeenPriming = true
    }
}
