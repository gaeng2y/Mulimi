import DomainLayerInterface
import Foundation

final class MockDrinkWaterUseCase: DrinkWaterUseCase, @unchecked Sendable {
    var currentWaterIntakeMLValue: Double = 0

    var migrateLegacyDataIfNeededCallCount: Int = 0
    var drinkWaterCallCount: Int = 0
    var recordedVolumesML: [Int] = []
    var resetCallCount: Int = 0

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

    func drinkWater() async {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    func drinkWater(volumeML: Int) async {
        drinkWaterCallCount += 1
        recordedVolumesML.append(volumeML)
        currentWaterIntakeMLValue += Double(volumeML)
    }

    func reset() async {
        resetCallCount += 1
        currentWaterIntakeMLValue = 0
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
