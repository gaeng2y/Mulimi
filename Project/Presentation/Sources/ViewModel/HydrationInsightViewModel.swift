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

enum RoutineRecoveryReminderAction: Equatable {
    case manageRoutine(RoutineActionIntent)
    case requestNotificationAuthorization(RoutineActionIntent)
    case openSettings
}

struct RoutineRecoveryCardModel: Equatable {
    let badgeText: String
    let title: String
    let description: String
    let recordActionTitle: String
    let reminderActionTitle: String
    let reminderAction: RoutineRecoveryReminderAction
    let canRecordNow: Bool
}

enum HydrationWeeklyReportTimeSlot: CaseIterable, Equatable {
    case morning
    case afternoon
    case evening
}

struct HydrationWeeklyReport: Equatable {
    let averageML: Double
    let achievedDays: Int
    let elapsedDays: Int
    let previousAverageML: Double?
    let averageDeltaML: Double?
    let previousAchievedDays: Int?
    let achievedDayDelta: Int?
    let frequentlyEmptySlot: HydrationWeeklyReportTimeSlot?
    let frequentlyEmptySlotMissingDays: Int
    let hasCurrentWeekRecords: Bool
}

struct HydrationWeeklyReportMetric: Identifiable, Equatable {
    let id: String
    let title: String
    let value: String
    let detail: String
}

enum HydrationWeeklyCoachingAction: Equatable {
    case routine(RoutineRecoveryReminderAction)
    case dailyGoal
    case none
}

struct HydrationWeeklyCoachingCardModel: Identifiable, Equatable {
    let id: String
    let badgeText: String
    let title: String
    let description: String
    let actionTitle: String?
    let action: HydrationWeeklyCoachingAction
}

@MainActor
@Observable
public final class HydrationInsightViewModel {
    public private(set) var isLoading: Bool = false
    public private(set) var isEmpty: Bool = false
    public private(set) var dailyGoalML: Double = 0
    public private(set) var todayIntakeML: Double = 0
    public private(set) var weeklyAverageML: Double = 0
    public private(set) var monthlyAverageML: Double = 0
    public private(set) var weeklyElapsedDays: Int = 0
    public private(set) var monthlyElapsedDays: Int = 0
    private(set) var bestWeekday: HydrationInsightWeekdayDistribution?
    private(set) var leastWeekday: HydrationInsightWeekdayDistribution?
    private(set) var weekdayDistributions: [HydrationInsightWeekdayDistribution] = []
    private(set) var routineAdherenceInsight: HydrationRoutineAdherenceInsight?
    private(set) var weeklyReport: HydrationWeeklyReport?
    private(set) var notificationStatus: RoutineNotificationAuthorizationStatus = .notDetermined

    private let waterUseCase: DrinkWaterUseCase
    private let progressUseCase: HydrationProgressUseCase
    private let routineAdherenceUseCase: HydrationRoutineAdherenceUseCase
    private let routineUseCase: RoutineUseCase
    private let analyticsUseCase: AnalyticsUseCase
    private let calendar: Calendar
    private let currentDateProvider: @Sendable () -> Date

