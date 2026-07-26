import DataLayer
import DomainLayerInterface
import Foundation
import Testing

@Suite("HydrationReminderRepositoryImpl Tests")
struct HydrationReminderRepositoryImplTests {
    private enum TestError: Error {
        case scheduleFailed
    }

    private final class SpyHydrationReminderNotificationDataSource: HydrationReminderNotificationDataSource,
                                                                    @unchecked Sendable {
        var authorizationStatusValue: HydrationReminderAuthorizationStatus = .notDetermined
        var requestAuthorizationResult: Result<HydrationReminderAuthorizationStatus, Error> = .success(.authorized)
        var scheduleError: Error?
        private(set) var scheduledSlots: [HydrationReminderSlot] = []
        private(set) var scheduleCallCount = 0
        private(set) var cancelCallCount = 0

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
            if let scheduleError {
                throw scheduleError
            }

            scheduleCallCount += 1
            scheduledSlots = slots
        }

        func cancelDailyReminders() async {
            cancelCallCount += 1
        }
    }

    private final class SpyHydrationReminderStorageDataSource: HydrationReminderStorageDataSource,
                                                               @unchecked Sendable {
        var hasSeenPermissionPrimingValue = false

        func hasSeenPermissionPriming() -> Bool {
            hasSeenPermissionPrimingValue
        }

        func setHasSeenPermissionPriming(_ seen: Bool) {
            hasSeenPermissionPrimingValue = seen
        }
    }

    @Test("authorizationStatus는 알림 데이터소스 상태를 반환한다")
    func authorizationStatus() async {
        let notification = SpyHydrationReminderNotificationDataSource()
        notification.authorizationStatusValue = .authorized
        let repository = HydrationReminderRepositoryImpl(
            notificationDataSource: notification,
            storageDataSource: SpyHydrationReminderStorageDataSource()
        )

        let status = await repository.authorizationStatus()

        #expect(status == .authorized)
    }

    @Test("requestAuthorization는 알림 데이터소스에 위임한다")
    func requestAuthorization() async throws {
        let notification = SpyHydrationReminderNotificationDataSource()
        notification.requestAuthorizationResult = .success(.denied)
        let repository = HydrationReminderRepositoryImpl(
            notificationDataSource: notification,
            storageDataSource: SpyHydrationReminderStorageDataSource()
        )

        let status = try await repository.requestAuthorization()

        #expect(status == .denied)
    }

    @Test("scheduleDailyReminders는 슬롯을 그대로 전달한다")
    func scheduleDailyReminders() async throws {
        let notification = SpyHydrationReminderNotificationDataSource()
        let repository = HydrationReminderRepositoryImpl(
            notificationDataSource: notification,
            storageDataSource: SpyHydrationReminderStorageDataSource()
        )

        try await repository.scheduleDailyReminders(for: HydrationReminderSlot.allCases)

        #expect(notification.scheduleCallCount == 1)
        #expect(notification.scheduledSlots == HydrationReminderSlot.allCases)
    }

    @Test("scheduleDailyReminders는 스케줄 실패를 전파한다")
    func scheduleDailyRemindersPropagatesError() async {
        let notification = SpyHydrationReminderNotificationDataSource()
        notification.scheduleError = TestError.scheduleFailed
        let repository = HydrationReminderRepositoryImpl(
            notificationDataSource: notification,
            storageDataSource: SpyHydrationReminderStorageDataSource()
        )

        await #expect(throws: TestError.scheduleFailed) {
            try await repository.scheduleDailyReminders(for: HydrationReminderSlot.allCases)
        }
    }

    @Test("cancelDailyReminders는 알림 데이터소스에 위임한다")
    func cancelDailyReminders() async {
        let notification = SpyHydrationReminderNotificationDataSource()
        let repository = HydrationReminderRepositoryImpl(
            notificationDataSource: notification,
            storageDataSource: SpyHydrationReminderStorageDataSource()
        )

        await repository.cancelDailyReminders()

        #expect(notification.cancelCallCount == 1)
    }

    @Test("프라이밍 플래그는 스토리지 데이터소스에 위임한다")
    func primingFlagDelegatesToStorage() {
        let storage = SpyHydrationReminderStorageDataSource()
        let repository = HydrationReminderRepositoryImpl(
            notificationDataSource: SpyHydrationReminderNotificationDataSource(),
            storageDataSource: storage
        )

        #expect(repository.hasSeenPermissionPriming() == false)

        repository.setHasSeenPermissionPriming(true)

        #expect(storage.hasSeenPermissionPrimingValue)
        #expect(repository.hasSeenPermissionPriming())
    }
}
