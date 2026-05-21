import DataLayer
import DomainLayerInterface
import Foundation
import Testing

@Suite("RoutineRepositoryImpl Tests")
struct RoutineRepositoryImplTests {
    private enum TestError: Error {
        case scheduleFailed
    }

    private final class SpyRoutineStorageDataSource: RoutineStorageDataSource, @unchecked Sendable {
        var routines: [HydrationRoutine] = []
        private(set) var savedRoutines: [HydrationRoutine] = []

        func fetchRoutines() -> [HydrationRoutine] {
            routines
        }

        func saveRoutines(_ routines: [HydrationRoutine]) {
            self.routines = routines
            savedRoutines = routines
        }
    }

    private final class SpyRoutineNotificationDataSource: RoutineNotificationDataSource, @unchecked Sendable {
        var authorizationStatusValue: RoutineNotificationAuthorizationStatus = .notDetermined
        var requestAuthorizationResult: Result<RoutineNotificationAuthorizationStatus, Error> = .success(.authorized)
        var scheduleResults: [Result<Void, Error>] = []
        private(set) var scheduledRoutines: [HydrationRoutine] = []
        private(set) var scheduledRoutineBatches: [[HydrationRoutine]] = []
        private(set) var requestAuthorizationCallCount = 0

        func authorizationStatus() async -> RoutineNotificationAuthorizationStatus {
            authorizationStatusValue
        }

        func requestAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
            requestAuthorizationCallCount += 1
            switch requestAuthorizationResult {
            case .success(let status):
                authorizationStatusValue = status
                return status
            case .failure(let error):
                throw error
            }
        }

