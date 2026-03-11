import DomainLayerInterface
import Foundation

final class MockDrinkWaterUseCase: DrinkWaterUseCase, @unchecked Sendable {
    var currentWater: Int = 0

    var migrateLegacyDataIfNeededCallCount: Int = 0
    var drinkWaterCallCount: Int = 0
    var resetCallCount: Int = 0

    private var hydrationEventsByDay: [String: [HydrationEvent]] = [:]

    func hydrationEvents(on date: Date) -> [HydrationEvent] {
        hydrationEventsByDay[dayKey(for: date)] ?? []
    }

    func migrateLegacyDataIfNeeded() {
        migrateLegacyDataIfNeededCallCount += 1
    }

    func drinkWater() {
        drinkWaterCallCount += 1
        currentWater += 1
    }

    func reset() {
        resetCallCount += 1
        currentWater = 0
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
