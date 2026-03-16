import DataLayer
import DomainLayerInterface
import Foundation
import Testing

@Suite("RoutineRepositoryImpl Tests")
struct RoutineRepositoryImplTests {
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
        private(set) var scheduledRoutines: [HydrationRoutine] = []
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
            scheduledRoutines = routines
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
}
