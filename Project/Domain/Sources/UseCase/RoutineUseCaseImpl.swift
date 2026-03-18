import DomainLayerInterface
import Foundation

public struct RoutineUseCaseImpl: RoutineUseCase {
    private let repository: RoutineRepository

    public init(repository: RoutineRepository) {
        self.repository = repository
    }

    public func fetchRoutines() -> [HydrationRoutine] {
        repository.fetchRoutines()
    }

    public func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus {
        await repository.notificationAuthorizationStatus()
    }

    public func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
        try await repository.requestNotificationAuthorization()
    }

    public func saveRoutine(_ routine: HydrationRoutine) async throws {
        try await repository.saveRoutine(routine)
    }

    public func deleteRoutine(id: UUID) async throws {
        try await repository.deleteRoutine(id: id)
    }
}
