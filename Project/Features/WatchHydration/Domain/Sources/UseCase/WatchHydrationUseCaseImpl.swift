import Foundation

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

    public func loadSnapshot(referenceDate: Date) async throws -> WatchHydrationSnapshot {
        let dailyGoalML = await dailyGoalRepository.currentGoalML()
        let events = try await hydrationRepository.hydrationEvents(on: referenceDate)
        return makeSnapshot(dailyGoalML: dailyGoalML, events: events)
    }

    public func drinkWater(referenceDate: Date) async throws -> WatchHydrationMutationResult {
        let currentSnapshot = try await loadSnapshot(referenceDate: referenceDate)
        let drinkVolumeML = Int(defaultDrinkVolumeML)

        guard !currentSnapshot.isGoalReached,
              currentSnapshot.dailyGoalML <= 0 ||
              currentSnapshot.todayIntakeML + drinkVolumeML <= currentSnapshot.dailyGoalML else {
            return WatchHydrationMutationResult(
                snapshot: currentSnapshot,
                writeResult: .success
            )
        }

        let saveResult = await hydrationRepository.addDrink(
            volumeML: drinkVolumeML,
            consumedAt: referenceDate
        )

        switch saveResult {
        case let .success(event):
            return WatchHydrationMutationResult(
                snapshot: try? await loadSnapshot(referenceDate: referenceDate),
                writeResult: .success,
                recordedEvent: event
            )
        case let .failure(reason):
            return WatchHydrationMutationResult(snapshot: currentSnapshot, writeResult: .failure(reason))
        }
    }

    public func undoDrink(id: UUID, referenceDate: Date) async -> WatchHydrationMutationResult {
        let writeResult = await hydrationRepository.deleteDrink(id: id)
        return WatchHydrationMutationResult(
            snapshot: try? await loadSnapshot(referenceDate: referenceDate),
            writeResult: writeResult
        )
    }

    public func reset(referenceDate: Date) async throws -> WatchHydrationMutationResult {
        let currentSnapshot = try await loadSnapshot(referenceDate: referenceDate)
        let writeResult = await hydrationRepository.resetEvents(on: referenceDate)
        let snapshot: WatchHydrationSnapshot?
        if writeResult.isSuccess {
            // A completed write is never retried because its refresh failed.
            snapshot = try? await loadSnapshot(referenceDate: referenceDate)
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
