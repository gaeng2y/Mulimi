import Foundation
import HydrationReminderDomain

final class MockHydrationReminderUseCase: HydrationReminderUseCase, @unchecked Sendable {
    var authorizationStatusValue: HydrationReminderAuthorizationStatus = .notDetermined
    var requestAuthorizationResult: Result<HydrationReminderAuthorizationStatus, Error> = .success(.authorized)
    var hasSeenPermissionPrimingValue = false
    private(set) var requestAuthorizationCallCount = 0
    private(set) var syncRemindersCallCount = 0
    private(set) var cancelRemindersCallCount = 0
    private(set) var markPermissionPrimingSeenCallCount = 0

    func authorizationStatus() async -> HydrationReminderAuthorizationStatus {
        authorizationStatusValue
    }

    func requestAuthorizationAndSyncReminders() async throws -> HydrationReminderAuthorizationStatus {
        requestAuthorizationCallCount += 1

        switch requestAuthorizationResult {
        case .success(let status):
            authorizationStatusValue = status
            return status
        case .failure(let error):
            throw error
        }
    }

    func syncReminders() async {
        syncRemindersCallCount += 1
    }

    func cancelReminders() async {
        cancelRemindersCallCount += 1
    }

    func hasSeenPermissionPriming() -> Bool {
        hasSeenPermissionPrimingValue
    }

    func markPermissionPrimingSeen() {
        markPermissionPrimingSeenCallCount += 1
        hasSeenPermissionPrimingValue = true
    }
}
