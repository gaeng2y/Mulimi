import DomainLayerInterface
import Foundation

public final class MockRoutineUseCaseForTesting: RoutineUseCase, @unchecked Sendable {
    public var routines: [HydrationRoutine] = []
    public var authorizationStatus: RoutineNotificationAuthorizationStatus = .notDetermined

    public init() {}

    public func fetchRoutines() -> [HydrationRoutine] {
        routines
    }

    public func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus {
        authorizationStatus
    }

    public func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
        authorizationStatus = .authorized
        return authorizationStatus
    }

    public func saveRoutine(_ routine: HydrationRoutine) async throws {
        if let index = routines.firstIndex(where: { $0.id == routine.id }) {
            routines[index] = routine
        } else {
            routines.append(routine)
        }
    }

    public func deleteRoutine(id: UUID) async throws {
        routines.removeAll { $0.id == id }
    }
}
