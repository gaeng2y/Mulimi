import Foundation

public protocol WatchHydrationUseCase: Sendable {
    func loadSnapshot(referenceDate: Date) async -> WatchHydrationSnapshot
    func drinkWater(referenceDate: Date) async -> WatchHydrationSnapshot
    func reset(referenceDate: Date) async -> WatchHydrationSnapshot
}
