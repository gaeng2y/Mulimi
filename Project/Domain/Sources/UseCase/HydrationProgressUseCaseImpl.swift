import DomainLayerInterface
import Foundation

public struct HydrationProgressUseCaseImpl: HydrationProgressUseCase {
    private let drinkWaterRepository: DrinkWaterRepository
    private let userPreferencesRepository: UserPreferencesRepository

    public init(
        drinkWaterRepository: DrinkWaterRepository,
        userPreferencesRepository: UserPreferencesRepository
    ) {
        self.drinkWaterRepository = drinkWaterRepository
        self.userPreferencesRepository = userPreferencesRepository
    }

    public func progressSnapshot(referenceDate: Date, calendar: Calendar) async -> HydrationProgressSnapshot {
        let dailyGoalML = userPreferencesRepository.getDailyWaterLimit()

        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: referenceDate),
              let monthInterval = calendar.dateInterval(of: .month, for: referenceDate) else {
            return .empty(dailyGoalML: dailyGoalML)
        }

        let elapsedWeekInterval = elapsedInterval(from: weekInterval, upTo: referenceDate, calendar: calendar)
        let elapsedMonthInterval = elapsedInterval(from: monthInterval, upTo: referenceDate, calendar: calendar)

        async let weeklyEvents = drinkWaterRepository.hydrationEvents(in: elapsedWeekInterval)
        async let monthlyEvents = drinkWaterRepository.hydrationEvents(in: elapsedMonthInterval)

        let (resolvedWeeklyEvents, resolvedMonthlyEvents) = await (weeklyEvents, monthlyEvents)
        let weeklyTotals = dailyTotals(from: resolvedWeeklyEvents, calendar: calendar)
        let monthlyTotals = dailyTotals(from: resolvedMonthlyEvents, calendar: calendar)

        let weeklyElapsedDays = elapsedDayCount(in: elapsedWeekInterval, calendar: calendar)
        let monthlyElapsedDays = elapsedDayCount(in: elapsedMonthInterval, calendar: calendar)
        let weeklyAchievedDays = achievedDayCount(in: weeklyTotals, dailyGoalML: dailyGoalML)
        let monthlyAchievedDays = achievedDayCount(in: monthlyTotals, dailyGoalML: dailyGoalML)

        return HydrationProgressSnapshot(
            dailyGoalML: dailyGoalML,
            weeklyAverageML: averageIntake(from: weeklyTotals, dayCount: weeklyElapsedDays),
            monthlyAverageML: averageIntake(from: monthlyTotals, dayCount: monthlyElapsedDays),
            weeklyAchievementRate: achievementRate(achievedDays: weeklyAchievedDays, dayCount: weeklyElapsedDays),
            monthlyAchievementRate: achievementRate(achievedDays: monthlyAchievedDays, dayCount: monthlyElapsedDays),
            weeklyAchievedDays: weeklyAchievedDays,
            monthlyAchievedDays: monthlyAchievedDays,
            weeklyElapsedDays: weeklyElapsedDays,
            monthlyElapsedDays: monthlyElapsedDays,
            currentStreak: await calculateCurrentStreak(
                referenceDate: referenceDate,
                calendar: calendar,
                dailyGoalML: dailyGoalML
            ),
            isEmpty: resolvedWeeklyEvents.isEmpty && resolvedMonthlyEvents.isEmpty
        )
    }

    private func elapsedInterval(from interval: DateInterval, upTo referenceDate: Date, calendar: Calendar) -> DateInterval {
        let intervalEnd = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: referenceDate)
        ) ?? interval.end

        return DateInterval(start: interval.start, end: min(interval.end, intervalEnd))
    }

    private func elapsedDayCount(in interval: DateInterval, calendar: Calendar) -> Int {
        max(calendar.dateComponents([.day], from: interval.start, to: interval.end).day ?? 0, 1)
    }

    private func dailyTotals(from events: [HydrationEvent], calendar: Calendar) -> [Date: Double] {
        events.reduce(into: [:]) { partialResult, event in
            let day = calendar.startOfDay(for: event.consumedAt)
            partialResult[day, default: 0] += Double(event.volumeML)
        }
    }

    private func achievedDayCount(in totals: [Date: Double], dailyGoalML: Double) -> Int {
        guard dailyGoalML > 0 else {
            return 0
        }

        return totals.values.filter { $0 >= dailyGoalML }.count
    }

    private func averageIntake(from totals: [Date: Double], dayCount: Int) -> Double {
        guard dayCount > 0 else {
            return 0
        }

        return totals.values.reduce(0, +) / Double(dayCount)
    }

    private func achievementRate(achievedDays: Int, dayCount: Int) -> Double {
        guard dayCount > 0 else {
            return 0
        }

        return Double(achievedDays) / Double(dayCount)
    }

    private func calculateCurrentStreak(referenceDate: Date, calendar: Calendar, dailyGoalML: Double) async -> Int {
        guard dailyGoalML > 0 else {
            return 0
        }

        var date = calendar.startOfDay(for: referenceDate)
        if await totalIntake(on: date, calendar: calendar) < dailyGoalML {
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: date) else {
                return 0
            }
            date = previousDate
        }

        var streak = 0

        while await totalIntake(on: date, calendar: calendar) >= dailyGoalML {
            streak += 1

            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: date) else {
                break
            }
            date = previousDate
        }

        return streak
    }

    private func totalIntake(on date: Date, calendar: Calendar) async -> Double {
        (await drinkWaterRepository.hydrationEvents(on: date)).reduce(0) { partialResult, event in
            partialResult + Double(event.volumeML)
        }
    }
}
