import DomainLayerInterface
import Foundation

final class MockDrinkWaterUseCase: DrinkWaterUseCase, @unchecked Sendable {
    var currentWaterValue: Int = 0

    var migrateLegacyDataIfNeededCallCount: Int = 0
    var drinkWaterCallCount: Int = 0
    var resetCallCount: Int = 0

    private var hydrationEventsByDay: [String: [HydrationEvent]] = [:]

    var currentWater: Int {
        get async {
            currentWaterValue
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
        drinkWaterCallCount += 1
        currentWaterValue += 1
    }

    func reset() async {
        resetCallCount += 1
        currentWaterValue = 0
    }

    func setHydrationEvents(_ events: [HydrationEvent], on date: Date) {
        hydrationEventsByDay[dayKey(for: date)] = events
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
