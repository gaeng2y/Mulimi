import Foundation

public protocol RoutineRepository: Sendable {
    func fetchRoutines() -> [HydrationRoutine]
    func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus
    func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus
    func saveRoutine(_ routine: HydrationRoutine) async throws
    func deleteRoutine(id: UUID) async throws
}
