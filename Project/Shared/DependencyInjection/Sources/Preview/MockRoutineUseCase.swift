import DomainLayerInterface
import Foundation

public final class MockRoutineUseCase: RoutineUseCase, @unchecked Sendable {
    public var routines: [HydrationRoutine]
    public var authorizationStatus: RoutineNotificationAuthorizationStatus
    public var requestAuthorizationResult: Result<RoutineNotificationAuthorizationStatus, Error> = .success(.authorized)

    public init(
        routines: [HydrationRoutine] = [],
        authorizationStatus: RoutineNotificationAuthorizationStatus = .notDetermined
    ) {
        self.routines = routines
        self.authorizationStatus = authorizationStatus
    }

    public func fetchRoutines() -> [HydrationRoutine] {
        routines
    }

    public func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus {
        authorizationStatus
    }

    public func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
        switch requestAuthorizationResult {
        case .success(let status):
            authorizationStatus = status
            return status
        case .failure(let error):
            throw error
        }
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
