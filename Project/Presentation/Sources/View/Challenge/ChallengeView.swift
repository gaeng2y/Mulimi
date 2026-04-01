import DesignSystem
import Localization
import SwiftUI

public struct ChallengeView: View {
    @State private var viewModel: ChallengeViewModel

    public init(viewModel: ChallengeViewModel) {
        self._viewModel = State(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.background,
                    Color.orange.opacity(0.05),
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

    private var challengeContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if viewModel.recommendedChallenges.isEmpty == false {
                    ChallengeSectionHeader(
                        title: L10n.tr("challengeRecommendedSectionTitle"),
                        subtitle: L10n.tr("challengeRecommendedSectionDescription")
                    )

                    VStack(spacing: 14) {
                        ForEach(viewModel.recommendedChallenges) { challenge in
                            PersonalizedChallengeCard(challenge: challenge)
                        }
                    }
                }

                if viewModel.inProgressChallenges.isEmpty == false {
                    ChallengeSectionHeader(
                        title: L10n.tr("challengeInProgressSectionTitle"),
                        subtitle: L10n.tr("challengeInProgressSectionDescription")
                    )

                    VStack(spacing: 14) {
                        ForEach(viewModel.inProgressChallenges) { challenge in
                            ChallengeCard(challenge: challenge)
                        }
                    }
                }

                if viewModel.completedChallenges.isEmpty == false {
                    ChallengeSectionHeader(
                        title: L10n.tr("challengeCompletedSectionTitle"),
                        subtitle: L10n.tr("challengeCompletedSectionDescription")
                    )

                    VStack(spacing: 14) {
                        ForEach(viewModel.completedChallenges) { challenge in
                            ChallengeHistoryCard(challenge: challenge)
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
}

private struct PersonalizedChallengeCard: View {
    let challenge: PersonalizedChallengeCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        ChallengeBadge(
                            title: L10n.tr("challengeRecommendedBadge"),
                            color: accentColor
                        )

                        ChallengeBadge(
                            title: challenge.sourceText,
                            color: .secondary
                        )

                        ChallengeBadge(
                            title: challenge.tierText,
                            color: accentColor.opacity(0.85)
                        )
                    }

                    Text(challenge.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 12)

                Image(systemName: challenge.symbolName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(accentColor)
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(accentColor.opacity(0.12))
                    )
            }

            VStack(spacing: 10) {
                ChallengeInfoRow(
                    title: L10n.tr("challengeRecommendationReasonTitle"),
                    message: challenge.reasonText,
                    systemImage: "lightbulb.fill",
                    tintColor: accentColor
                )

                ChallengeInfoRow(
                    title: L10n.tr("challengeRecommendationActionTitle"),
                    message: challenge.actionText,
                    systemImage: "figure.walk",
                    tintColor: accentColor
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(uiColor: .secondarySystemBackground).opacity(0.98),
                            accentColor.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(accentColor.opacity(0.1), lineWidth: 1)
                )
        )
    }

    private var accentColor: Color {
        switch challenge.kind {
        case .routineAnchor:
            return .mint
        case .morningKickstart:
            return .orange
        case .dailyGoalBooster:
            return .blue
        case .consistencyDefender:
            return .green
        }
    }
}

private struct ChallengeSectionHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

private struct ChallengeCard: View {
    let challenge: ChallengeCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    ChallengeBadge(
                        title: challenge.badgeText,
                        color: accentColor
                    )

                    Text(challenge.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 12)

                Image(systemName: challenge.symbolName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(accentColor)
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(accentColor.opacity(challenge.isCompleted ? 0.18 : 0.12))
                    )
            }

            HStack(alignment: .lastTextBaseline, spacing: 10) {
                Text(challenge.valueText)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(challenge.progressText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: challenge.progress, total: 1)
                .tint(accentColor)

            if challenge.isCompleted == false {
                VStack(spacing: 10) {
                    if let remainingConditionText = challenge.remainingConditionText {
                        ChallengeInfoRow(
                            title: L10n.tr("challengeRemainingConditionTitle"),
                            message: remainingConditionText,
                            systemImage: "flag.2.crossed"
                        )
                    }

                    if let todayActionText = challenge.todayActionText {
                        ChallengeInfoRow(
                            title: L10n.tr("challengeTodayActionTitle"),
                            message: todayActionText,
                            systemImage: challenge.todayActionCompleted ? "checkmark.circle.fill" : "figure.walk",
                            tintColor: challenge.todayActionCompleted ? .green : accentColor
                        )
                    }
                }
            }

            if let achievedAtText = challenge.achievedAtText {
                Label(achievedAtText, systemImage: "checkmark.seal.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(accentColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
        .overlay(alignment: .topTrailing) {
            if challenge.isCompleted {
                Image(systemName: "sparkles")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(accentColor.opacity(0.9))
                    .padding(16)
            }
        }
    }

    private var accentColor: Color {
        switch challenge.kind {
        case .streak7:
            return .orange
        case .weeklyAchievement80:
            return .mint
        case .goalAchievement30:
            return .blue
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(
                LinearGradient(
                    colors: challenge.isCompleted
                        ? [
                            accentColor.opacity(0.22),
                            Color(uiColor: .secondarySystemBackground).opacity(0.96)
                        ]
                        : [
                            Color(uiColor: .secondarySystemBackground).opacity(0.98),
                            accentColor.opacity(0.06)
                        ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(accentColor.opacity(challenge.isCompleted ? 0.22 : 0.08), lineWidth: 1)
            )
    }
}

private struct ChallengeHistoryCard: View {
    let challenge: ChallengeHistoryCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 10) {
                    ChallengeBadge(
                        title: challenge.badgeText,
                        color: accentColor
                    )

                    Text(challenge.title)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text(challenge.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 12)

                Image(systemName: challenge.symbolName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(accentColor)
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(accentColor.opacity(0.18))
                    )
            }

            Label(challenge.achievedAtText, systemImage: "checkmark.seal.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(accentColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(cardBackground)
        .overlay(alignment: .topTrailing) {
            Image(systemName: "sparkles")
                .font(.headline.weight(.bold))
                .foregroundStyle(accentColor.opacity(0.9))
                .padding(16)
        }
    }

    private var accentColor: Color {
        switch challenge.kind {
        case .streak7:
            return .orange
        case .weeklyAchievement80:
            return .mint
        case .goalAchievement30:
            return .blue
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        accentColor.opacity(0.22),
                        Color(uiColor: .secondarySystemBackground).opacity(0.96)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(accentColor.opacity(0.22), lineWidth: 1)
            )
    }
}

private struct ChallengeBadge: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(color.opacity(0.12))
            )
    }
}

private struct ChallengeInfoRow: View {
    let title: String
    let message: String
    let systemImage: String
    var tintColor: Color = .secondary

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
                .foregroundStyle(tintColor)
                .frame(width: 18, height: 18)
                .padding(.top, 1)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
        )
    }
}
