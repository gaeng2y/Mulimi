import DomainLayerInterface
import Foundation

final class MockRoutineRepository: RoutineRepository, @unchecked Sendable {
    var routines: [HydrationRoutine] = []
    var authorizationStatus: RoutineNotificationAuthorizationStatus = .notDetermined
    var requestAuthorizationResult: Result<RoutineNotificationAuthorizationStatus, Error> = .success(.authorized)
    var saveRoutineCallCount = 0
    var deleteRoutineCallCount = 0
    var capturedRoutine: HydrationRoutine?
    var capturedDeletedRoutineID: UUID?

    func fetchRoutines() -> [HydrationRoutine] {
        routines
    }

    func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus {
        authorizationStatus
    }

    func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
        switch requestAuthorizationResult {
        case .success(let status):
            authorizationStatus = status
            return status
        case .failure(let error):
            throw error
        }
    }

    func saveRoutine(_ routine: HydrationRoutine) async throws {
        saveRoutineCallCount += 1
        capturedRoutine = routine
        if let index = routines.firstIndex(where: { $0.id == routine.id }) {
            routines[index] = routine
        } else {
            routines.append(routine)
        }
    }

    func deleteRoutine(id: UUID) async throws {
        deleteRoutineCallCount += 1
        capturedDeletedRoutineID = id
        routines.removeAll { $0.id == id }
    }
}
