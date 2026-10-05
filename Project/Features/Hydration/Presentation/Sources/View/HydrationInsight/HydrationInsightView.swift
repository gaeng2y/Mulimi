//
//  HydrationInsightView.swift
//  HydrationPresentation
//
//  Created by Codex on 3/14/26.
//

import Charts
import DesignSystem
import AccountDomain
import MulimiAnalytics
import HydrationDomain
import RoutineDomain
import Localization
import SwiftUI
import UIKit

public struct HydrationInsightView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.openURL) private var openURL
    @State private var viewModel: HydrationInsightViewModel
    @State private var selectedCategory: HydrationInsightCategory = .analysis
    private let onRoutineAction: (RoutineActionIntent) -> Void
    private let onDailyGoalAction: () -> Void
    private let onRecordAction: () -> Void

    public init(
        viewModel: HydrationInsightViewModel,
        onRoutineAction: @escaping (RoutineActionIntent) -> Void = { _ in },
        onDailyGoalAction: @escaping () -> Void = {},
        onRecordAction: @escaping () -> Void = {}
    ) {
        self._viewModel = State(wrappedValue: viewModel)
        self.onRoutineAction = onRoutineAction
        self.onDailyGoalAction = onDailyGoalAction
        self.onRecordAction = onRecordAction
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
                if viewModel.isLoading || (!viewModel.hasLoadedInsights && !viewModel.hasReadError) {
                    ProgressView(L10n.tr("insightLoadingTitle"))
                } else if viewModel.hasReadError, !viewModel.hasLoadedInsights {
                    HydrationReadFailureView(retry: { await viewModel.loadInsights() })
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
        .safeAreaInset(edge: .top) {
            if viewModel.hasReadError, viewModel.hasLoadedInsights {
                HydrationReadFailureView(
                    showsPreviousData: true,
                    isLoading: viewModel.isLoading,
                    retry: { await viewModel.loadInsights() }
                )
                .padding(.horizontal, 20)
            }
        }
    }

    private var insightContent: some View {
        VStack(spacing: 12) {
            categoryPicker
                .padding(.top, 20)

            ScrollView {
                VStack(spacing: 16) {
                    if viewModel.isEmpty {
                        emptyState
                    } else {
                        selectedCategoryContent
                    }
                }
                .padding(.bottom, 20)
            }
            .scrollIndicators(.hidden)
            .id(selectedCategory)
        }
    }

    private var metricColumns: [GridItem] {
        dynamicTypeSize.isAccessibilitySize ?
            [GridItem(.flexible())] : [GridItem(.adaptive(minimum: 130), spacing: 10)]
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
    }

    @ViewBuilder
    private var selectedCategoryContent: some View {
        switch selectedCategory {
        case .analysis:
            weeklySummaryCard
            weekdayPatternCard
            weeklyCoachingSection
        case .routine:
            routineAdherenceCard
        }
    }

    private var weeklySummaryCard: some View {
        InsightCard(
            title: L10n.tr("insightWeeklySummaryTitle"),
            subtitle: viewModel.weeklyPeriodText
        ) {
            VStack(alignment: .leading, spacing: 14) {
                LazyVGrid(columns: metricColumns, spacing: 10) {
                    ForEach(viewModel.weeklySummaryMetrics) { metric in
                        weeklyReportMetric(metric)
                    }
                }

                Text(L10n.tr("insightWeeklyComparisonPeriodDescription"))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.tr("insightMonthlyAverageFormat", viewModel.monthlyAverageText))
                        .font(.subheadline)
                    Text(viewModel.monthlyPeriodText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)

                Button {
                    onDailyGoalAction()
                } label: {
                    Label(
                        viewModel.dailyGoalML > 0 ?
                            L10n.tr("insightDailyGoalFormat", viewModel.dailyGoalText) :
                            L10n.tr("insightEmptyGoalCTATitle"),
                        systemImage: "target"
                    )
                    .font(.footnote)
                    .frame(minHeight: 44, alignment: .leading)
                }
                .accessibilityHint(L10n.tr("insightGoalActionAccessibilityHint"))
            }
        }
    }

    @ViewBuilder
    private var weeklyCoachingSection: some View {
        let cards = viewModel.hasReadError ? [] : viewModel.weeklyCoachingCards
        if let primaryCard = cards.first {
            VStack(alignment: .leading, spacing: 12) {
                Text(L10n.tr("insightNextActionTitle"))
                    .font(.headline)
                    .accessibilityAddTraits(.isHeader)

                weeklyCoachingCard(primaryCard)

                if cards.count > 1 {
                    DisclosureGroup(L10n.tr("insightMoreSuggestionsTitle")) {
                        ForEach(cards.dropFirst()) { card in
                            weeklyCoachingCard(card)
                        }
                        .padding(.top, 8)
                    }
                    .font(.subheadline)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
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
                        columns: metricColumns,
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

                if !viewModel.hasReadError, let recoveryCard = viewModel.routineRecoveryCard {
                    routineRecoveryCard(recoveryCard)
                }
            }
        }
    }

    private var weekdayPatternCard: some View {
        InsightCard(
            title: L10n.tr("insightWeekdayPatternTitle"),
            subtitle: L10n.tr("insightMonthlyPatternPeriodFormat", viewModel.monthlyPeriodText)
        ) {
            VStack(alignment: .leading, spacing: 14) {
                Text(viewModel.weekdayInsightText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                if !viewModel.weekdayDistributions.isEmpty {
                    weekdayPatternDetails
                }

                if let gap = viewModel.weeklyGapMetric {
                    Divider()
                    weeklyReportMetric(gap)
                }
            }
        }
    }

    private var weekdayPatternDetails: some View {
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

            LazyVGrid(columns: metricColumns, spacing: 12) {
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

            if viewModel.dailyGoalML > 0 {
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
        .accessibilityElement(children: .combine)
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
                .accessibilityHint(L10n.tr("insightCardActionAccessibilityHint"))
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
        .accessibilityElement(children: .combine)
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

            if row.status != .inactive && row.status != .noDueOccurrences {
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

            recoveryActionButtons(card)
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

    @ViewBuilder
    private func recoveryActionButtons(_ card: RoutineRecoveryCardModel) -> some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: 10) {
                recoveryRecordButton(card)
                recoveryReminderButton(card)
            }
        } else {
            HStack(spacing: 10) {
                recoveryRecordButton(card)
                recoveryReminderButton(card)
            }
        }
    }

    private func recoveryRecordButton(_ card: RoutineRecoveryCardModel) -> some View {
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
        .accessibilityHint(L10n.tr("insightRecoveryRecordAccessibilityHint"))
    }

    private func recoveryReminderButton(_ card: RoutineRecoveryCardModel) -> some View {
        Button {
            handleRecoveryReminderAction(card.reminderAction)
        } label: {
            Text(card.reminderActionTitle)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .accessibilityHint(L10n.tr("insightRecoveryReminderAccessibilityHint"))
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
            Image(systemName: "chart.bar.doc.horizontal")
                .font(.system(size: 44))
                .foregroundStyle(Color.accent)

            VStack(spacing: 8) {
                Text(L10n.tr("insightEmptyTitle"))
                    .font(.title3.weight(.bold))
                Text(L10n.tr("insightEmptyDescription"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            emptyStateCTAButtons
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }

    @ViewBuilder
    private var emptyStateCTAButtons: some View {
        VStack(spacing: 10) {
            ForEach(viewModel.emptyStateCTAs) { cta in
                emptyStateCTAButton(cta)
            }
        }
        .frame(maxWidth: 320)
        .padding(.top, 6)
    }

    @ViewBuilder
    private func emptyStateCTAButton(_ cta: HydrationInsightEmptyCTAModel) -> some View {
        let label = Label(cta.title, systemImage: cta.systemImage)
            .frame(maxWidth: .infinity)

        if cta.isPrimary {
            Button {
                handleEmptyStateAction(cta.action)
            } label: {
                label
            }
            .buttonStyle(.borderedProminent)
            .accessibilityHint(L10n.tr("insightCardActionAccessibilityHint"))
        } else {
            Button {
                handleEmptyStateAction(cta.action)
            } label: {
                label
            }
            .buttonStyle(.bordered)
            .accessibilityHint(L10n.tr("insightCardActionAccessibilityHint"))
        }
    }

    private func handleEmptyStateAction(_ action: HydrationInsightEmptyAction) {
        viewModel.trackEmptyStateAction(action)

        switch action {
        case .record:
            onRecordAction()
        case let .routine(routineAction):
            handleRecoveryReminderAction(routineAction, shouldTrack: false)
        case .dailyGoal:
            onDailyGoalAction()
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
    case analysis
    case routine

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .analysis:
            L10n.tr("insightCategoryAnalysisTitle")
        case .routine:
            L10n.tr("insightCategoryRoutineTitle")
        }
    }

    var systemImage: String {
        switch self {
        case .analysis:
            "chart.bar.xaxis"
        case .routine:
            "bell.badge"
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
                    .accessibilityAddTraits(.isHeader)
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
