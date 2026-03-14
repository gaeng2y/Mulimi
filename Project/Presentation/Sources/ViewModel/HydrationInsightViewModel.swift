//
//  HydrationInsightViewModel.swift
//  PresentationLayer
//
//  Created by Codex on 3/14/26.
//

import DomainLayerInterface
import Foundation
import Localization

struct HydrationInsightMetric: Identifiable, Equatable {
    let id: String
    let title: String
    let value: String
    let detail: String
}

struct HydrationInsightWeekdayDistribution: Identifiable, Equatable {
    let weekday: Int
    let label: String
    let averageIntakeML: Double
    let totalIntakeML: Double
    let occurrenceCount: Int

    var id: Int { weekday }
}

@MainActor
@Observable
public final class HydrationInsightViewModel {
    public private(set) var isLoading: Bool = false
    public private(set) var isEmpty: Bool = false
    public private(set) var dailyGoalML: Double
    public private(set) var weeklyAverageML: Double = 0
    public private(set) var monthlyAverageML: Double = 0
    public private(set) var weeklyAchievementRate: Double = 0
    public private(set) var monthlyAchievementRate: Double = 0
    public private(set) var weeklyAchievedDays: Int = 0
    public private(set) var monthlyAchievedDays: Int = 0
    public private(set) var weeklyElapsedDays: Int = 0
    public private(set) var monthlyElapsedDays: Int = 0
    public private(set) var currentStreak: Int = 0
    private(set) var bestWeekday: HydrationInsightWeekdayDistribution?
    private(set) var leastWeekday: HydrationInsightWeekdayDistribution?
    private(set) var weekdayDistributions: [HydrationInsightWeekdayDistribution] = []

    private let waterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let calendar: Calendar
    private let currentDateProvider: @Sendable () -> Date

    public init(
        waterUseCase: DrinkWaterUseCase,
        userPreferencesUseCase: UserPreferencesUseCase,
        calendar: Calendar = .autoupdatingCurrent,
        currentDateProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.waterUseCase = waterUseCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.calendar = calendar
        self.currentDateProvider = currentDateProvider
        self.dailyGoalML = userPreferencesUseCase.getDailyWaterLimit()
    }

    var metrics: [HydrationInsightMetric] {
        [
            HydrationInsightMetric(
                id: "weeklyAverage",
                title: L10n.tr("insightMetricWeeklyAverageTitle"),
                value: volumeText(weeklyAverageML),
                detail: L10n.tr("insightElapsedDaysFormat", weeklyElapsedDays)
            ),
            HydrationInsightMetric(
                id: "monthlyAverage",
                title: L10n.tr("insightMetricMonthlyAverageTitle"),
                value: volumeText(monthlyAverageML),
                detail: L10n.tr("insightElapsedDaysFormat", monthlyElapsedDays)
            ),
            HydrationInsightMetric(
                id: "weeklyAchievement",
                title: L10n.tr("insightMetricWeeklyAchievementTitle"),
                value: percentText(weeklyAchievementRate),
                detail: L10n.tr(
                    "insightAchievementDaysFormat",
                    weeklyAchievedDays,
                    max(weeklyElapsedDays, 1)
                )
            ),
            HydrationInsightMetric(
                id: "monthlyAchievement",
                title: L10n.tr("insightMetricMonthlyAchievementTitle"),
                value: percentText(monthlyAchievementRate),
                detail: L10n.tr(
                    "insightAchievementDaysFormat",
                    monthlyAchievedDays,
                    max(monthlyElapsedDays, 1)
                )
            )
        ]
    }

    var streakText: String {
        L10n.tr("insightStreakValueFormat", currentStreak)
    }

    var dailyGoalText: String {
        volumeText(dailyGoalML)
    }

    var weeklyAchievementText: String {
        percentText(weeklyAchievementRate)
    }

    var monthlyAchievementText: String {
        percentText(monthlyAchievementRate)
    }

    var weekdayInsightText: String {
        guard let bestWeekday, let leastWeekday else {
            return L10n.tr("insightWeekdayInsightInsufficient")
        }

        return L10n.tr(
            "insightWeekdayInsightFormat",
            bestWeekday.label,
            volumeText(bestWeekday.averageIntakeML),
            leastWeekday.label,
            volumeText(leastWeekday.averageIntakeML)
        )
    }

    var chartUpperBound: Double {
        let highestAverage = weekdayDistributions.map(\.averageIntakeML).max() ?? 0
        return max(dailyGoalML, highestAverage) * 1.2
    }

    public func loadInsights() async {
        isLoading = true
        defer { isLoading = false }

        let referenceDate = currentDateProvider()
        dailyGoalML = userPreferencesUseCase.getDailyWaterLimit()

        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: referenceDate),
              let monthInterval = calendar.dateInterval(of: .month, for: referenceDate) else {
            resetInsightState()
            return
        }

        let elapsedWeekInterval = elapsedInterval(from: weekInterval, upTo: referenceDate)
        let elapsedMonthInterval = elapsedInterval(from: monthInterval, upTo: referenceDate)

        async let weeklyEvents = waterUseCase.hydrationEvents(in: elapsedWeekInterval)
        async let monthlyEvents = waterUseCase.hydrationEvents(in: elapsedMonthInterval)

        let (resolvedWeeklyEvents, resolvedMonthlyEvents) = await (weeklyEvents, monthlyEvents)
        let weeklyTotals = dailyTotals(from: resolvedWeeklyEvents)
        let monthlyTotals = dailyTotals(from: resolvedMonthlyEvents)

