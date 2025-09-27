//
//  RecordCalendarView.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-27.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import SwiftUI

struct RecordCalendarView: View {
    @Bindable private var viewModel: HydrationRecordListViewModel

    private let calendar = Calendar.current
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    private let weekDays = ["월", "화", "수", "목", "금", "토", "일"]
    private let dailyGoal: Double = 2000

    init(viewModel: HydrationRecordListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                monthHeader
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                weekDayHeader
                    .padding(.horizontal, 16)

                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(calendarDays, id: \.self) { day in
                            CalendarDayView(
                                day: day,
                                record: recordForDay(day),
                                isCurrentMonth: isCurrentMonth(day),
                                isToday: isToday(day),
                                dailyGoal: dailyGoal
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                }
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.fetchHydrationRecord()
        }
    }

    private var monthHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.date.formatted(.dateTime.year()))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(viewModel.date.formatted(.dateTime.month(.wide)))
                    .font(.title2)
                    .fontWeight(.bold)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("월 목표")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("\(monthlyProgress)%")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
        }
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

    private var monthlyProgress: Int {
        let daysInMonth = calendar.range(of: .day, in: .month, for: viewModel.date)?.count ?? 30
        let goalPerMonth = dailyGoal * Double(daysInMonth)
        let totalConsumed = viewModel.records.reduce(0) { $0 + $1.mililiter }
        return min(Int((totalConsumed / goalPerMonth) * 100), 100)
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
        guard let record = record else { return 0 }
        return min(record.mililiter / dailyGoal, 1.0)
    }

    private var progressLevel: Int {
        guard let record = record else { return 0 }
        let level = Int(record.mililiter / 250)
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