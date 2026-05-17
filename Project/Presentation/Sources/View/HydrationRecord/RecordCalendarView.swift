//
//  RecordCalendarView.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-27.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Localization
import SwiftUI

struct RecordCalendarView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var viewModel: HydrationRecordListViewModel
    @State private var selectedYear = Calendar.current.component(.year, from: .now)
    @State private var selectedMonth = Calendar.current.component(.month, from: .now)

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

    init(viewModel: HydrationRecordListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                Section {
                    summaryCard
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(calendarDays, id: \.self) { day in
                            CalendarDayView(
                                day: day,
                                record: recordForDay(day),
                                isCurrentMonth: isCurrentMonth(day),
                                isToday: isToday(day),
                                dailyGoal: viewModel.dailyLimit
                            )
                        }
                    }
                    .padding(.horizontal, 16)

                    recordListSection
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                } header: {
                    VStack(spacing: 12) {
                        periodPicker
                            .padding(.horizontal, 16)
                            .padding(.top, 12)

                        monthHeader
                            .padding(.horizontal, 16)

                        weekDayHeader
                            .padding(.horizontal, 16)
                            .padding(.bottom, 8)
                    }
                    .background(Color(uiColor: .systemGroupedBackground))
                }
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .sheet(isPresented: Binding(
            get: { viewModel.isMonthPickerPresented },
            set: { isPresented in
                if !isPresented {
                    viewModel.dismissMonthPicker()
                }
            }
        )) {
            yearMonthPickerSheet
        }
    }

    private var periodPicker: some View {
        Picker(
            L10n.tr("historyPeriodPickerAccessibilityLabel"),
            selection: Binding(
                get: { viewModel.selectedPeriod },
                set: { period in
                    Task {
                        await viewModel.updateSelectedPeriod(period)
                    }
                }
            )
        ) {
            ForEach(HydrationRecordPeriod.allCases) { period in
                Text(period.title)
                    .tag(period)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel(L10n.tr("historyPeriodPickerAccessibilityLabel"))
    }

    private var monthHeader: some View {
        HStack {
            if viewModel.selectedPeriod == .month {
                Button {
                    syncPickerSelectionWithCurrentDate()
                    viewModel.showMonthPicker()
                } label: {
                    HStack(spacing: 8) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.date.formatted(.dateTime.year()))
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text(viewModel.date.formatted(.dateTime.month(.wide)))
                                .font(.title2)
                                .fontWeight(.bold)
                        }

                        Image(systemName: "chevron.down")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(L10n.tr("recordCalendarMonthPickerAccessibilityLabel"))
                .accessibilityHint(L10n.tr("recordCalendarMonthPickerAccessibilityHint"))
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.selectedPeriod.title)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(viewModel.selectedPeriodRangeText)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(L10n.tr("historyPeriodGoalTitle"))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(L10n.tr("commonPercentFormat", viewModel.periodSummary.progressPercent))
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(L10n.tr("historySummaryTitle"))
                        .font(.headline)

                    Text(viewModel.selectedPeriodRangeText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(L10n.tr("commonMilliliterFormat", viewModel.periodSummary.totalML))
                        .font(.title2.weight(.bold))

                    Text(L10n.tr("drinkWaterGlassCountFormat", viewModel.periodSummary.glassCount))
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.accentColor)
                }
            }

            LazyVGrid(columns: summaryMetricColumns, spacing: 8) {
                SummaryMetricView(
                    title: L10n.tr("historySummaryAverageTitle"),
                    value: L10n.tr("commonMilliliterFormat", viewModel.periodSummary.averageML),
                    systemImage: "chart.bar"
                )

                SummaryMetricView(
                    title: L10n.tr("historySummaryRecordCountTitle"),
                    value: L10n.tr("historyRecordCountFormat", viewModel.periodSummary.eventCount),
                    systemImage: "list.bullet.clipboard"
                )

                SummaryMetricView(
                    title: L10n.tr("historySummaryAchievedDaysTitle"),
                    value: L10n.tr(
                        "historyAchievedDaysFormat",
                        viewModel.periodSummary.achievedDays,
                        viewModel.periodSummary.dayCount
                    ),
                    systemImage: "checkmark.seal"
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
    }

    private var summaryMetricColumns: [GridItem] {
        let count = dynamicTypeSize.isAccessibilitySize ? 1 : 3
        return Array(repeating: GridItem(.flexible(), spacing: 8), count: count)
    }

    private var recordListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(L10n.tr("historyRecordListTitle"))
                    .font(.headline)

                Spacer()

                Text(L10n.tr("historyRecordedDaysFormat", viewModel.periodSummary.recordedDays))
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }

            if viewModel.daySummaries.isEmpty {
                emptyStateCard
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.daySummaries.reversed()) { summary in
                        HydrationRecordDaySummaryRow(
                            summary: summary,
                            dailyGoal: viewModel.dailyLimit,
                            onDeleteEvent: { event in
                                Task {
                                    await viewModel.deleteEvent(event)
                                }
                            }
                        )
                    }
                }
            }
        }
    }

    private var emptyStateCard: some View {
        VStack(spacing: 8) {
            Image(systemName: "drop.fill")
                .font(.title2)
                .foregroundColor(.accentColor)

            Text(viewModel.emptyStateTitle)
                .font(.subheadline.weight(.semibold))

            Text(viewModel.emptyStateDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
    }

    private var weekDayHeader: some View {
        HStack(spacing: 8) {
            ForEach(weekDays.indices, id: \.self) { index in
                Text(weekDays[index])
                    .font(.caption)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(index >= 5 ? .red.opacity(0.7) : .secondary)
            }
        }
    }

    private var calendarDays: [Date] {
        guard let monthRange = calendar.range(of: .day, in: .month, for: viewModel.date),
              let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: viewModel.date)
              ) else {
            return []
        }

        var firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 2
        if firstWeekday < 0 {
            firstWeekday = 6
        }

        var days: [Date] = []

        if firstWeekday > 0 {
            for offset in (1...firstWeekday).reversed() {
                if let date = calendar.date(byAdding: .day, value: -offset, to: firstDayOfMonth) {
                    days.append(date)
                }
            }
        }

        for day in monthRange {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }

        let remainingDays = (7 - (days.count % 7)) % 7
        if remainingDays > 0 {
            let lastDay = days.last ?? firstDayOfMonth
            for offset in 1...remainingDays {
                if let date = calendar.date(byAdding: .day, value: offset, to: lastDay) {
                    days.append(date)
                }
            }
        }

        return days
    }

    private func isCurrentMonth(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: viewModel.date, toGranularity: .month)
    }

    private func recordForDay(_ date: Date) -> HydrationRecord? {
        viewModel.records.first { record in
            calendar.isDate(record.date, inSameDayAs: date)
        }
    }

    private func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    private var selectableYears: [Int] {
        let currentYear = calendar.component(.year, from: .now)
        return Array((currentYear - 10)...(currentYear + 2))
    }

    private var weekDays: [String] {
        [
            L10n.tr("commonWeekdayMondayShort"),
            L10n.tr("commonWeekdayTuesdayShort"),
            L10n.tr("commonWeekdayWednesdayShort"),
            L10n.tr("commonWeekdayThursdayShort"),
            L10n.tr("commonWeekdayFridayShort"),
            L10n.tr("commonWeekdaySaturdayShort"),
            L10n.tr("commonWeekdaySundayShort")
        ]
    }

    @ViewBuilder
    private var yearMonthPickerSheet: some View {
        NavigationStack {
            HStack(spacing: 0) {
                Picker(L10n.tr("recordCalendarYearPickerTitle"), selection: $selectedYear) {
                    ForEach(selectableYears, id: \.self) { year in
                        Text(L10n.tr("commonYearFormat", year))
                            .tag(year)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .clipped()

                Picker(L10n.tr("recordCalendarMonthPickerTitle"), selection: $selectedMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(L10n.tr("commonMonthFormat", month))
                            .tag(month)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .clipped()
            }
            .navigationTitle(L10n.tr("recordCalendarSelectionTitle"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.tr("commonCancelTitle")) {
                        viewModel.dismissMonthPicker()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.tr("commonApplyTitle")) {
                        Task {
                            await viewModel.updateDisplayedMonth(
                                year: selectedYear,
                                month: selectedMonth
                            )
                        }
                        viewModel.dismissMonthPicker()
                    }
                }
            }
        }
        .presentationDetents([.height(320)])
        .presentationDragIndicator(.visible)
    }

    private func syncPickerSelectionWithCurrentDate() {
        selectedYear = calendar.component(.year, from: viewModel.date)
        selectedMonth = calendar.component(.month, from: viewModel.date)
    }
}

private struct SummaryMetricView: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: systemImage)
                .font(.caption.weight(.semibold))
                .foregroundColor(.accentColor)

            Text(value)
                .font(.subheadline.weight(.semibold))

            Text(title)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.accentColor.opacity(0.08))
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.tr("historySummaryMetricAccessibilityLabelFormat", title, value))
    }
}

