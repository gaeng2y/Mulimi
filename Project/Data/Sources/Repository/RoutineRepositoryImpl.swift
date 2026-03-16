import DomainLayerInterface
import Foundation

public struct RoutineRepositoryImpl: RoutineRepository {
    private let storageDataSource: RoutineStorageDataSource
    private let notificationDataSource: RoutineNotificationDataSource

    public init(
        storageDataSource: RoutineStorageDataSource,
        notificationDataSource: RoutineNotificationDataSource
    ) {
        self.storageDataSource = storageDataSource
        self.notificationDataSource = notificationDataSource
    }

    public func fetchRoutines() -> [HydrationRoutine] {
        storageDataSource.fetchRoutines()
            .sorted(by: sortRoutines(lhs:rhs:))
    }

    public func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus {
        await notificationDataSource.authorizationStatus()
    }

    public func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
        try await notificationDataSource.requestAuthorization()
    }

    public func saveRoutine(_ routine: HydrationRoutine) async throws {
        if routine.isEnabled {
            let currentStatus = await notificationDataSource.authorizationStatus()
            guard currentStatus == .authorized else {
                throw RoutineError.permissionDenied
            }
        }

        var routines = storageDataSource.fetchRoutines()
        routines = upsert(routine, in: routines)
        storageDataSource.saveRoutines(routines.sorted(by: sortRoutines(lhs:rhs:)))
        try await notificationDataSource.scheduleNotifications(for: routines.filter(\.isEnabled))
    }

    public func deleteRoutine(id: UUID) async throws {
        let routines = storageDataSource.fetchRoutines()
            .filter { $0.id != id }
            .sorted(by: sortRoutines(lhs:rhs:))

        storageDataSource.saveRoutines(routines)
        try await notificationDataSource.scheduleNotifications(for: routines.filter(\.isEnabled))
    }

    private func upsert(_ routine: HydrationRoutine, in routines: [HydrationRoutine]) -> [HydrationRoutine] {
        var updatedRoutines = routines

        if let index = updatedRoutines.firstIndex(where: { $0.id == routine.id }) {
            updatedRoutines[index] = routine
        } else {
            updatedRoutines.append(routine)
        }

        return updatedRoutines
    }

    private func sortRoutines(lhs: HydrationRoutine, rhs: HydrationRoutine) -> Bool {
        if lhs.hour != rhs.hour {
            return lhs.hour < rhs.hour
        }

        if lhs.minute != rhs.minute {
            return lhs.minute < rhs.minute
        }

        return lhs.title < rhs.title
    }
}
