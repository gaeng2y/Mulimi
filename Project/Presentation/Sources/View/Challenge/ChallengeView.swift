import DesignSystem
import Localization
import SwiftUI

public struct ChallengeView: View {
    @State private var viewModel: ChallengeViewModel

    public init(viewModel: ChallengeViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.background,
                        Color.orange.opacity(0.06),
                        Color.background
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                Group {
                    if viewModel.isLoading {
                        ProgressView(L10n.tr("challengeLoadingTitle"))
                    } else if viewModel.isEmpty {
                        emptyState
                    } else {
                        challengeContent
                    }
                }
                .padding(.horizontal, 20)
            }
            .navigationTitle(L10n.tr("challengeTitle"))
            .task {
                await viewModel.loadChallenges()
            }
            .refreshable {
                await viewModel.loadChallenges()
            }
        }
    }

    private var challengeContent: some View {
        let summary = viewModel.streakSummary

        return ScrollView {
            VStack(spacing: 18) {
                ChallengeCard {
                    VStack(alignment: .leading, spacing: 18) {
                        Text(summary.badgeText)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(challengeBadgeColor)

                        Text(summary.title)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text(summary.valueText)
                                .font(.system(size: 36, weight: .bold, design: .rounded))
                                .foregroundStyle(.primary)

                            Text(L10n.tr("challengeCurrentStreakLabel"))
                                .font(.headline)
                                .foregroundStyle(.secondary)
                        }

                        Text(summary.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                        ProgressView(value: summary.progress, total: 1)
                            .tint(challengeBadgeColor)

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible(), spacing: 10),
                                GridItem(.flexible(), spacing: 10)
                            ],
                            spacing: 10
                        ) {
                            ForEach(summary.metrics) { metric in
                                ChallengeMetricTile(metric: metric)
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 20)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: "trophy")
                .font(.system(size: 44))
                .foregroundStyle(Color.orange)

            VStack(spacing: 8) {
                Text(L10n.tr("challengeEmptyTitle"))
                    .font(.title3.weight(.bold))

                Text(L10n.tr("challengeEmptyDescription"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var challengeBadgeColor: Color {
        viewModel.currentStreak >= 7 ? .orange : .accentColor
    }
}

private struct ChallengeCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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

private struct ChallengeMetricTile: View {
    let metric: ChallengeMetric

    var body: some View {
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