private struct HydrationRecordDaySummaryRow: View {
    let summary: HydrationRecordDaySummary
    let dailyGoal: Double
    let onDeleteEvent: (HydrationEvent) -> Void

    private var progressPercent: Int {
        guard dailyGoal > 0 else {
            return 0
        }

        return min(Int((Double(summary.totalML) / dailyGoal) * 100), 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                WaterDropIndicator(
                    amount: Double(summary.totalML),
                    goal: dailyGoal,
                    isCompact: true
                )
                .frame(width: 34, height: 34)

                VStack(alignment: .leading, spacing: 4) {
                    Text(summary.date.formatted(.dateTime.month().day().weekday(.wide)))
                        .font(.subheadline.weight(.semibold))

                    Text(
                        L10n.tr(
                            "historyDaySummaryDescriptionFormat",
                            summary.eventCount,
                            progressPercent
                        )
                    )
                    .font(.caption)
                    .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(L10n.tr("commonMilliliterFormat", summary.totalML))
                        .font(.subheadline.weight(.semibold))

                    Text(L10n.tr("drinkWaterGlassCountFormat", summary.glassCount))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            VStack(spacing: 8) {
                ForEach(summary.events.reversed()) { event in
                    HydrationRecordEventRow(
                        event: event,
                        onDelete: {
                            onDeleteEvent(event)
                        }
                    )
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
    }
}

private struct HydrationRecordEventRow: View {
    let event: HydrationEvent
    let onDelete: () -> Void

    private var timeText: String {
        event.consumedAt.formatted(.dateTime.hour().minute())
    }

    private var sourceText: String {
        event.isOwnedByCurrentApp ?
            L10n.tr("historyRecordOwnedSourceTitle") :
            L10n.tr("historyRecordExternalSourceTitle")
    }

    private var volumeText: String {
        L10n.tr("commonMilliliterFormat", event.volumeML)
    }

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: event.isOwnedByCurrentApp ? "drop.fill" : "heart.text.square")
                .font(.caption.weight(.semibold))
                .foregroundColor(event.isOwnedByCurrentApp ? .accentColor : .secondary)
                .frame(width: 24, height: 24)
                .accessibilityHidden(true)
                .background(
                    Circle()
                        .fill(Color.accentColor.opacity(event.isOwnedByCurrentApp ? 0.12 : 0.06))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(timeText)
                    .font(.caption.weight(.semibold))

                Text(sourceText)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .accessibilityElement(children: .combine)

            Spacer()

            Text(volumeText)
                .font(.caption.weight(.semibold))

            if event.isOwnedByCurrentApp {
                Button(role: .destructive, action: onDelete) {
                    Text(L10n.tr("commonDeleteTitle"))
                        .font(.caption.weight(.semibold))
                }
                .buttonStyle(.bordered)
                .accessibilityLabel(
                    L10n.tr(
                        "historyRecordDeleteAccessibilityLabelFormat",
                        timeText,
                        volumeText
                    )
                )
                .accessibilityHint(L10n.tr("historyRecordDeleteAccessibilityHint"))
            } else {
                Text(L10n.tr("historyRecordDeleteUnavailableTitle"))
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.secondary)
                    .accessibilityLabel(
                        L10n.tr(
                            "historyRecordDeleteUnavailableAccessibilityLabelFormat",
                            timeText,
                            volumeText
                        )
                    )
            }
        }
    }
}

private struct CalendarDayView: View {
    let day: Date
    let record: HydrationRecord?
    let isCurrentMonth: Bool
    let isToday: Bool
    let dailyGoal: Double

