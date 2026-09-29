import Foundation

public protocol WatchHydrationUseCase: Sendable {
    func loadSnapshot(referenceDate: Date) async throws -> WatchHydrationSnapshot
    func drinkWater(referenceDate: Date) async throws -> WatchHydrationMutationResult
    func undoDrink(id: UUID, referenceDate: Date) async -> WatchHydrationMutationResult
    func reset(referenceDate: Date) async throws -> WatchHydrationMutationResult
}
