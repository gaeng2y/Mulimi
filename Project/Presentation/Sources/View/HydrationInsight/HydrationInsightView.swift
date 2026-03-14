//
//  HydrationInsightView.swift
//  PresentationLayer
//
//  Created by Codex on 3/14/26.
//

import Charts
import DesignSystem
import SwiftUI

public struct HydrationInsightView: View {
    @State private var viewModel: HydrationInsightViewModel

    public init(viewModel: HydrationInsightViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
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
                        ProgressView("인사이트 불러오는 중...")
                    } else if viewModel.isEmpty {
                        emptyState
                    } else {
                        insightContent
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle("인사이트")
            .task {
                await viewModel.loadInsights()
            }
            .refreshable {
                await viewModel.loadInsights()
            }
        }
    }

    private var insightContent: some View {
        ScrollView {
            VStack(spacing: 18) {
                overviewCard

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 14),
                        GridItem(.flexible(), spacing: 14)
                    ],
                    spacing: 14
                ) {
                    ForEach(viewModel.metrics) { metric in
                        MetricCard(metric: metric)
                    }
                }

                streakCard
                weekdayPatternCard
            }
            .padding(.vertical, 20)
        }
    }

    private var overviewCard: some View {
        ZStack(alignment: .topTrailing) {
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

            VStack(alignment: .leading, spacing: 16) {
                Label("이번 주와 이번 달 흐름", systemImage: "chart.bar.xaxis")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.92))

                VStack(alignment: .leading, spacing: 6) {
                    Text("하루 목표는 \(viewModel.dailyGoalText)")
                        .font(.title3.weight(.bold))
                        .foregroundStyle(.white)
                    Text("이번 주 달성률 \(viewModel.weeklyAchievementText), 이번 달 달성률 \(viewModel.monthlyAchievementText)")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.88))
                        .fixedSize(horizontal: false, vertical: true)
                }

                HStack(spacing: 12) {
                    PillLabel(title: "현재 streak", value: viewModel.streakText)
                    PillLabel(title: "이번 달 평균", value: "\(Int(viewModel.monthlyAverageML.rounded()))ml")
                }
            }
            .padding(22)
        }
        .shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 14)
    }

    private var streakCard: some View {
        InsightCard(title: "연속 달성 흐름", subtitle: "오늘 목표를 아직 채우지 않았다면 어제까지의 연속 달성일을 보여줍니다.") {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(viewModel.streakText)
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                    Text("연속 목표 달성")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 10) {
                    AchievementProgressRow(
                        title: "이번 주",
                        detail: "\(viewModel.weeklyAchievedDays)/\(max(viewModel.weeklyElapsedDays, 1))일 달성",
                        progress: viewModel.weeklyAchievementRate
                    )
                    AchievementProgressRow(
                        title: "이번 달",
                        detail: "\(viewModel.monthlyAchievedDays)/\(max(viewModel.monthlyElapsedDays, 1))일 달성",
                        progress: viewModel.monthlyAchievementRate
                    )
                }
            }
        }
    }

    private var weekdayPatternCard: some View {
        InsightCard(title: "이번 달 요일 패턴", subtitle: viewModel.weekdayInsightText) {
            VStack(alignment: .leading, spacing: 14) {
                Chart(viewModel.weekdayDistributions) { distribution in
                    BarMark(
                        x: .value("요일", distribution.label),
                        y: .value("평균 섭취량", distribution.averageIntakeML)
                    )
                    .cornerRadius(8)
                    .foregroundStyle(
                        distribution.weekday == viewModel.bestWeekday?.weekday ?
                        Color.accent.gradient :
                        Color.cyan.opacity(0.55).gradient
                    )

                    if viewModel.dailyGoalML > 0 {
                        RuleMark(y: .value("목표", viewModel.dailyGoalML))
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
                            title: "가장 많이 마신 날",
                            value: "\(bestWeekday.label) · \(Int(bestWeekday.averageIntakeML.rounded()))ml"
                        )
                    }

                    if let leastWeekday = viewModel.leastWeekday {
                        BadgeView(
                            title: "가장 적게 마신 날",
                            value: "\(leastWeekday.label) · \(Int(leastWeekday.averageIntakeML.rounded()))ml"
                        )
                    }
                }

                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.secondary.opacity(0.7))
                        .frame(width: 8, height: 8)
                    Text("점선은 하루 목표량을 뜻합니다.")
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
                Text("아직 보여줄 인사이트가 없어요")
                    .font(.title3.weight(.bold))
                Text("최근 기록이 쌓이면 주간 평균, 달성률, streak, 요일 패턴을 한 번에 볼 수 있습니다. 오늘 목표는 \(viewModel.dailyGoalText)입니다.")
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

private struct MetricCard: View {
    let metric: HydrationInsightMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(metric.title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(metric.value)
                .font(.title3.weight(.bold))

            Text(metric.detail)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 118, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 1)
        }
    }
}

private struct AchievementProgressRow: View {
    let title: String
    let detail: String
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(detail)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progress, total: 1)
                .tint(Color.accent)
        }
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

private struct PillLabel: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.75))
            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.white.opacity(0.14), in: Capsule(style: .continuous))
    }
}
