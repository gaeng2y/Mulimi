import WatchDomainLayerInterface

public struct WatchDailyGoalRepositoryImpl: WatchDailyGoalRepository {
    private let localDataSource: WatchDailyGoalLocalDataSource

    public init() {
        self.localDataSource = WatchDailyGoalUserDefaultsDataSource()
    }

    init(localDataSource: WatchDailyGoalLocalDataSource) {
        self.localDataSource = localDataSource
    }

    public func currentGoalML() async -> Int {
        await localDataSource.currentGoalML()
    }
}
