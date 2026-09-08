import Foundation
import HydrationReminderDomain

final class MockHydrationReminderRepository: HydrationReminderRepository, @unchecked Sendable {
    var authorizationStatusValue: HydrationReminderAuthorizationStatus = .notDetermined
    var requestAuthorizationResult: Result<HydrationReminderAuthorizationStatus, Error> = .success(.authorized)
    var scheduleDailyRemindersError: Error?
    var scheduleDailyRemindersCallCount = 0
    var cancelDailyRemindersCallCount = 0
    var capturedSlots: [HydrationReminderSlot] = []
    var hasSeenPermissionPrimingValue = false

    func authorizationStatus() async -> HydrationReminderAuthorizationStatus {
        authorizationStatusValue
    }

    func requestAuthorization() async throws -> HydrationReminderAuthorizationStatus {
        switch requestAuthorizationResult {
        case .success(let status):
            authorizationStatusValue = status
            return status
        case .failure(let error):
            throw error
        }
    }

    func scheduleDailyReminders(for slots: [HydrationReminderSlot]) async throws {
        if let scheduleDailyRemindersError {
            throw scheduleDailyRemindersError
        }

        scheduleDailyRemindersCallCount += 1
        capturedSlots = slots
    }

    func cancelDailyReminders() async {
        cancelDailyRemindersCallCount += 1
    }

    func hasSeenPermissionPriming() -> Bool {
        hasSeenPermissionPrimingValue
    }

    func setHasSeenPermissionPriming(_ seen: Bool) {
        hasSeenPermissionPrimingValue = seen
    }
}