    public init(
        waterUseCase: DrinkWaterUseCase,
        progressUseCase: HydrationProgressUseCase,
        routineAdherenceUseCase: HydrationRoutineAdherenceUseCase,
        routineUseCase: RoutineUseCase,
        analyticsUseCase: AnalyticsUseCase = NoOpAnalyticsUseCase(),
        calendar: Calendar = .autoupdatingCurrent,
        currentDateProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.waterUseCase = waterUseCase
        self.progressUseCase = progressUseCase
        self.routineAdherenceUseCase = routineAdherenceUseCase
        self.routineUseCase = routineUseCase
        self.analyticsUseCase = analyticsUseCase
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

    var weeklyReportInsightText: String {
        guard let weeklyReport else {
            return L10n.tr("insightWeeklyReportNoComparisonDescription")
        }

        guard weeklyReport.hasCurrentWeekRecords else {
            return L10n.tr("insightWeeklyReportEmptyDescriptionFormat", dailyGoalText)
        }

        guard let averageDeltaML = weeklyReport.averageDeltaML else {
            return L10n.tr("insightWeeklyReportNoComparisonDescription")
        }

        let roundedDelta = Int(abs(averageDeltaML).rounded())
        if roundedDelta == 0 {
            return L10n.tr("insightWeeklyReportStableDescription")
        }

        let deltaText = volumeText(Double(roundedDelta))
        if averageDeltaML > 0 {
            return L10n.tr("insightWeeklyReportIncreasedDescriptionFormat", deltaText)
        }

        return L10n.tr("insightWeeklyReportDecreasedDescriptionFormat", deltaText)
    }

    var weeklyReportMetrics: [HydrationWeeklyReportMetric] {
        guard let weeklyReport else {
            return []
        }

        return [
            HydrationWeeklyReportMetric(
                id: "average",
                title: L10n.tr("insightWeeklyReportAverageTitle"),
                value: volumeText(weeklyReport.averageML),
                detail: weeklyAverageDetailText(for: weeklyReport)
            ),
            HydrationWeeklyReportMetric(
                id: "achieved",
                title: L10n.tr("insightWeeklyReportAchievedTitle"),
                value: L10n.tr(
                    "insightAchievementDaysFormat",
                    weeklyReport.achievedDays,
                    weeklyReport.elapsedDays
                ),
                detail: weeklyAchievedDetailText(for: weeklyReport)
            ),
            HydrationWeeklyReportMetric(
                id: "emptySlot",
                title: L10n.tr("insightWeeklyReportGapTitle"),
                value: weeklyEmptySlotValueText(for: weeklyReport),
                detail: weeklyEmptySlotDetailText(for: weeklyReport)
            )
        ]
    }

    var routineRecoveryCard: RoutineRecoveryCardModel? {
        if let missedRoutine = weakestMissedRoutine {
            return RoutineRecoveryCardModel(
                badgeText: L10n.tr("insightRoutineRecoveryMissedRoutineBadge"),
                title: L10n.tr("insightRoutineRecoveryMissedRoutineTitleFormat", missedRoutine.timeText),
                description: L10n.tr(
                    "insightRoutineRecoveryMissedRoutineDescriptionFormat",
                    missedRoutine.title,
                    missedRoutine.missedCount
                ),
                recordActionTitle: L10n.tr("insightRoutineRecoveryRecordNowTitle"),
                reminderActionTitle: reminderActionTitle(
                    authorizedTitle: L10n.tr("insightRoutineRecoveryEditRoutineTitle")
                ),
                reminderAction: reminderAction(for: .edit(missedRoutine.uuid)),
                canRecordNow: canRecordRecoveryDrink
            )
        }

        guard let weeklyReport,
              weeklyReport.hasCurrentWeekRecords,
              let emptySlot = weeklyReport.frequentlyEmptySlot else {
            return nil
        }

        return RoutineRecoveryCardModel(
            badgeText: L10n.tr("insightRoutineRecoveryEmptySlotBadge"),
            title: L10n.tr("insightRoutineRecoveryEmptySlotTitleFormat", slotText(for: emptySlot)),
            description: L10n.tr(
                "insightRoutineRecoveryEmptySlotDescriptionFormat",
                weeklyReport.frequentlyEmptySlotMissingDays
            ),
            recordActionTitle: L10n.tr("insightRoutineRecoveryRecordNowTitle"),
            reminderActionTitle: reminderActionTitle(
                authorizedTitle: L10n.tr("insightRoutineRecoveryCreateRoutineTitle")
            ),
            reminderAction: reminderAction(for: .create),
            canRecordNow: canRecordRecoveryDrink
        )
    }

    var weeklyCoachingCards: [HydrationWeeklyCoachingCardModel] {
        guard let weeklyReport else {
            return []
        }

        var cards: [HydrationWeeklyCoachingCardModel] = []

        if let missedRoutine = weakestMissedRoutine {
            cards.append(missedRoutineCoachingCard(missedRoutine))
        } else if weeklyReport.hasCurrentWeekRecords,
                  let emptySlot = weeklyReport.frequentlyEmptySlot {
            cards.append(emptySlotCoachingCard(slot: emptySlot, report: weeklyReport))
        }

        if let goalCard = goalCoachingCard(for: weeklyReport) {
            cards.append(goalCard)
        }

        if cards.isEmpty {
            cards.append(neutralCoachingCard(for: weeklyReport))
        }

        return cards
    }

    var chartUpperBound: Double {
        let highestAverage = weekdayDistributions.map(\.averageIntakeML).max() ?? 0
        return max(dailyGoalML, highestAverage) * 1.2
    }

    public func loadInsights() async {
        isLoading = true
        defer { isLoading = false }

        let referenceDate = currentDateProvider()
        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: referenceDate),
              let monthInterval = calendar.dateInterval(of: .month, for: referenceDate) else {
            resetInsightState()
            return
        }

        let elapsedWeekInterval = elapsedInterval(from: weekInterval, upTo: referenceDate)
        let previousWeekInterval = previousComparisonInterval(matching: elapsedWeekInterval)
        let elapsedMonthInterval = elapsedInterval(from: monthInterval, upTo: referenceDate)

        async let progressSnapshot = progressUseCase.progressSnapshot(
            referenceDate: referenceDate,
            calendar: calendar
        )
        async let currentWeekEvents = waterUseCase.hydrationEvents(in: elapsedWeekInterval)
        async let previousWeekEvents = waterUseCase.hydrationEvents(in: previousWeekInterval)
        async let monthlyEvents = waterUseCase.hydrationEvents(in: elapsedMonthInterval)
        async let routineAdherence = routineAdherenceUseCase.weeklyInsight(
            referenceDate: referenceDate,
            calendar: calendar
        )
        async let currentNotificationStatus = routineUseCase.notificationAuthorizationStatus()

        let (
            snapshot,
            resolvedCurrentWeekEvents,
            resolvedPreviousWeekEvents,
            resolvedMonthlyEvents,
            resolvedRoutineAdherence,
            resolvedNotificationStatus
        ) = await (
            progressSnapshot,
            currentWeekEvents,
            previousWeekEvents,
            monthlyEvents,
            routineAdherence,
            currentNotificationStatus
        )
        dailyGoalML = snapshot.dailyGoalML
        todayIntakeML = snapshot.todayIntakeML
        weeklyAverageML = snapshot.weeklyAverageML
        monthlyAverageML = snapshot.monthlyAverageML
        weeklyElapsedDays = snapshot.weeklyElapsedDays
        monthlyElapsedDays = snapshot.monthlyElapsedDays
        isEmpty = snapshot.isEmpty && resolvedRoutineAdherence.routineSummaries.isEmpty
        routineAdherenceInsight = resolvedRoutineAdherence
        notificationStatus = resolvedNotificationStatus
        weeklyReport = makeWeeklyReport(
            snapshot: snapshot,
            currentWeekEvents: resolvedCurrentWeekEvents,
            previousWeekEvents: resolvedPreviousWeekEvents,
            elapsedWeekInterval: elapsedWeekInterval
        )

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
        todayIntakeML = 0
        weeklyAverageML = 0
        monthlyAverageML = 0
        weeklyElapsedDays = 0
        monthlyElapsedDays = 0
        bestWeekday = nil
        leastWeekday = nil
        weekdayDistributions = []
        routineAdherenceInsight = nil
        weeklyReport = nil
    }

