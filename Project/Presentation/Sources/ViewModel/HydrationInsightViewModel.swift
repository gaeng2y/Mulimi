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

struct RoutineAdherenceInsightMetric: Identifiable, Equatable {
    let id: String
    let title: String
    let value: String
    let detail: String
}

struct RoutineAdherenceDisplayRow: Identifiable, Equatable {
    let id: String
    let title: String
    let timeText: String
    let rateText: String
    let detailText: String
    let statusText: String
    let progress: Double
    let status: HydrationRoutineAdherenceStatus
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
    private(set) var routineAdherenceInsight: HydrationRoutineAdherenceInsight?

    private let waterUseCase: DrinkWaterUseCase
    private let progressUseCase: HydrationProgressUseCase
    private let routineAdherenceUseCase: HydrationRoutineAdherenceUseCase
    private let calendar: Calendar
    private let currentDateProvider: @Sendable () -> Date

    public init(
        waterUseCase: DrinkWaterUseCase,
        progressUseCase: HydrationProgressUseCase,
        routineAdherenceUseCase: HydrationRoutineAdherenceUseCase,
        calendar: Calendar = .autoupdatingCurrent,
        currentDateProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.waterUseCase = waterUseCase
        self.progressUseCase = progressUseCase
        self.routineAdherenceUseCase = routineAdherenceUseCase
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

    var routineAdherenceInsightText: String {
        guard let insight = routineAdherenceInsight else {
            return L10n.tr("insightRoutineAdherenceInsufficientDescription")
        }

        if insight.routineSummaries.isEmpty {
            return L10n.tr("insightRoutineAdherenceNoRoutineDescription")
        }

        if insight.activeRoutineCount == 0 {
            return L10n.tr(
                "insightRoutineAdherenceInactiveOnlyDescriptionFormat",
                insight.inactiveRoutineCount
            )
        }

        if !insight.hasDueOccurrences {
            return L10n.tr("insightRoutineAdherenceNoDueDescription")
        }

        if insight.missedCount == 0 {
            return L10n.tr("insightRoutineAdherenceAllKeptDescription")
        }

        guard let mostMissedTimeSlot = insight.mostMissedTimeSlot else {
            return L10n.tr("insightRoutineAdherenceInsufficientDescription")
        }

        return L10n.tr(
            "insightRoutineAdherenceMissPatternDescriptionFormat",
            timeText(hour: mostMissedTimeSlot.hour, minute: mostMissedTimeSlot.minute),
            mostMissedTimeSlot.missedCount
        )
    }

    var routineAdherenceMetrics: [RoutineAdherenceInsightMetric] {
        guard let insight = routineAdherenceInsight else {
            return []
        }

        return [
            RoutineAdherenceInsightMetric(
                id: "rate",
                title: L10n.tr("insightRoutineAdherenceRateTitle"),
                value: percentText(insight.adherenceRate),
                detail: L10n.tr(
                    "insightRoutineAdherenceCompletedDetailFormat",
                    insight.completedCount,
                    insight.scheduledCount
                )
            ),
            RoutineAdherenceInsightMetric(
                id: "missed",
                title: L10n.tr("insightRoutineAdherenceMissedTitle"),
                value: L10n.tr("insightRoutineAdherenceCountFormat", insight.missedCount),
                detail: L10n.tr(
                    "insightRoutineAdherenceActiveRoutineDetailFormat",
                    insight.activeRoutineCount
                )
            ),
            RoutineAdherenceInsightMetric(
                id: "window",
                title: L10n.tr("insightRoutineAdherenceMatchWindowTitle"),
                value: L10n.tr("insightRoutineAdherenceMinuteFormat", insight.matchingWindowMinutes),
                detail: L10n.tr("insightRoutineAdherenceMatchWindowDetail")
            )
        ]
    }

    var routineAdherenceRows: [RoutineAdherenceDisplayRow] {
        guard let insight = routineAdherenceInsight else {
            return []
        }

        return insight.routineSummaries.map { summary in
            RoutineAdherenceDisplayRow(
                id: summary.id,
                title: summary.title,
                timeText: timeText(hour: summary.hour, minute: summary.minute),
                rateText: percentText(summary.adherenceRate),
                detailText: L10n.tr(
                    "insightRoutineAdherenceRoutineDetailFormat",
                    summary.completedCount,
                    summary.scheduledCount,
                    summary.missedCount
                ),
                statusText: statusText(for: summary.status),
                progress: min(max(summary.adherenceRate, 0), 1),
                status: summary.status
            )
        }
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
        async let routineAdherence = routineAdherenceUseCase.weeklyInsight(
            referenceDate: referenceDate,
            calendar: calendar
        )

        let (snapshot, resolvedMonthlyEvents, resolvedRoutineAdherence) = await (
            progressSnapshot,
            monthlyEvents,
            routineAdherence
        )
        dailyGoalML = snapshot.dailyGoalML
        weeklyAverageML = snapshot.weeklyAverageML
        monthlyAverageML = snapshot.monthlyAverageML
        weeklyElapsedDays = snapshot.weeklyElapsedDays
        monthlyElapsedDays = snapshot.monthlyElapsedDays
        isEmpty = snapshot.isEmpty && resolvedRoutineAdherence.routineSummaries.isEmpty
        routineAdherenceInsight = resolvedRoutineAdherence

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
        routineAdherenceInsight = nil
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

    private func percentText(_ rate: Double) -> String {
        L10n.tr("commonPercentFormat", Int((rate * 100).rounded()))
    }

    private func timeText(hour: Int, minute: Int) -> String {
        var formatterCalendar = calendar
        formatterCalendar.locale = calendar.locale ?? Locale.autoupdatingCurrent

        let date = formatterCalendar.date(from: DateComponents(hour: hour, minute: minute)) ?? .now
        return DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
    }

    private func statusText(for status: HydrationRoutineAdherenceStatus) -> String {
        switch status {
        case .inactive:
            return L10n.tr("insightRoutineAdherenceStatusInactive")
        case .noDueOccurrences:
            return L10n.tr("insightRoutineAdherenceStatusNoDue")
        case .noRecords:
            return L10n.tr("insightRoutineAdherenceStatusNoRecords")
        case .needsAttention:
            return L10n.tr("insightRoutineAdherenceStatusNeedsAttention")
        case .onTrack:
            return L10n.tr("insightRoutineAdherenceStatusOnTrack")
        }
    }
}
