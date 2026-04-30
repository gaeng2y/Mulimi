//
//  HydrationRecordListViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation
import Localization

enum HydrationRecordPeriod: String, CaseIterable, Identifiable {
    case today
    case week
    case month

    var id: String {
        rawValue
    }

    var title: String {
        switch self {
        case .today:
            L10n.tr("historyPeriodTodayTitle")
        case .week:
            L10n.tr("historyPeriodWeekTitle")
        case .month:
            L10n.tr("historyPeriodMonthTitle")
        }
    }
}

struct HydrationRecordDaySummary: Identifiable, Equatable {
    let date: Date
    let totalML: Int
    let eventCount: Int
    let events: [HydrationEvent]

    var id: Date {
        date
    }

    var glassCount: Int {
        HydrationServing.glassCount(for: Double(totalML))
    }

    func isAchieved(dailyGoal: Double) -> Bool {
        Double(totalML) >= dailyGoal
    }
}

struct HydrationRecordPeriodSummary: Equatable {
    let totalML: Int
    let averageML: Int
    let eventCount: Int
    let recordedDays: Int
    let achievedDays: Int
    let dayCount: Int
    let glassCount: Int
    let progressPercent: Int

    static let empty = HydrationRecordPeriodSummary(
        totalML: 0,
        averageML: 0,
        eventCount: 0,
        recordedDays: 0,
        achievedDays: 0,
        dayCount: 1,
        glassCount: 0,
        progressPercent: 0
    )
}

@Observable
public final class HydrationRecordListViewModel {
    private(set) var records: [HydrationRecord] = []
    private(set) var daySummaries: [HydrationRecordDaySummary] = []
    private(set) var selectedPeriod: HydrationRecordPeriod = .month
    private(set) var periodSummary: HydrationRecordPeriodSummary = .empty
    private(set) var date: Date = .now
    private(set) var dailyLimit: Double
    private(set) var isMonthPickerPresented = false

    private(set) var errorMessage: String = ""
    private let useCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let widgetTimelineReloader: any WidgetTimelineReloading
    private let calendar: Calendar
    private let nowProvider: @Sendable () -> Date

    public init(
        useCase: DrinkWaterUseCase,
        userPreferencesUseCase: UserPreferencesUseCase,
        widgetTimelineReloader: any WidgetTimelineReloading = NoOpWidgetTimelineReloader(),
        calendar: Calendar = .current,
        nowProvider: @escaping @Sendable () -> Date = Date.init
    ) {
        self.useCase = useCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.widgetTimelineReloader = widgetTimelineReloader
        self.calendar = calendar
        self.nowProvider = nowProvider
        self.dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
    }

    @MainActor
    func onAppear() async {
        await fetchHydrationRecord()
    }

    public func showMonthPicker() {
        isMonthPickerPresented = true
    }

    public func dismissMonthPicker() {
        isMonthPickerPresented = false
    }

    @MainActor
    public func refresh() async {
        await fetchHydrationRecord()
    }

    @MainActor
    func updateSelectedPeriod(_ period: HydrationRecordPeriod) async {
        guard selectedPeriod != period else {
            return
        }

        selectedPeriod = period
        if period != .month {
            date = nowProvider()
        }
        await fetchHydrationRecord()
    }

    @MainActor
    func fetchHydrationRecord() async {
        dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        let periodDates = dates(for: selectedPeriod)
        var fetchedRecords: [HydrationRecord] = []
        var fetchedDaySummaries: [HydrationRecordDaySummary] = []

        for day in periodDates {
            let events = await useCase.hydrationEvents(on: day)
            let total = events.reduce(0) { partialResult, event in
                partialResult + event.volumeML
            }

            guard total > 0 else {
                continue
            }

            let dayStart = calendar.startOfDay(for: day)
            fetchedRecords.append(
                HydrationRecord(
                    id: UUID(),
                    date: dayStart,
                    mililiter: Double(total)
                )
            )
            fetchedDaySummaries.append(
                HydrationRecordDaySummary(
                    date: dayStart,
                    totalML: total,
                    eventCount: events.count,
                    events: events.sorted { $0.consumedAt < $1.consumedAt }
                )
            )
        }

        records = fetchedRecords.sorted { $0.date < $1.date }
        daySummaries = fetchedDaySummaries.sorted { $0.date < $1.date }
        periodSummary = makePeriodSummary(
            daySummaries: daySummaries,
            dayCount: max(periodDates.count, 1)
        )
    }