    @discardableResult
    func recordRecoveryDrink() async -> Bool {
        guard canRecordRecoveryDrink else {
            return false
        }

        await waterUseCase.drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
        analyticsUseCase.track(
            .insightCTATapped(
                source: "insight_recovery",
                context: "routine_recovery",
                action: "record_now"
            )
        )
        analyticsUseCase.track(
            .waterLogged(
                source: "insight_recovery",
                servingType: "default_glass",
                volumeML: HydrationServing.defaultGlassVolumeML,
                dailyGoalML: Int(dailyGoalML.rounded())
            )
        )
        await loadInsights()
        return true
    }

    func requestRecoveryNotificationAuthorization(
        then actionIntent: RoutineActionIntent
    ) async -> RoutineActionIntent? {
        do {
            notificationStatus = try await routineUseCase.requestNotificationAuthorization()
            return notificationStatus == .authorized ? actionIntent : nil
        } catch {
            notificationStatus = await routineUseCase.notificationAuthorizationStatus()
            return nil
        }
    }

    func trackRecoveryReminderAction(_ action: RoutineRecoveryReminderAction) {
        analyticsUseCase.track(
            .insightCTATapped(
                source: "insight_recovery",
                context: "routine_recovery",
                action: analyticsAction(for: action)
            )
        )
    }

