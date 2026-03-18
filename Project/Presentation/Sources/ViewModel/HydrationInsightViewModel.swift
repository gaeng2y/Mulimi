//
//  HydrationInsightViewModel.swift
//  PresentationLayer
//
//  Created by Codex on 3/14/26.
//

import DomainLayerInterface
import Foundation
import Localization
import Observation

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
    public private(set) var dailyGoalML: Double = 0
    public private(set) var weeklyAverageML: Double = 0
    public private(set) var monthlyAverageML: Double = 0
    public private(set) var weeklyElapsedDays: Int = 0
    public private(set) var monthlyElapsedDays: Int = 0
    private(set) var bestWeekday: HydrationInsightWeekdayDistribution?
    private(set) var leastWeekday: HydrationInsightWeekdayDistribution?
    private(set) var weekdayDistributions: [HydrationInsightWeekdayDistribution] = []

    private let waterUseCase: DrinkWaterUseCase
    private let progressUseCase: HydrationProgressUseCase
    private let calendar: Calendar
    private let currentDateProvider: @Sendable () -> Date

    public init(
        waterUseCase: DrinkWaterUseCase,
        progressUseCase: HydrationProgressUseCase,
        calendar: Calendar = .autoupdatingCurrent,
        currentDateProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.waterUseCase = waterUseCase
        self.progressUseCase = progressUseCase
        self.calendar = calendar
        self.currentDateProvider = currentDateProvider
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
            )
        ]
    }

    var dailyGoalText: String {
        volumeText(dailyGoalML)
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
        guard let monthInterval = calendar.dateInterval(of: .month, for: referenceDate) else {
            resetInsightState()
            return
        }

        let elapsedMonthInterval = elapsedInterval(from: monthInterval, upTo: referenceDate)

        async let progressSnapshot = progressUseCase.progressSnapshot(
            referenceDate: referenceDate,
            calendar: calendar
        )
        async let monthlyEvents = waterUseCase.hydrationEvents(in: elapsedMonthInterval)

        let (snapshot, resolvedMonthlyEvents) = await (progressSnapshot, monthlyEvents)
        dailyGoalML = snapshot.dailyGoalML
        weeklyAverageML = snapshot.weeklyAverageML
        monthlyAverageML = snapshot.monthlyAverageML
        weeklyElapsedDays = snapshot.weeklyElapsedDays
        monthlyElapsedDays = snapshot.monthlyElapsedDays
        isEmpty = snapshot.isEmpty

        if resolvedMonthlyEvents.isEmpty {
            weekdayDistributions = []
            bestWeekday = nil
            leastWeekday = nil
        } else {
            let monthlyTotals = dailyTotals(from: resolvedMonthlyEvents)
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
    }

    private func resetInsightState() {
        isEmpty = true
        dailyGoalML = 0
        weeklyAverageML = 0
        monthlyAverageML = 0
        weeklyElapsedDays = 0
        monthlyElapsedDays = 0
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

    private func dailyTotals(from events: [HydrationEvent]) -> [Date: Double] {
        events.reduce(into: [:]) { partialResult, event in
            let day = calendar.startOfDay(for: event.consumedAt)
            partialResult[day, default: 0] += Double(event.volumeML)
        }
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

    private func volumeText(_ volumeML: Double) -> String {
        L10n.tr("commonMilliliterFormat", Int(volumeML.rounded()))
    }
}
