import Foundation
import WatchDomainLayerInterface

public struct WatchHydrationRepositoryImpl: WatchHydrationRepository {
    private let localDataSource: WatchHydrationLocalDataSource

    public init() {
        self.localDataSource = WatchHydrationHealthKitDataSource()
    }

    init(localDataSource: WatchHydrationLocalDataSource) {
        self.localDataSource = localDataSource
    }

    public func hydrationEvents(on date: Date) async -> [WatchHydrationEvent] {
        await localDataSource.hydrationEvents(on: date)
    }

    @discardableResult
    public func addDrink(volumeML: Int, consumedAt: Date) async -> HydrationWriteResult {
        await localDataSource.addDrink(volumeML: volumeML, consumedAt: consumedAt)
    }

    @discardableResult
    public func resetEvents(on date: Date) async -> HydrationWriteResult {
        await localDataSource.resetEvents(on: date)
    }
}
