import Foundation

public protocol WatchHydrationRepository: Sendable {
    func hydrationEvents(on date: Date) async -> [WatchHydrationEvent]
    @discardableResult
    func addDrink(volumeML: Int, consumedAt: Date) async -> HydrationWriteResult
    @discardableResult
    func resetEvents(on date: Date) async -> HydrationWriteResult
}
