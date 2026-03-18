import DomainLayerInterface
import Foundation
import Localization
import Observation

struct ChallengeCardModel: Identifiable, Equatable {
    let id: HydrationChallengeKind
    let kind: HydrationChallengeKind
    let badgeText: String
    let title: String
    let symbolName: String
    let valueText: String
    let description: String
    let progress: Double
    let progressText: String
    let achievedAt: Date?
    let achievedAtText: String?
    let isCompleted: Bool
}

@MainActor
@Observable
public final class ChallengeViewModel {
    private(set) var isLoading = false
    private(set) var isEmpty = false
    private(set) var inProgressChallenges: [ChallengeCardModel] = []
    private(set) var completedChallenges: [ChallengeCardModel] = []

    private let challengeUseCase: ChallengeUseCase
    private let progressUseCase: HydrationProgressUseCase
    private let calendar: Calendar
    private let currentDateProvider: @Sendable () -> Date

    public init(
        challengeUseCase: ChallengeUseCase,
        progressUseCase: HydrationProgressUseCase,
        calendar: Calendar = .autoupdatingCurrent,
        currentDateProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.challengeUseCase = challengeUseCase
        self.progressUseCase = progressUseCase
        self.calendar = calendar
        self.currentDateProvider = currentDateProvider
    }

    public func loadChallenges() async {
        isLoading = true
        defer { isLoading = false }

        let referenceDate = currentDateProvider()
        let snapshot = await progressUseCase.progressSnapshot(
            referenceDate: referenceDate,
            calendar: calendar
        )

        isEmpty = snapshot.isEmpty
        guard snapshot.isEmpty == false else {
            inProgressChallenges = []
            completedChallenges = []
            return
        }

        let challenges = await challengeUseCase.fetchChallenges(
            referenceDate: referenceDate,
            calendar: calendar
        )

        let cards = challenges.map(makeCardModel)

        inProgressChallenges = cards
            .filter { $0.isCompleted == false }
            .sorted(by: inProgressSort)
        completedChallenges = cards
            .filter(\.isCompleted)
            .sorted(by: completedSort)
    }

    private func makeCardModel(from challenge: HydrationChallenge) -> ChallengeCardModel {
        ChallengeCardModel(
            id: challenge.kind,
            kind: challenge.kind,
            badgeText: challenge.isCompleted
                ? L10n.tr("challengeEarnedBadge")
                : L10n.tr("challengeInProgressBadge"),
            title: title(for: challenge.kind),
            symbolName: symbolName(for: challenge.kind),
            valueText: valueText(for: challenge),
            description: description(for: challenge),
            progress: challenge.progress,
            progressText: progressText(for: challenge),
            achievedAt: challenge.achievedAt,
            achievedAtText: challenge.achievedAt.map(achievedAtText),
            isCompleted: challenge.isCompleted
        )
    }

    private func title(for kind: HydrationChallengeKind) -> String {
        switch kind {
        case .streak7:
            return L10n.tr("challengeStreakCardTitle")
        case .weeklyAchievement80:
            return L10n.tr("challengeWeeklyCardTitle")
        case .goalAchievement30:
            return L10n.tr("challengeGoalCardTitle")
        }
    }

    private func symbolName(for kind: HydrationChallengeKind) -> String {
        switch kind {
        case .streak7:
            return "flame.fill"
        case .weeklyAchievement80:
            return "calendar.badge.checkmark"
        case .goalAchievement30:
            return "target"
        }
    }

    private func valueText(for challenge: HydrationChallenge) -> String {
        switch challenge.kind {
        case .streak7:
            return challenge.primaryCurrentValue > 0
                ? L10n.tr("challengeCurrentStreakValueFormat", challenge.primaryCurrentValue)
                : L10n.tr("challengeCurrentStreakEmptyValue")
        case .weeklyAchievement80:
            return L10n.tr("commonPercentFormat", challenge.primaryCurrentValue)
        case .goalAchievement30:
            return L10n.tr("challengeGoalValueFormat", challenge.primaryCurrentValue)
        }
    }

    private func description(for challenge: HydrationChallenge) -> String {
        switch challenge.kind {
        case .streak7:
            let remainingDays = max(challenge.primaryTargetValue - challenge.primaryCurrentValue, 0)
            if challenge.isCompleted {
                return L10n.tr("challengeCompletedDescription")
            }
            if challenge.primaryCurrentValue == 0 {
                return L10n.tr("challengeStreakStartDescription")
            }
            return L10n.tr("challengeRemainingDaysFormat", remainingDays)

        case .weeklyAchievement80:
            let achievedDays = challenge.secondaryCurrentValue ?? 0
            let elapsedDays = max(challenge.secondaryTargetValue ?? 1, 1)

            if challenge.isCompleted {
                return L10n.tr("challengeWeeklyCompletedDescription")
            }
            return L10n.tr("challengeWeeklyProgressDescriptionFormat", achievedDays, elapsedDays)

        case .goalAchievement30:
            let remainingCount = max(challenge.primaryTargetValue - challenge.primaryCurrentValue, 0)

            if challenge.isCompleted {
                return L10n.tr("challengeGoalCompletedDescription")
            }
            if challenge.primaryCurrentValue == 0 {
                return L10n.tr("challengeGoalStartDescription")
            }
            return L10n.tr("challengeGoalRemainingCountFormat", remainingCount)
        }
    }

    private func progressText(for challenge: HydrationChallenge) -> String {
        switch challenge.kind {
        case .streak7:
            return L10n.tr(
                "challengeProgressDaysFormat",
                challenge.primaryCurrentValue,
                challenge.primaryTargetValue
            )
        case .weeklyAchievement80:
            return L10n.tr(
                "challengeAchievementDaysFormat",
                challenge.secondaryCurrentValue ?? 0,
                max(challenge.secondaryTargetValue ?? 1, 1)
            )
        case .goalAchievement30:
            return L10n.tr(
                "challengeProgressCountFormat",
                challenge.primaryCurrentValue,
                challenge.primaryTargetValue
            )
        }
    }

    private func achievedAtText(for date: Date) -> String {
        let formattedDate = date.formatted(
            .dateTime
                .locale(Locale(identifier: "ko_KR"))
                .month(.wide)
                .day()
        )
        return L10n.tr("challengeAchievedAtFormat", formattedDate)
    }

    private func inProgressSort(lhs: ChallengeCardModel, rhs: ChallengeCardModel) -> Bool {
        if lhs.progress != rhs.progress {
            return lhs.progress > rhs.progress
        }

        return lhs.kind.rawValue < rhs.kind.rawValue
    }

    private func completedSort(lhs: ChallengeCardModel, rhs: ChallengeCardModel) -> Bool {
        switch (lhs.achievedAt, rhs.achievedAt) {
        case let (left?, right?) where left != right:
            return left > right
        default:
            return lhs.kind.rawValue < rhs.kind.rawValue
        }
    }
}
