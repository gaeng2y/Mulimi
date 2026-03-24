import Foundation

public protocol WatchHydrationRepository: Sendable {
    func hydrationEvents(on date: Date) async -> [WatchHydrationEvent]
    func addDrink(volumeML: Int, consumedAt: Date) async
    func resetEvents(on date: Date) async
}
