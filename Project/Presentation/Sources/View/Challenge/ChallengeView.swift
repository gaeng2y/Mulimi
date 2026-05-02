import DesignSystem
import Localization
import SwiftUI

public struct ChallengeView: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @State private var viewModel: ChallengeViewModel
    @State private var selectedCategory: ChallengeCategory = .recommended
    private let onRoutineAction: (RoutineActionIntent) -> Void

    public init(
        viewModel: ChallengeViewModel,
        onRoutineAction: @escaping (RoutineActionIntent) -> Void = { _ in }
    ) {
        self._viewModel = State(wrappedValue: viewModel)
        self.onRoutineAction = onRoutineAction
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

            Circle()
                .fill(Color.orange.opacity(0.14))
                .frame(width: 190, height: 190)
                .blur(radius: 46)
                .offset(x: -140, y: -240)

            Circle()
                .fill(Color.mint.opacity(0.12))
                .frame(width: 230, height: 230)
                .blur(radius: 54)
                .offset(x: 150, y: 220)

            Group {
                if viewModel.isLoading {
                    ProgressView(L10n.tr("challengeLoadingTitle"))
                } else {
                    challengeContent
                }
            }
            .padding(.horizontal, 20)
        }
        .task {
            await viewModel.loadChallenges()
        }
        .refreshable {
            await viewModel.loadChallenges()
        }
    }

    private var challengeContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
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
            segments: ChallengeCategory.allCases.map {
                LiquidGlassSegment(
                    value: $0,
                    title: $0.title,
                    systemImage: $0.systemImage
                )
            }
        )
        .accessibilityLabel(L10n.tr("challengeCategoryPickerAccessibilityLabel"))
    }

    @ViewBuilder
    private var selectedCategoryContent: some View {
        switch selectedCategory {
        case .recommended:
            recommendedCategorySection
        case .inProgress:
            inProgressCategorySection
        case .completed:
            completedCategorySection
        }
    }

    private var recommendedCategorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ChallengeSectionHeader(
                title: L10n.tr("challengeRecommendedSectionTitle"),
                subtitle: L10n.tr("challengeRecommendedSectionDescription")
            )

            if viewModel.recommendedChallenges.isEmpty {
                categoryEmptyCard(
                    title: L10n.tr("challengeRecommendedEmptyTitle"),
                    description: L10n.tr("challengeRecommendedEmptyDescription"),
                    systemImage: "sparkles"
                )
            } else {
                VStack(spacing: 14) {
                    ForEach(viewModel.recommendedChallenges) { challenge in
                        PersonalizedChallengeCard(
                            challenge: challenge,
                            onRoutineAction: { actionIntent in
                                viewModel.trackRoutineActionTapped(for: challenge)
                                onRoutineAction(actionIntent)
                            }
                        )
                    }
                }
            }
        }
    }

    private var inProgressCategorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ChallengeSectionHeader(
                title: L10n.tr("challengeInProgressSectionTitle"),
                subtitle: L10n.tr("challengeInProgressSectionDescription")
            )

            if viewModel.inProgressChallenges.isEmpty {
                categoryEmptyCard(
                    title: L10n.tr("challengeInProgressEmptyTitle"),
                    description: L10n.tr("challengeInProgressEmptyDescription"),
                    systemImage: "figure.walk"
                )
            } else {
                VStack(spacing: 14) {
                    ForEach(viewModel.inProgressChallenges) { challenge in
                        ChallengeCard(challenge: challenge)
                    }
                }
            }
        }
    }

    private var completedCategorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            ChallengeSectionHeader(
                title: L10n.tr("challengeCompletedSectionTitle"),
                subtitle: L10n.tr("challengeCompletedSectionDescription")
            )

            if viewModel.completedChallenges.isEmpty {
                categoryEmptyCard(
                    title: L10n.tr("challengeCompletedEmptyTitle"),
                    description: L10n.tr("challengeCompletedEmptyDescription"),
                    systemImage: "checkmark.seal"
                )
            } else {
                VStack(spacing: 14) {
                    ForEach(viewModel.completedChallenges) { challenge in
                        ChallengeHistoryCard(challenge: challenge)
                    }
                }
            }
        }
    }

    private func categoryEmptyCard(
        title: String,
        description: String,
        systemImage: String
    ) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.orange)
                .frame(width: 42, height: 42)
                .background(
                    Circle()
                        .fill(Color.orange.opacity(0.13))
                )

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            emptyCardBackground,
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
        .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(reduceTransparency ? 0.08 : 0.22), lineWidth: 1)
        }
    }

    private var emptyCardBackground: AnyShapeStyle {
        if reduceTransparency {
            return AnyShapeStyle(Color(uiColor: .secondarySystemBackground))
        }

        return AnyShapeStyle(.ultraThinMaterial)
    }
}

private enum ChallengeCategory: CaseIterable, Hashable, Identifiable {
    case recommended
    case inProgress
    case completed

    var id: Self { self }

    var title: String {
        switch self {
        case .recommended:
            return L10n.tr("challengeCategoryRecommendedTitle")
        case .inProgress:
            return L10n.tr("challengeCategoryInProgressTitle")
        case .completed:
            return L10n.tr("challengeCategoryCompletedTitle")
        }
    }

    var systemImage: String {
        switch self {
        case .recommended:
            return "sparkles"
        case .inProgress:
            return "figure.walk"
        case .completed:
            return "checkmark.seal"
        }
    }
}

private struct PersonalizedChallengeCard: View {
    let challenge: PersonalizedChallengeCardModel
    let onRoutineAction: (RoutineActionIntent) -> Void

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

            Button {
                onRoutineAction(challenge.routineActionIntent)
            } label: {
                Label(challenge.routineActionTitle, systemImage: "arrow.right.circle.fill")
                    .font(.subheadline.weight(.semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(accentColor)
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