    private var dayNumber: String {
        day.formatted(.dateTime.day())
    }

    private var progressPercentage: Double {
        guard let record = record, dailyGoal > 0 else { return 0 }
        return min(record.mililiter / dailyGoal, 1.0)
    }

    private var progressLevel: Int {
        guard let record = record else { return 0 }
        let level = HydrationServing.glassCount(for: record.mililiter)
        return min(level, 8)
    }

    private var backgroundColor: Color {
        if isToday {
            return Color.accentColor.opacity(0.05)
        } else if !isCurrentMonth {
            return Color.clear
        }
        return Color(uiColor: .systemBackground)
    }

    private var borderColor: Color {
        if isToday {
            return Color.accentColor
        }
        return Color.clear
    }

    private var accessibilityLabel: String {
        let dateText = day.formatted(.dateTime.year().month().day().weekday(.wide))

        guard let record else {
            return L10n.tr("recordCalendarDayEmptyAccessibilityLabelFormat", dateText)
        }

        return L10n.tr(
            "recordCalendarDayAccessibilityLabelFormat",
            dateText,
            L10n.tr("commonMilliliterFormat", Int(record.mililiter.rounded())),
            Int((progressPercentage * 100).rounded())
        )
    }

    var body: some View {
        VStack(spacing: 2) {
            Text(dayNumber)
                .font(.system(size: 14, weight: isToday ? .bold : .medium))
                .foregroundColor(
                    isCurrentMonth ?
                    (isToday ? .accentColor : .primary) :
                    .gray.opacity(0.5)
                )

            if let record = record {
                WaterDropIndicator(
                    amount: record.mililiter,
                    goal: dailyGoal,
                    isCompact: true
                )
                .frame(width: 28, height: 28)

                Text("\(Int(record.mililiter))")
                    .font(.system(size: 9))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            } else if isCurrentMonth {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1.5)
                    .frame(width: 28, height: 28)

                Text("-")
                    .font(.system(size: 9))
                    .foregroundColor(.gray.opacity(0.5))
            } else {
                Spacer()
                    .frame(height: 37)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(backgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(borderColor, lineWidth: isToday ? 2 : 1)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }
}

private struct WaterDropIndicator: View {
    let amount: Double
    let goal: Double
    let isCompact: Bool

    private var fillPercentage: Double {
        min(amount / goal, 1.0)
    }

    private var gradientColors: [Color] {
        if fillPercentage >= 1.0 {
            return [Color.green.opacity(0.8), Color.green]
        } else if fillPercentage >= 0.5 {
            return [Color.blue.opacity(0.6), Color.blue]
        } else {
            return [Color.gray.opacity(0.3), Color.gray.opacity(0.5)]
        }
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(fillPercentage == 0 ? 0.1 : fillPercentage * 0.8 + 0.2)

            if fillPercentage >= 1.0 {
                Image(systemName: "checkmark")
                    .font(.system(size: isCompact ? 12 : 20, weight: .bold))
                    .foregroundColor(.white)
            } else if fillPercentage > 0 {
                Image(systemName: "drop.fill")
                    .font(.system(size: isCompact ? 10 : 16))
                    .foregroundColor(.white.opacity(0.9))
            }
        }
    }
}

private struct HydrationProgressBar: View {
    let level: Int
    let isAnimated: Bool = true

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.1))

                HStack(spacing: 1) {
                    ForEach(0..<8, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(
                                index < level ?
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.blue.opacity(0.7),
                                            Color.blue
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ) :
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.gray.opacity(0.1),
                                            Color.gray.opacity(0.15)
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                            )
                            .frame(width: (geometry.size.width - 7) / 8)
                            .animation(
                                isAnimated ?
                                    .spring(response: 0.3, dampingFraction: 0.7)
                                        .delay(Double(index) * 0.05) :
                                    nil,
                                value: level
                            )
                    }
                }
            }
        }
    }
}
