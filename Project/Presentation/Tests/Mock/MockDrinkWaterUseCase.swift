import DomainLayerInterface
import Foundation

final class MockDrinkWaterUseCase: DrinkWaterUseCase, @unchecked Sendable {
    var currentWaterIntakeMLValue: Double = 0

    var migrateLegacyDataIfNeededCallCount: Int = 0
    var drinkWaterCallCount: Int = 0
    var recordedVolumesML: [Int] = []
    var resetCallCount: Int = 0
    var deleteHydrationEventCallCount: Int = 0
    var deletedHydrationEventIDs: [UUID] = []
    var drinkWaterResult: HydrationWriteResult = .success
    var resetResult: HydrationWriteResult = .success
    var shouldDeleteHydrationEventSucceed = true

    private var hydrationEventsByDay: [String: [HydrationEvent]] = [:]

    var currentWaterIntakeML: Double {
        get async {
            currentWaterIntakeMLValue
        }
    }

    func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        hydrationEventsByDay[dayKey(for: date)] ?? []
    }

    func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent] {
        hydrationEventsByDay.values
            .flatMap { $0 }
            .filter { interval.contains($0.consumedAt) }
            .sorted { $0.consumedAt < $1.consumedAt }
    }

    func migrateLegacyDataIfNeeded() async {
        migrateLegacyDataIfNeededCallCount += 1
    }

    @discardableResult
    func drinkWater() async -> HydrationWriteResult {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    @discardableResult
    func drinkWater(volumeML: Int) async -> HydrationWriteResult {
        drinkWaterCallCount += 1
        recordedVolumesML.append(volumeML)
        guard drinkWaterResult.isSuccess else {
            return drinkWaterResult
        }

        currentWaterIntakeMLValue += Double(volumeML)
        let now = Date.now
        hydrationEventsByDay[dayKey(for: now), default: []].append(
            HydrationEvent(
                id: UUID(),
                consumedAt: now,
                volumeML: volumeML
            )
        )
        return drinkWaterResult
    }

    @discardableResult
    func reset() async -> HydrationWriteResult {
        resetCallCount += 1
        guard resetResult.isSuccess else {
            return resetResult
        }

        currentWaterIntakeMLValue = 0
        hydrationEventsByDay.removeAll()
        return resetResult
    }

    func deleteHydrationEvent(id: UUID) async -> Bool {
        deleteHydrationEventCallCount += 1
        deletedHydrationEventIDs.append(id)

        guard shouldDeleteHydrationEventSucceed else {
            return false
        }

        for key in Array(hydrationEventsByDay.keys) {
            guard let index = hydrationEventsByDay[key]?.firstIndex(where: {
                $0.id == id && $0.isOwnedByCurrentApp
            }) else {
                continue
            }

            let event = hydrationEventsByDay[key]?.remove(at: index)
            currentWaterIntakeMLValue = max(currentWaterIntakeMLValue - Double(event?.volumeML ?? 0), 0)
            return true
        }

        return false
    }

    func setHydrationEvents(_ events: [HydrationEvent], on date: Date) {
        hydrationEventsByDay[dayKey(for: date)] = events
        currentWaterIntakeMLValue = hydrationEventsByDay.values
            .flatMap { $0 }
            .reduce(0) { $0 + Double($1.volumeML) }
    }

    private func dayKey(for date: Date) -> String {
        let dayStart = Calendar.current.startOfDay(for: date)
        let formatter = DateFormatter()
        formatter.calendar = Calendar.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: dayStart)
    }
}