    @MainActor
    func updateDisplayedMonth(year: Int, month: Int) async {
        guard (1...12).contains(month),
              let newDate = calendar.date(
                from: DateComponents(year: year, month: month, day: 1)
              ) else {
            errorMessage = L10n.tr("historyInvalidDateSelectionError")
            return
        }

        let isSameDisplayedMonth = calendar.isDate(newDate, equalTo: date, toGranularity: .month)
        guard selectedPeriod != .month || !isSameDisplayedMonth else {
            return
        }

        selectedPeriod = .month
        date = newDate
        await fetchHydrationRecord()
    }

    @MainActor
    @discardableResult
    func deleteEvent(_ event: HydrationEvent) async -> Bool {
        guard event.isOwnedByCurrentApp else {
            errorMessage = L10n.tr("historyDeleteExternalRecordDescription")
            return false
        }

        let didDelete = await useCase.deleteHydrationEvent(id: event.id)
        guard didDelete else {
            errorMessage = L10n.tr("historyDeleteRecordFailureDescription")
            return false
        }

        errorMessage = ""
        await fetchHydrationRecord()
        widgetTimelineReloader.reloadAllTimelines()
        return true
    }

    func clearErrorMessage() {
        errorMessage = ""
    }

    var selectedPeriodRangeText: String {
        let periodDates = dates(for: selectedPeriod)
        guard let firstDate = periodDates.first,
              let lastDate = periodDates.last else {
            return ""
        }

        let startText = firstDate.formatted(.dateTime.month().day())
        let endText = lastDate.formatted(.dateTime.month().day())
        guard !calendar.isDate(firstDate, inSameDayAs: lastDate) else {
            return startText
        }

        return L10n.tr("historyPeriodRangeFormat", startText, endText)
    }

    var emptyStateTitle: String {
        switch selectedPeriod {
        case .today:
            L10n.tr("historyEmptyTodayTitle")
        case .week:
            L10n.tr("historyEmptyWeekTitle")
        case .month:
            L10n.tr("historyEmptyMonthTitle")
        }
    }

    var emptyStateDescription: String {
        L10n.tr("historyEmptyDescription")
    }

    private func dates(for period: HydrationRecordPeriod) -> [Date] {
        switch period {
        case .today:
            [calendar.startOfDay(for: nowProvider())]
        case .week:
            weekDates(containing: nowProvider())
        case .month:
            monthDates(for: date)
        }
    }

    private func monthDates(for date: Date) -> [Date] {
        guard let startDate = calendar.date(
            from: calendar.dateComponents([.year, .month], from: date)
        ),
        let range = calendar.range(of: .day, in: .month, for: startDate) else {
            errorMessage = L10n.tr("historyFailedDateRangeError")
            return []
        }

        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }

    private func weekDates(containing date: Date) -> [Date] {
        let dayStart = calendar.startOfDay(for: date)
        let weekday = calendar.component(.weekday, from: dayStart)
        let daysFromMonday = (weekday + 5) % 7
        guard let monday = calendar.date(byAdding: .day, value: -daysFromMonday, to: dayStart) else {
            return [dayStart]
        }

        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: monday)
        }
    }

    private func makePeriodSummary(
        daySummaries: [HydrationRecordDaySummary],
        dayCount: Int
    ) -> HydrationRecordPeriodSummary {
        let totalML = daySummaries.reduce(0) { $0 + $1.totalML }
        let eventCount = daySummaries.reduce(0) { $0 + $1.eventCount }
        let achievedDays = daySummaries.filter { $0.isAchieved(dailyGoal: dailyLimit) }.count
        let progressGoal = dailyLimit * Double(dayCount)
        let progressPercent = progressGoal > 0 ? min(Int((Double(totalML) / progressGoal) * 100), 100) : 0

        return HydrationRecordPeriodSummary(
            totalML: totalML,
            averageML: Int((Double(totalML) / Double(dayCount)).rounded()),
            eventCount: eventCount,
            recordedDays: daySummaries.count,
            achievedDays: achievedDays,
            dayCount: dayCount,
            glassCount: HydrationServing.glassCount(for: Double(totalML)),
            progressPercent: progressPercent
        )
    }
}
