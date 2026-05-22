import Foundation
import WatchDomainLayerInterface

public struct WatchHydrationUseCaseImpl: WatchHydrationUseCase {
    private let hydrationRepository: WatchHydrationRepository
    private let dailyGoalRepository: WatchDailyGoalRepository
    private let defaultDrinkVolumeML: Double

    public init(
        hydrationRepository: WatchHydrationRepository,
        dailyGoalRepository: WatchDailyGoalRepository,
        defaultDrinkVolumeML: Double = Double(HydrationServing.defaultGlassVolumeML)
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

    public func drinkWater(referenceDate: Date) async -> WatchHydrationMutationResult {
        let currentSnapshot = await loadSnapshot(referenceDate: referenceDate)
        let drinkVolumeML = Int(defaultDrinkVolumeML)

        guard !currentSnapshot.isGoalReached,
              currentSnapshot.dailyGoalML <= 0 ||
              currentSnapshot.todayIntakeML + drinkVolumeML <= currentSnapshot.dailyGoalML else {
            return WatchHydrationMutationResult(
                snapshot: currentSnapshot,
                writeResult: .success
            )
        }

        let writeResult = await hydrationRepository.addDrink(
            volumeML: drinkVolumeML,
            consumedAt: referenceDate
        )

        let snapshot: WatchHydrationSnapshot
        if writeResult.isSuccess {
            snapshot = await loadSnapshot(referenceDate: referenceDate)
        } else {
            snapshot = currentSnapshot
        }

        return WatchHydrationMutationResult(
            snapshot: snapshot,
            writeResult: writeResult
        )
    }

    public func reset(referenceDate: Date) async -> WatchHydrationMutationResult {
        let currentSnapshot = await loadSnapshot(referenceDate: referenceDate)
        let writeResult = await hydrationRepository.resetEvents(on: referenceDate)
        let snapshot: WatchHydrationSnapshot
        if writeResult.isSuccess {
            snapshot = await loadSnapshot(referenceDate: referenceDate)
        } else {
            snapshot = currentSnapshot
        }

        return WatchHydrationMutationResult(
            snapshot: snapshot,
            writeResult: writeResult
        )
    }

    private func makeSnapshot(
        dailyGoalML: Int,
        events: [WatchHydrationEvent]
    ) -> WatchHydrationSnapshot {
        let sortedEvents = events.sorted { $0.consumedAt < $1.consumedAt }
        let todayIntakeML = sortedEvents.reduce(0) { $0 + $1.volumeML }

        return WatchHydrationSnapshot(
            dailyGoalML: dailyGoalML,
            todayIntakeML: todayIntakeML,
            events: sortedEvents,
            nextActionGuide: HydrationNextActionGuide.make(
                currentIntakeML: Double(todayIntakeML),
                dailyGoalML: Double(dailyGoalML)
            )
        )
    }
}