        weeklyElapsedDays = elapsedDayCount(in: elapsedWeekInterval)
        monthlyElapsedDays = elapsedDayCount(in: elapsedMonthInterval)
        weeklyAchievedDays = achievedDayCount(in: weeklyTotals)
        monthlyAchievedDays = achievedDayCount(in: monthlyTotals)
        weeklyAverageML = averageIntake(from: weeklyTotals, dayCount: weeklyElapsedDays)
        monthlyAverageML = averageIntake(from: monthlyTotals, dayCount: monthlyElapsedDays)
        weeklyAchievementRate = achievementRate(achievedDays: weeklyAchievedDays, dayCount: weeklyElapsedDays)
        monthlyAchievementRate = achievementRate(achievedDays: monthlyAchievedDays, dayCount: monthlyElapsedDays)
        if resolvedMonthlyEvents.isEmpty {
            weekdayDistributions = []
            bestWeekday = nil
            leastWeekday = nil
        } else {
            weekdayDistributions = makeWeekdayDistributions(
                from: monthlyTotals,
                in: elapsedMonthInterval
            )
            bestWeekday = weekdayDistributions.max { lhs, rhs in
                lhs.averageIntakeML < rhs.averageIntakeML
            }
            leastWeekday = weekdayDistributions.min { lhs, rhs in
                lhs.averageIntakeML < rhs.averageIntakeML
            }
        }
        currentStreak = await calculateCurrentStreak(referenceDate: referenceDate)
        isEmpty = resolvedWeeklyEvents.isEmpty && resolvedMonthlyEvents.isEmpty
    }

    private func resetInsightState() {
        isEmpty = true
        weeklyAverageML = 0
        monthlyAverageML = 0
        weeklyAchievementRate = 0
        monthlyAchievementRate = 0
        weeklyAchievedDays = 0
        monthlyAchievedDays = 0
        weeklyElapsedDays = 0
        monthlyElapsedDays = 0
        currentStreak = 0
        bestWeekday = nil
        leastWeekday = nil
        weekdayDistributions = []
    }

    private func elapsedInterval(from interval: DateInterval, upTo referenceDate: Date) -> DateInterval {
        let intervalEnd = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: referenceDate)
        ) ?? interval.end

        return DateInterval(
            start: interval.start,
            end: min(interval.end, intervalEnd)
        )
    }

    private func elapsedDayCount(in interval: DateInterval) -> Int {
        max(
            calendar.dateComponents([.day], from: interval.start, to: interval.end).day ?? 0,
            1
        )
    }

    private func dailyTotals(from events: [HydrationEvent]) -> [Date: Double] {
        events.reduce(into: [:]) { partialResult, event in
            let day = calendar.startOfDay(for: event.consumedAt)
            partialResult[day, default: 0] += Double(event.volumeML)
        }
    }

    private func achievedDayCount(in totals: [Date: Double]) -> Int {
        guard dailyGoalML > 0 else {
            return 0
        }

        return totals.values.filter { $0 >= dailyGoalML }.count
    }

    private func averageIntake(from totals: [Date: Double], dayCount: Int) -> Double {
        guard dayCount > 0 else {
            return 0
        }

        let totalIntake = totals.values.reduce(0, +)
        return totalIntake / Double(dayCount)
    }

    private func achievementRate(achievedDays: Int, dayCount: Int) -> Double {
        guard dayCount > 0 else {
            return 0
        }

        return Double(achievedDays) / Double(dayCount)
    }

    private func makeWeekdayDistributions(
        from monthlyTotals: [Date: Double],
        in interval: DateInterval
    ) -> [HydrationInsightWeekdayDistribution] {
        var totalByWeekday: [Int: Double] = [:]
        var occurrencesByWeekday: [Int: Int] = [:]
        var currentDate = interval.start

        while currentDate < interval.end {
            let weekday = calendar.component(.weekday, from: currentDate)
            occurrencesByWeekday[weekday, default: 0] += 1
            totalByWeekday[weekday, default: 0] += monthlyTotals[currentDate, default: 0]

            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        let weekdaySymbols = makeWeekdaySymbols()
        let orderedWeekdays = (0..<7).map { offset in
            ((calendar.firstWeekday - 1 + offset) % 7) + 1
        }

        return orderedWeekdays.compactMap { weekday in
            guard let occurrenceCount = occurrencesByWeekday[weekday], occurrenceCount > 0 else {
                return nil
            }

            let totalIntake = totalByWeekday[weekday, default: 0]

            return HydrationInsightWeekdayDistribution(
                weekday: weekday,
                label: weekdaySymbols[weekday - 1],
                averageIntakeML: totalIntake / Double(occurrenceCount),
                totalIntakeML: totalIntake,
                occurrenceCount: occurrenceCount
            )
        }
    }

    private func makeWeekdaySymbols() -> [String] {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = calendar.locale ?? Locale.autoupdatingCurrent
        return formatter.shortWeekdaySymbols
    }

    private func calculateCurrentStreak(referenceDate: Date) async -> Int {
        guard dailyGoalML > 0 else {
            return 0
        }

        var date = calendar.startOfDay(for: referenceDate)
        if await totalIntake(on: date) < dailyGoalML {
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: date) else {
                return 0
            }
            date = previousDate
        }

        var streak = 0

        while await totalIntake(on: date) >= dailyGoalML {
            streak += 1

            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: date) else {
                break
            }
            date = previousDate
        }

        return streak
    }

    private func totalIntake(on date: Date) async -> Double {
        (await waterUseCase.hydrationEvents(on: date)).reduce(0) { partialResult, event in
            partialResult + Double(event.volumeML)
        }
    }

    private func volumeText(_ volumeML: Double) -> String {
        L10n.tr("commonMilliliterFormat", Int(volumeML.rounded()))
    }

    private func percentText(_ ratio: Double) -> String {
        L10n.tr("commonPercentFormat", Int((ratio * 100).rounded()))
    }
}
