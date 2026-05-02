//
//  HydrationInsightView.swift
//  PresentationLayer
//
//  Created by Codex on 3/14/26.
//

import Charts
import DesignSystem
import DomainLayerInterface
import Localization
import SwiftUI
import UIKit

public struct HydrationInsightView: View {
    @Environment(\.openURL) private var openURL
    @State private var viewModel: HydrationInsightViewModel
    @State private var selectedCategory: HydrationInsightCategory = .overview
    private let onRoutineAction: (RoutineActionIntent) -> Void
    private let onDailyGoalAction: () -> Void

    public init(
        viewModel: HydrationInsightViewModel,
        onRoutineAction: @escaping (RoutineActionIntent) -> Void = { _ in },
        onDailyGoalAction: @escaping () -> Void = {}
    ) {
        self._viewModel = State(wrappedValue: viewModel)
        self.onRoutineAction = onRoutineAction
        self.onDailyGoalAction = onDailyGoalAction
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.background,
                    Color.accent.opacity(0.08),
                    Color.background
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Circle()
                .fill(Color.accentColor.opacity(0.16))
                .frame(width: 180, height: 180)
                .blur(radius: 42)
                .offset(x: -120, y: -220)

            Circle()
                .fill(Color.cyan.opacity(0.14))
                .frame(width: 220, height: 220)
                .blur(radius: 52)
                .offset(x: 140, y: 180)

            Group {
                if viewModel.isLoading {
                    ProgressView(L10n.tr("insightLoadingTitle"))
                } else if viewModel.isEmpty {
                    emptyState
                } else {
                    insightContent
                }
            }
            .padding(.horizontal, 20)
        }
        .task {
            await viewModel.loadInsights()
        }
        .refreshable {
            await viewModel.loadInsights()
        }
    }

    private var insightContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                categoryPicker

                selectedCategoryContent
            }
            .padding(.vertical, 20)
        }
        .scrollIndicators(.hidden)
    }

    private var categoryPicker: some View {
        LiquidGlassSegmentedControl(
            selection: $selectedCategory,
            segments: HydrationInsightCategory.allCases.map { category in
                LiquidGlassSegment(
                    value: category,
                    title: category.title,
                    systemImage: category.systemImage
                )
            }
        )
        .accessibilityLabel(L10n.tr("insightCategoryPickerAccessibilityLabel"))
    }

    @ViewBuilder
    private var selectedCategoryContent: some View {
        switch selectedCategory {
        case .overview:
            overviewCard
        case .pattern:
            if viewModel.weekdayDistributions.isEmpty {
                categoryEmptyCard(
                    title: L10n.tr("insightPatternEmptyTitle"),
                    description: viewModel.weekdayInsightText,
                    systemImage: "chart.bar.doc.horizontal"
                )
            } else {
                weekdayPatternCard
            }
        case .routine:
            routineAdherenceCard
        case .report:
            weeklyReportCard
        }
    }

    private var overviewCard: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.accent.opacity(0.95),
                            Color.cyan.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .fill(.white.opacity(0.18))
                .frame(width: 120, height: 120)
                .offset(x: 30, y: -30)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

            VStack(alignment: .leading, spacing: 16) {
                Label(L10n.tr("insightOverviewTitle"), systemImage: "chart.bar.xaxis")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.92))

                VStack(alignment: .leading, spacing: 6) {
                    Text(L10n.tr("insightDailyGoalFormat", viewModel.dailyGoalText))
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                }

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    ForEach(viewModel.metrics) { metric in
                        OverviewMetricTile(metric: metric)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(22)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 14)
    }

    private var weeklyReportCard: some View {
        InsightCard(
            title: L10n.tr("insightWeeklyReportTitle"),
            subtitle: viewModel.weeklyReportInsightText
        ) {
            VStack(alignment: .leading, spacing: 14) {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(viewModel.weeklyReportMetrics) { metric in
                        weeklyReportMetric(metric)
                    }
                }

                ForEach(viewModel.weeklyCoachingCards) { card in
                    weeklyCoachingCard(card)
                }
            }
        }
    }

    private var routineAdherenceCard: some View {
        InsightCard(
            title: L10n.tr("insightRoutineAdherenceTitle"),
            subtitle: viewModel.routineAdherenceInsightText
        ) {
            VStack(alignment: .leading, spacing: 16) {
                if !viewModel.routineAdherenceMetrics.isEmpty {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ],
                        spacing: 10
                    ) {
                        ForEach(viewModel.routineAdherenceMetrics) { metric in
                            routineAdherenceMetric(metric)
                        }
                    }
                }

                if viewModel.routineAdherenceRows.isEmpty {
                    Text(L10n.tr("insightRoutineAdherenceNoRoutineDescription"))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    VStack(spacing: 10) {
                        ForEach(viewModel.routineAdherenceRows) { row in
                            routineAdherenceRow(row)
                        }
                    }
                }

                if let recoveryCard = viewModel.routineRecoveryCard {
                    routineRecoveryCard(recoveryCard)
                }
            }
        }
    }

    private var weekdayPatternCard: some View {
        InsightCard(
            title: L10n.tr("insightWeekdayPatternTitle"),
            subtitle: viewModel.weekdayInsightText
        ) {
            VStack(alignment: .leading, spacing: 14) {
                Chart(viewModel.weekdayDistributions) { distribution in
                    BarMark(
                        x: .value(L10n.tr("insightChartWeekdayAxisTitle"), distribution.label),
                        y: .value(
                            L10n.tr("insightChartAverageIntakeAxisTitle"),
                            distribution.averageIntakeML
                        )
                    )
                    .cornerRadius(8)
                    .foregroundStyle(
                        distribution.weekday == viewModel.bestWeekday?.weekday ?
                        Color.accent.gradient :
                        Color.cyan.opacity(0.55).gradient
                    )

                    if viewModel.dailyGoalML > 0 {
                        RuleMark(
                            y: .value(
                                L10n.tr("insightChartGoalAxisTitle"),
                                viewModel.dailyGoalML
                            )
                        )
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [5, 4]))
                            .foregroundStyle(Color.secondary.opacity(0.7))
                    }
                }
                .chartYScale(domain: 0...max(viewModel.chartUpperBound, 1))
                .chartLegend(.hidden)
                .frame(height: 220)

                HStack(spacing: 12) {
                    if let bestWeekday = viewModel.bestWeekday {
                        BadgeView(
                            title: L10n.tr("insightMostDrankDayTitle"),
                            value: L10n.tr(
                                "insightWeekdayBadgeValueFormat",
                                bestWeekday.label,
                                Int(bestWeekday.averageIntakeML.rounded())
                            )
                        )
                    }

                    if let leastWeekday = viewModel.leastWeekday {
                        BadgeView(
                            title: L10n.tr("insightLeastDrankDayTitle"),
                            value: L10n.tr(
                                "insightWeekdayBadgeValueFormat",
                                leastWeekday.label,
                                Int(leastWeekday.averageIntakeML.rounded())
                            )
                        )
                    }
                }

                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.secondary.opacity(0.7))
                        .frame(width: 8, height: 8)
                    Text(L10n.tr("insightGoalRuleDescription"))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func weeklyReportMetric(_ metric: HydrationWeeklyReportMetric) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(metric.title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(metric.value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)

            Text(metric.detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 86, alignment: .leading)
        .padding(12)
        .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func weeklyCoachingCard(_ card: HydrationWeeklyCoachingCardModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(card.badgeText, systemImage: "sparkles")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.accentColor)

            VStack(alignment: .leading, spacing: 6) {
                Text(card.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(card.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let actionTitle = card.actionTitle {
                Button {
                    handleWeeklyCoachingAction(card.action)
                } label: {
                    Text(actionTitle)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [
                    Color.accentColor.opacity(0.14),
                    Color(uiColor: .systemBackground).opacity(0.82)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.accentColor.opacity(0.14), lineWidth: 1)
        }
    }

    private func routineAdherenceMetric(_ metric: RoutineAdherenceInsightMetric) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(metric.title)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(metric.value)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)

            Text(metric.detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 82, alignment: .leading)
        .padding(12)
        .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func routineAdherenceRow(_ row: RoutineAdherenceDisplayRow) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.title)
                        .font(.subheadline.weight(.semibold))
                    Text(row.timeText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(row.statusText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(routineAdherenceStatusColor(row.status))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        routineAdherenceStatusColor(row.status).opacity(0.12),
                        in: Capsule(style: .continuous)
                    )
            }

            ProgressView(value: row.progress)
                .tint(routineAdherenceStatusColor(row.status))

            HStack {
                Text(row.detailText)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(row.rateText)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
            }
        }
        .padding(12)
        .background(Color(uiColor: .systemBackground).opacity(0.74))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func routineAdherenceStatusColor(_ status: HydrationRoutineAdherenceStatus) -> Color {
        switch status {
        case .inactive, .noDueOccurrences:
            return .secondary
        case .noRecords, .needsAttention:
            return .orange
        case .onTrack:
            return .accentColor
        }
    }

    private func routineRecoveryCard(_ card: RoutineRecoveryCardModel) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(card.badgeText, systemImage: "arrow.counterclockwise.circle.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.orange)

            VStack(alignment: .leading, spacing: 6) {
                Text(card.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(card.description)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 10) {
                Button {
                    Task {
                        await viewModel.recordRecoveryDrink()
                    }
                } label: {
                    Label(card.recordActionTitle, systemImage: "drop.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!card.canRecordNow)

                Button {
                    handleRecoveryReminderAction(card.reminderAction)
                } label: {
                    Text(card.reminderActionTitle)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [
                    Color.orange.opacity(0.16),
                    Color(uiColor: .systemBackground).opacity(0.78)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.orange.opacity(0.16), lineWidth: 1)
        }
    }

    private func handleRecoveryReminderAction(
        _ action: RoutineRecoveryReminderAction,
        shouldTrack: Bool = true
    ) {
        if shouldTrack {
            viewModel.trackRecoveryReminderAction(action)
        }

        switch action {
        case let .manageRoutine(actionIntent):
            onRoutineAction(actionIntent)
        case let .requestNotificationAuthorization(actionIntent):
            Task {
                if let nextAction = await viewModel.requestRecoveryNotificationAuthorization(then: actionIntent) {
                    onRoutineAction(nextAction)
                }
            }
        case .openSettings:
            openSettings()
        }
    }

    private func handleWeeklyCoachingAction(_ action: HydrationWeeklyCoachingAction) {
        viewModel.trackWeeklyCoachingAction(action)

        switch action {
        case let .routine(routineAction):
            handleRecoveryReminderAction(routineAction, shouldTrack: false)
        case .dailyGoal:
            onDailyGoalAction()
        case .none:
            break
        }
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 44))
                .foregroundStyle(Color.accent)

            VStack(spacing: 8) {
                Text(L10n.tr("insightEmptyTitle"))
                    .font(.title3.weight(.bold))
                Text(L10n.tr("insightEmptyDescriptionFormat", viewModel.dailyGoalText))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func categoryEmptyCard(
        title: String,
        description: String,
        systemImage: String
    ) -> some View {
        InsightCard(
            title: title,
            subtitle: description
        ) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 42, height: 42)
                    .background(Color.accentColor.opacity(0.12), in: Circle())

                Text(L10n.tr("insightCategoryEmptyGuideDescription"))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)
            }
        }
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(settingsURL)
    }
}

