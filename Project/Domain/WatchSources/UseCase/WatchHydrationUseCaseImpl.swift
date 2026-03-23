import Foundation
import WatchDomainLayerInterface

public struct WatchHydrationUseCaseImpl: WatchHydrationUseCase {
    private let hydrationRepository: WatchHydrationRepository
    private let dailyGoalRepository: WatchDailyGoalRepository
    private let defaultDrinkVolumeML: Int

    public init(
        hydrationRepository: WatchHydrationRepository,
        dailyGoalRepository: WatchDailyGoalRepository,
        defaultDrinkVolumeML: Int = 250
    ) {
        self.hydrationRepository = hydrationRepository
        self.dailyGoalRepository = dailyGoalRepository
        self.defaultDrinkVolumeML = defaultDrinkVolumeML
    }

    public func loadSnapshot(referenceDate: Date) async -> WatchHydrationSnapshot {
        let dailyGoalML = await dailyGoalRepository.currentGoalML()
        let events = await hydrationRepository.hydrationEvents(on: referenceDate)
        return makeSnapshot(dailyGoalML: dailyGoalML, events: events)
    }

    public func drinkWater(referenceDate: Date) async -> WatchHydrationSnapshot {
        let currentSnapshot = await loadSnapshot(referenceDate: referenceDate)

        guard !currentSnapshot.isGoalReached else {
            return currentSnapshot
        }

        await hydrationRepository.addDrink(
            volumeML: defaultDrinkVolumeML,
            consumedAt: referenceDate
        )

        return await loadSnapshot(referenceDate: referenceDate)
    }

    public func reset(referenceDate: Date) async -> WatchHydrationSnapshot {
        await hydrationRepository.resetEvents(on: referenceDate)
        return await loadSnapshot(referenceDate: referenceDate)
    }

    private func makeSnapshot(
        dailyGoalML: Int,
        events: [WatchHydrationEvent]
    ) -> WatchHydrationSnapshot {
        let sortedEvents = events.sorted { $0.consumedAt < $1.consumedAt }

        return WatchHydrationSnapshot(
            dailyGoalML: dailyGoalML,
            todayIntakeML: sortedEvents.reduce(0) { $0 + $1.volumeML },
            events: sortedEvents
        )
    }
}
