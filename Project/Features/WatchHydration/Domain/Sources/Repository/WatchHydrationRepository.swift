import Foundation

public protocol WatchHydrationRepository: Sendable {
    func hydrationEvents(on date: Date) async throws -> [WatchHydrationEvent]
    @discardableResult
    func addDrink(volumeML: Int, consumedAt: Date) async -> Result<WatchHydrationEvent, HydrationWriteFailureReason>
    func deleteDrink(id: UUID) async -> HydrationWriteResult
    @discardableResult
    func resetEvents(on date: Date) async -> HydrationWriteResult
}