    func trackWeeklyCoachingAction(_ action: HydrationWeeklyCoachingAction) {
        analyticsUseCase.track(
            .insightCTATapped(
                source: "insight_weekly_coaching",
                context: "weekly_coaching",
                action: analyticsAction(for: action)
            )
        )
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

    private func previousComparisonInterval(matching elapsedWeekInterval: DateInterval) -> DateInterval {
        let dayCount = elapsedDayCount(in: elapsedWeekInterval)
        let start = calendar.date(
            byAdding: .day,
            value: -7,
            to: elapsedWeekInterval.start
        ) ?? elapsedWeekInterval.start
        let end = calendar.date(
            byAdding: .day,
            value: dayCount,
            to: start
        ) ?? start

        return DateInterval(start: start, end: end)
    }

    private func dailyTotals(from events: [HydrationEvent]) -> [Date: Double] {
        events.reduce(into: [:]) { partialResult, event in
            let day = calendar.startOfDay(for: event.consumedAt)
            partialResult[day, default: 0] += Double(event.volumeML)
        }
    }

    private func elapsedDayCount(in interval: DateInterval) -> Int {
        max(calendar.dateComponents([.day], from: interval.start, to: interval.end).day ?? 0, 1)
    }

    private func achievedDayCount(in totals: [Date: Double]) -> Int {
        guard dailyGoalML > 0 else {
            return 0
        }

        return totals.values.filter { $0 >= dailyGoalML }.count
    }

    private func makeWeeklyReport(
        snapshot: HydrationProgressSnapshot,
        currentWeekEvents: [HydrationEvent],
        previousWeekEvents: [HydrationEvent],
        elapsedWeekInterval: DateInterval
    ) -> HydrationWeeklyReport {
        let previousWeekTotals = dailyTotals(from: previousWeekEvents)
        let elapsedDays = max(snapshot.weeklyElapsedDays, elapsedDayCount(in: elapsedWeekInterval))
        let previousAverageML: Double?
        let averageDeltaML: Double?
        let previousAchievedDays: Int?
        let achievedDayDelta: Int?

        if previousWeekEvents.isEmpty {
            previousAverageML = nil
            averageDeltaML = nil
            previousAchievedDays = nil
            achievedDayDelta = nil
        } else {
            let resolvedPreviousAverageML = previousWeekTotals.values.reduce(0, +) / Double(elapsedDays)
            let resolvedPreviousAchievedDays = achievedDayCount(in: previousWeekTotals)

            previousAverageML = resolvedPreviousAverageML
            averageDeltaML = snapshot.weeklyAverageML - resolvedPreviousAverageML
            previousAchievedDays = resolvedPreviousAchievedDays
            achievedDayDelta = snapshot.weeklyAchievedDays - resolvedPreviousAchievedDays
        }

        let emptySlot = mostFrequentlyEmptyTimeSlot(
            events: currentWeekEvents,
            interval: elapsedWeekInterval
        )

        return HydrationWeeklyReport(
            averageML: snapshot.weeklyAverageML,
            achievedDays: snapshot.weeklyAchievedDays,
            elapsedDays: elapsedDays,
            previousAverageML: previousAverageML,
            averageDeltaML: averageDeltaML,
            previousAchievedDays: previousAchievedDays,
            achievedDayDelta: achievedDayDelta,
            frequentlyEmptySlot: emptySlot?.slot,
            frequentlyEmptySlotMissingDays: emptySlot?.missingDays ?? 0,
            hasCurrentWeekRecords: currentWeekEvents.isEmpty == false
        )
    }

    private func mostFrequentlyEmptyTimeSlot(
        events: [HydrationEvent],
        interval: DateInterval
    ) -> (slot: HydrationWeeklyReportTimeSlot, missingDays: Int)? {
        guard events.isEmpty == false else {
            return nil
        }

        let eventsByDay = Dictionary(grouping: events) { event in
            calendar.startOfDay(for: event.consumedAt)
        }
        var missingCountBySlot = Dictionary(
            uniqueKeysWithValues: HydrationWeeklyReportTimeSlot.allCases.map { ($0, 0) }
        )
        var currentDate = interval.start

        while currentDate < interval.end {
            let dayEvents = eventsByDay[currentDate] ?? []
            for slot in HydrationWeeklyReportTimeSlot.allCases where !hasEvent(in: slot, events: dayEvents) {
                missingCountBySlot[slot, default: 0] += 1
            }

            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        return missingCountBySlot
            .filter { $0.value > 0 }
            .sorted { lhs, rhs in
                if lhs.value != rhs.value {
                    return lhs.value > rhs.value
                }

                return lhs.key.sortOrder < rhs.key.sortOrder
            }
            .first
            .map { (slot: $0.key, missingDays: $0.value) }
    }

    private func hasEvent(
        in slot: HydrationWeeklyReportTimeSlot,
        events: [HydrationEvent]
    ) -> Bool {
        events.contains { event in
            slot.contains(hour: calendar.component(.hour, from: event.consumedAt))
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

    private func weeklyAverageDetailText(for report: HydrationWeeklyReport) -> String {
        guard report.hasCurrentWeekRecords else {
            return L10n.tr("insightWeeklyReportStartGuideDetail")
        }

        guard let averageDeltaML = report.averageDeltaML else {
            return L10n.tr("insightWeeklyReportNoComparisonDetail")
        }

        let roundedDelta = Int(abs(averageDeltaML).rounded())
        if roundedDelta == 0 {
            return L10n.tr("insightWeeklyReportAverageStableDetail")
        }

        let deltaText = volumeText(Double(roundedDelta))
        if averageDeltaML > 0 {
            return L10n.tr("insightWeeklyReportAverageIncreasedDetailFormat", deltaText)
        }

        return L10n.tr("insightWeeklyReportAverageDecreasedDetailFormat", deltaText)
    }

    private func weeklyAchievedDetailText(for report: HydrationWeeklyReport) -> String {
        guard report.hasCurrentWeekRecords else {
            return L10n.tr("insightWeeklyReportStartGuideDetail")
        }

        guard let achievedDayDelta = report.achievedDayDelta else {
            return L10n.tr("insightElapsedDaysFormat", report.elapsedDays)
        }

        if achievedDayDelta == 0 {
            return L10n.tr("insightWeeklyReportAchievedStableDetail")
        }

        if achievedDayDelta > 0 {
            return L10n.tr("insightWeeklyReportAchievedIncreasedDetailFormat", achievedDayDelta)
        }

        return L10n.tr("insightWeeklyReportAchievedDecreasedDetailFormat", abs(achievedDayDelta))
    }

    private func weeklyEmptySlotValueText(for report: HydrationWeeklyReport) -> String {
        guard report.hasCurrentWeekRecords else {
            return L10n.tr("insightWeeklyReportPendingValue")
        }

        guard let slot = report.frequentlyEmptySlot else {
            return L10n.tr("insightWeeklyReportNoGapValue")
        }

        return slotText(for: slot)
    }

    private func weeklyEmptySlotDetailText(for report: HydrationWeeklyReport) -> String {
        guard report.hasCurrentWeekRecords else {
            return L10n.tr("insightWeeklyReportStartGuideDetail")
        }

        guard report.frequentlyEmptySlot != nil else {
            return L10n.tr("insightWeeklyReportNoGapDetail")
        }

        return L10n.tr(
            "insightWeeklyReportGapDetailFormat",
            report.frequentlyEmptySlotMissingDays,
            report.elapsedDays
        )
    }

    private func missedRoutineCoachingCard(
        _ missedRoutine: RoutineRecoveryMissedRoutine
    ) -> HydrationWeeklyCoachingCardModel {
        HydrationWeeklyCoachingCardModel(
            id: "missedRoutine-\(missedRoutine.uuid.uuidString)",
            badgeText: L10n.tr("insightWeeklyCoachingRoutineBadge"),
            title: L10n.tr(
                "insightWeeklyCoachingMissedRoutineTitleFormat",
                missedRoutine.timeText
            ),
            description: L10n.tr(
                "insightWeeklyCoachingMissedRoutineDescriptionFormat",
                missedRoutine.title,
                missedRoutine.missedCount
            ),
            actionTitle: reminderActionTitle(
                authorizedTitle: L10n.tr("insightWeeklyCoachingEditRoutineActionTitle")
            ),
            action: .routine(reminderAction(for: .edit(missedRoutine.uuid)))
        )
    }

    private func emptySlotCoachingCard(
        slot: HydrationWeeklyReportTimeSlot,
        report: HydrationWeeklyReport
    ) -> HydrationWeeklyCoachingCardModel {
        HydrationWeeklyCoachingCardModel(
            id: "emptySlot-\(slot)",
            badgeText: L10n.tr("insightWeeklyCoachingRoutineBadge"),
            title: L10n.tr(
                "insightWeeklyCoachingEmptySlotTitleFormat",
                slotText(for: slot)
            ),
            description: L10n.tr(
                "insightWeeklyCoachingEmptySlotDescriptionFormat",
                report.frequentlyEmptySlotMissingDays,
                report.elapsedDays
            ),
            actionTitle: reminderActionTitle(
                authorizedTitle: L10n.tr("insightWeeklyCoachingCreateRoutineActionTitle")
            ),
            action: .routine(reminderAction(for: .create))
        )
    }

    private func goalCoachingCard(for report: HydrationWeeklyReport) -> HydrationWeeklyCoachingCardModel? {
        guard report.hasCurrentWeekRecords,
              dailyGoalML > 0,
              report.elapsedDays >= 3 else {
            return nil
        }

        let averageRatio = report.averageML / dailyGoalML
        let achievementRate = Double(report.achievedDays) / Double(report.elapsedDays)

        if achievementRate == 0, averageRatio < 0.7 {
            return HydrationWeeklyCoachingCardModel(
                id: "goal-low",
                badgeText: L10n.tr("insightWeeklyCoachingGoalBadge"),
                title: L10n.tr("insightWeeklyCoachingGoalLowTitle"),
                description: L10n.tr(
                    "insightWeeklyCoachingGoalLowDescriptionFormat",
                    volumeText(dailyGoalML - report.averageML)
                ),
                actionTitle: L10n.tr("insightWeeklyCoachingGoalActionTitle"),
                action: .dailyGoal
            )
        }

        if achievementRate >= 0.8, averageRatio > 1.15 {
            return HydrationWeeklyCoachingCardModel(
                id: "goal-high",
                badgeText: L10n.tr("insightWeeklyCoachingGoalBadge"),
                title: L10n.tr("insightWeeklyCoachingGoalHighTitle"),
                description: L10n.tr(
                    "insightWeeklyCoachingGoalHighDescriptionFormat",
                    volumeText(report.averageML - dailyGoalML)
                ),
                actionTitle: L10n.tr("insightWeeklyCoachingGoalActionTitle"),
                action: .dailyGoal
            )
        }

        return nil
    }

    private func neutralCoachingCard(for report: HydrationWeeklyReport) -> HydrationWeeklyCoachingCardModel {
        if report.hasCurrentWeekRecords {
            return HydrationWeeklyCoachingCardModel(
                id: "neutral",
                badgeText: L10n.tr("insightWeeklyCoachingNeutralBadge"),
                title: L10n.tr("insightWeeklyCoachingNeutralTitle"),
                description: L10n.tr("insightWeeklyCoachingNeutralDescription"),
                actionTitle: nil,
                action: .none
            )
        }

        return HydrationWeeklyCoachingCardModel(
            id: "start",
            badgeText: L10n.tr("insightWeeklyCoachingNeutralBadge"),
            title: L10n.tr("insightWeeklyCoachingStartTitle"),
            description: L10n.tr("insightWeeklyCoachingStartDescription"),
            actionTitle: nil,
            action: .none
        )
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

    private func slotText(for slot: HydrationWeeklyReportTimeSlot) -> String {
        switch slot {
        case .morning:
            return L10n.tr("insightWeeklyReportMorningSlot")
        case .afternoon:
            return L10n.tr("insightWeeklyReportAfternoonSlot")
        case .evening:
            return L10n.tr("insightWeeklyReportEveningSlot")
        }
    }

    private var canRecordRecoveryDrink: Bool {
        guard dailyGoalML > 0 else {
            return true
        }

        return todayIntakeML + Double(HydrationServing.defaultGlassVolumeML) <= dailyGoalML
    }

    private var weakestMissedRoutine: RoutineRecoveryMissedRoutine? {
        guard let routineSummary = routineAdherenceInsight?.weakestRoutine,
              let uuid = UUID(uuidString: routineSummary.id) else {
            return nil
        }

        return RoutineRecoveryMissedRoutine(
            uuid: uuid,
            title: routineSummary.title,
            timeText: timeText(hour: routineSummary.hour, minute: routineSummary.minute),
            missedCount: routineSummary.missedCount
        )
    }

    private func reminderActionTitle(authorizedTitle: String) -> String {
        switch notificationStatus {
        case .authorized:
            return authorizedTitle
        case .notDetermined:
            return L10n.tr("insightRoutineRecoveryRequestPermissionTitle")
        case .denied:
            return L10n.tr("insightRoutineRecoveryOpenSettingsTitle")
        }
    }

    private func reminderAction(for actionIntent: RoutineActionIntent) -> RoutineRecoveryReminderAction {
        switch notificationStatus {
        case .authorized:
            return .manageRoutine(actionIntent)
        case .notDetermined:
            return .requestNotificationAuthorization(actionIntent)
        case .denied:
            return .openSettings
        }
    }

    private func analyticsAction(for action: RoutineRecoveryReminderAction) -> String {
        switch action {
        case .manageRoutine(let actionIntent):
            return analyticsAction(for: actionIntent)
        case .requestNotificationAuthorization:
            return "request_notification_permission"
        case .openSettings:
            return "open_settings"
        }
    }

    private func analyticsAction(for action: HydrationWeeklyCoachingAction) -> String {
        switch action {
        case .routine(let routineAction):
            return analyticsAction(for: routineAction)
        case .dailyGoal:
            return "daily_goal"
        case .none:
            return "none"
        }
    }

    private func analyticsAction(for actionIntent: RoutineActionIntent) -> String {
        switch actionIntent {
        case .create:
            return "create_routine"
        case .edit:
            return "edit_routine"
        }
    }
}

private struct RoutineRecoveryMissedRoutine: Equatable {
    let uuid: UUID
    let title: String
    let timeText: String
    let missedCount: Int
}

private extension HydrationWeeklyReportTimeSlot {
    var sortOrder: Int {
        switch self {
        case .morning:
            return 0
        case .afternoon:
            return 1
        case .evening:
            return 2
        }
    }

    func contains(hour: Int) -> Bool {
        switch self {
        case .morning:
            return (5..<12).contains(hour)
        case .afternoon:
            return (12..<18).contains(hour)
        case .evening:
            return (18..<24).contains(hour)
        }
    }
}
