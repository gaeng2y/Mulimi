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

    public func addDrink(volumeML: Int, consumedAt: Date) async {
        await localDataSource.addDrink(volumeML: volumeML, consumedAt: consumedAt)
    }

    public func resetEvents(on date: Date) async {
        await localDataSource.resetEvents(on: date)
    }
}