        func scheduleNotifications(for routines: [HydrationRoutine]) async throws {
            scheduledRoutineBatches.append(routines)
            let result = scheduleResults.isEmpty ? .success(()) : scheduleResults.removeFirst()

            switch result {
            case .success:
                scheduledRoutines = routines
            case .failure(let error):
                throw error
            }
        }
    }

    @Test("saveRoutine는 권한이 허용된 활성 루틴을 저장하고 스케줄링한다")
    func saveRoutineSchedulesAuthorizedRoutine() async throws {
        let storage = SpyRoutineStorageDataSource()
        let notification = SpyRoutineNotificationDataSource()
        notification.authorizationStatusValue = .authorized
        let repository = RoutineRepositoryImpl(
            storageDataSource: storage,
            notificationDataSource: notification
        )
        let routine = HydrationRoutine(
            title: "오전 루틴",
            hour: 9,
            minute: 0,
            weekdays: [.monday, .friday],
            isEnabled: true
        )

        try await repository.saveRoutine(routine)

        #expect(notification.requestAuthorizationCallCount == 0)
        #expect(storage.savedRoutines == [routine])
        #expect(notification.scheduledRoutines == [routine])
    }

    @Test("saveRoutine는 스케줄 성공 후 저장소를 갱신한다")
    func saveRoutineCommitsStorageAfterScheduleSucceeds() async throws {
        let storage = SpyRoutineStorageDataSource()
        let notification = SpyRoutineNotificationDataSource()
        notification.authorizationStatusValue = .authorized
        let repository = RoutineRepositoryImpl(
            storageDataSource: storage,
            notificationDataSource: notification
        )
        let routine = HydrationRoutine(
            title: "오전 루틴",
            hour: 9,
            minute: 0,
            weekdays: [.monday, .friday],
            isEnabled: true
        )

        try await repository.saveRoutine(routine)

        #expect(notification.scheduledRoutineBatches == [[routine]])
        #expect(storage.savedRoutines == [routine])
    }

    @Test("saveRoutine는 스케줄 실패 시 저장소를 바꾸지 않고 이전 스케줄을 복구한다")
    func saveRoutineScheduleFailureKeepsStorageAndRollsBackSchedule() async {
        let existingRoutine = HydrationRoutine(
            title: "오전 루틴",
            hour: 9,
            minute: 0,
            weekdays: [.monday],
            isEnabled: true
        )
        let newRoutine = HydrationRoutine(
            title: "오후 루틴",
            hour: 15,
            minute: 0,
            weekdays: [.wednesday],
            isEnabled: true
        )
        let storage = SpyRoutineStorageDataSource()
        storage.routines = [existingRoutine]
        let notification = SpyRoutineNotificationDataSource()
        notification.authorizationStatusValue = .authorized
        notification.scheduleResults = [.failure(TestError.scheduleFailed), .success(())]
        let repository = RoutineRepositoryImpl(
            storageDataSource: storage,
            notificationDataSource: notification
        )

        await #expect(throws: RoutineError.scheduleFailed) {
            try await repository.saveRoutine(newRoutine)
        }

        #expect(storage.routines == [existingRoutine])
        #expect(storage.savedRoutines.isEmpty)
        #expect(notification.scheduledRoutineBatches == [[existingRoutine, newRoutine], [existingRoutine]])
        #expect(notification.scheduledRoutines == [existingRoutine])
    }

    @Test("saveRoutine는 수정 스케줄 실패 시 기존 루틴을 유지한다")
    func updateRoutineScheduleFailureKeepsPreviousRoutine() async {
        let existingRoutine = HydrationRoutine(
            title: "오전 루틴",
            hour: 9,
            minute: 0,
            weekdays: [.monday],
            isEnabled: true
        )
        var updatedRoutine = existingRoutine
        updatedRoutine.title = "변경된 루틴"
        updatedRoutine.hour = 10
        let storage = SpyRoutineStorageDataSource()
        storage.routines = [existingRoutine]
        let notification = SpyRoutineNotificationDataSource()
        notification.authorizationStatusValue = .authorized
        notification.scheduleResults = [.failure(TestError.scheduleFailed), .success(())]
        let repository = RoutineRepositoryImpl(
            storageDataSource: storage,
            notificationDataSource: notification
        )

        await #expect(throws: RoutineError.scheduleFailed) {
            try await repository.saveRoutine(updatedRoutine)
        }

        #expect(storage.routines == [existingRoutine])
        #expect(storage.savedRoutines.isEmpty)
        #expect(notification.scheduledRoutineBatches == [[updatedRoutine], [existingRoutine]])
        #expect(notification.scheduledRoutines == [existingRoutine])
    }

    @Test("saveRoutine는 권한이 거부된 활성 루틴을 저장하지 않고 에러를 던진다")
    func saveRoutineDeniedPermission() async {
        let storage = SpyRoutineStorageDataSource()
        let notification = SpyRoutineNotificationDataSource()
        notification.authorizationStatusValue = .denied
        let repository = RoutineRepositoryImpl(
            storageDataSource: storage,
            notificationDataSource: notification
        )
        let routine = HydrationRoutine(
            title: "점심 루틴",
            hour: 12,
            minute: 0,
            weekdays: [.monday, .tuesday],
            isEnabled: true
        )

        await #expect(throws: RoutineError.permissionDenied) {
            try await repository.saveRoutine(routine)
        }

        #expect(storage.savedRoutines.isEmpty)
        #expect(notification.scheduledRoutines.isEmpty)
    }

    @Test("saveRoutine는 권한이 미정인 활성 루틴을 저장하지 않고 에러를 던진다")
    func saveRoutineNotDeterminedPermission() async {
        let storage = SpyRoutineStorageDataSource()
        let notification = SpyRoutineNotificationDataSource()
        notification.authorizationStatusValue = .notDetermined
        let repository = RoutineRepositoryImpl(
            storageDataSource: storage,
            notificationDataSource: notification
        )
        let routine = HydrationRoutine(
            title: "오후 루틴",
            hour: 15,
            minute: 0,
            weekdays: [.wednesday],
            isEnabled: true
        )

        await #expect(throws: RoutineError.permissionDenied) {
            try await repository.saveRoutine(routine)
        }

        #expect(notification.requestAuthorizationCallCount == 0)
        #expect(storage.savedRoutines.isEmpty)
        #expect(notification.scheduledRoutines.isEmpty)
    }

    @Test("deleteRoutine는 저장소와 스케줄을 함께 갱신한다")
    func deleteRoutineUpdatesStorageAndSchedule() async throws {
        let storage = SpyRoutineStorageDataSource()
        let notification = SpyRoutineNotificationDataSource()
        let remainingRoutine = HydrationRoutine(
            title: "저녁 루틴",
            hour: 18,
            minute: 0,
            weekdays: [.monday, .wednesday],
            isEnabled: true
        )
        let removedRoutine = HydrationRoutine(
            title: "아침 루틴",
            hour: 8,
            minute: 0,
            weekdays: [.tuesday],
            isEnabled: true
        )
        storage.routines = [removedRoutine, remainingRoutine]

        let repository = RoutineRepositoryImpl(
            storageDataSource: storage,
            notificationDataSource: notification
        )

        try await repository.deleteRoutine(id: removedRoutine.id)

        #expect(storage.savedRoutines == [remainingRoutine])
        #expect(notification.scheduledRoutines == [remainingRoutine])
    }

    @Test("deleteRoutine는 스케줄 실패 시 저장소를 바꾸지 않고 이전 스케줄을 복구한다")
    func deleteRoutineScheduleFailureKeepsStorageAndRollsBackSchedule() async {
        let remainingRoutine = HydrationRoutine(
            title: "저녁 루틴",
            hour: 18,
            minute: 0,
            weekdays: [.monday, .wednesday],
            isEnabled: true
        )
        let removedRoutine = HydrationRoutine(
            title: "아침 루틴",
            hour: 8,
            minute: 0,
            weekdays: [.tuesday],
            isEnabled: true
        )
        let storage = SpyRoutineStorageDataSource()
        storage.routines = [removedRoutine, remainingRoutine]
        let notification = SpyRoutineNotificationDataSource()
        notification.scheduleResults = [.failure(TestError.scheduleFailed), .success(())]
        let repository = RoutineRepositoryImpl(
            storageDataSource: storage,
            notificationDataSource: notification
        )

        await #expect(throws: RoutineError.scheduleFailed) {
            try await repository.deleteRoutine(id: removedRoutine.id)
        }

        #expect(storage.routines == [removedRoutine, remainingRoutine])
        #expect(storage.savedRoutines.isEmpty)
        #expect(notification.scheduledRoutineBatches == [[remainingRoutine], [removedRoutine, remainingRoutine]])
        #expect(notification.scheduledRoutines == [removedRoutine, remainingRoutine])
    }
}
