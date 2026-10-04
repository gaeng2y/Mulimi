import Foundation
import WatchHydrationDomain

public struct WatchHydrationRepositoryImpl: WatchHydrationRepository {
    private let localDataSource: WatchHydrationLocalDataSource

    public init() {
        self.localDataSource = WatchHydrationHealthKitDataSource()
    }

    init(localDataSource: WatchHydrationLocalDataSource) {
        self.localDataSource = localDataSource
    }

    public func hydrationEvents(on date: Date) async throws -> [WatchHydrationEvent] {
        try await localDataSource.hydrationEvents(on: date)
    }

    @discardableResult
    public func addDrink(
        volumeML: Int,
        consumedAt: Date
    ) async -> Result<WatchHydrationEvent, HydrationWriteFailureReason> {
        await localDataSource.addDrink(volumeML: volumeML, consumedAt: consumedAt)
    }

    public func deleteDrink(id: UUID) async -> HydrationWriteResult {
        await localDataSource.deleteDrink(id: id)
    }

    @discardableResult
    public func resetEvents(on date: Date) async -> HydrationWriteResult {
        await localDataSource.resetEvents(on: date)
    }
}