private enum HydrationInsightCategory: CaseIterable, Identifiable {
    case overview
    case pattern
    case routine
    case report

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .overview:
            L10n.tr("insightCategoryOverviewTitle")
        case .pattern:
            L10n.tr("insightCategoryPatternTitle")
        case .routine:
            L10n.tr("insightCategoryRoutineTitle")
        case .report:
            L10n.tr("insightCategoryReportTitle")
        }
    }

    var systemImage: String {
        switch self {
        case .overview:
            "chart.bar.xaxis"
        case .pattern:
            "calendar"
        case .routine:
            "bell.badge"
        case .report:
            "doc.text.magnifyingglass"
        }
    }
}

private struct InsightCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    init(
        title: String,
        subtitle: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(cardBorder, lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 12)
    }

    private var cardBackground: AnyShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(Color(uiColor: .secondarySystemBackground))
        }

        return AnyShapeStyle(.ultraThinMaterial)
    }

    private var cardBorder: LinearGradient {
        LinearGradient(
            colors: [
                .white.opacity(0.42),
                .white.opacity(0.1),
                Color.accentColor.opacity(0.1)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct OverviewMetricTile: View {
    let metric: HydrationInsightMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric.title)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.78))

            Text(metric.value)
                .font(.title3.weight(.bold))
                .foregroundStyle(.white)

            Text(metric.detail)
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.72))
        }
        .frame(maxWidth: .infinity, minHeight: 84, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private struct BadgeView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Capsule(style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
    }
}
