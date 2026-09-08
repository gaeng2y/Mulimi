import Foundation
import HydrationReminderDomain

public final class MockHydrationReminderUseCase: HydrationReminderUseCase, @unchecked Sendable {
    public var authorizationStatusValue: HydrationReminderAuthorizationStatus
    public var requestAuthorizationResult: Result<HydrationReminderAuthorizationStatus, Error> = .success(.authorized)
    public var hasSeenPriming: Bool

    public init(
        authorizationStatus: HydrationReminderAuthorizationStatus = .notDetermined,
        hasSeenPriming: Bool = false
    ) {
        self.authorizationStatusValue = authorizationStatus
        self.hasSeenPriming = hasSeenPriming
    }

    public func authorizationStatus() async -> HydrationReminderAuthorizationStatus {
        authorizationStatusValue
    }

    public func requestAuthorizationAndSyncReminders() async throws -> HydrationReminderAuthorizationStatus {
        switch requestAuthorizationResult {
        case .success(let status):
            authorizationStatusValue = status
            return status
        case .failure(let error):
            throw error
        }
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
