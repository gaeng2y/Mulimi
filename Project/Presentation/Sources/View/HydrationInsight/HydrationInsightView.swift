//
//  HydrationInsightView.swift
//  PresentationLayer
//
//  Created by Codex on 3/14/26.
//

import Charts
import DesignSystem
import Localization
import SwiftUI

public struct HydrationInsightView: View {
    @State private var viewModel: HydrationInsightViewModel

    public init(viewModel: HydrationInsightViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
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
            VStack(spacing: 18) {
                overviewCard
                weekdayPatternCard
            }
            .padding(.vertical, 20)
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
}

private struct InsightCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

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
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(uiColor: .secondarySystemBackground).opacity(0.95))
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
