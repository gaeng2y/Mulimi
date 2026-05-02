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
    let remainingConditionText: String?
    let todayActionText: String?
    let todayActionCompleted: Bool
    let achievedAt: Date?
    let achievedAtText: String?
    let isCompleted: Bool
}

struct ChallengeHistoryCardModel: Identifiable, Equatable {
    let id: String
    let kind: HydrationChallengeKind
    let badgeText: String
    let title: String
    let symbolName: String
    let description: String
    let achievedAt: Date
    let achievedAtText: String
}

struct PersonalizedChallengeCardModel: Identifiable, Equatable {
    let id: PersonalizedHydrationChallengeKind
    let kind: PersonalizedHydrationChallengeKind
    let sourceText: String
    let tierText: String
    let title: String
    let description: String
    let reasonText: String
    let actionText: String
    let routineActionTitle: String
    let routineActionIntent: RoutineActionIntent
    let symbolName: String
}

@MainActor
@Observable
public final class ChallengeViewModel {
    private(set) var isLoading = false
    private(set) var isEmpty = false
    private(set) var recommendedChallenges: [PersonalizedChallengeCardModel] = []
    private(set) var inProgressChallenges: [ChallengeCardModel] = []
    private(set) var completedChallenges: [ChallengeHistoryCardModel] = []

    private let challengeUseCase: ChallengeUseCase
    private let personalizedChallengeUseCase: PersonalizedChallengeUseCase
    private let progressUseCase: HydrationProgressUseCase
    private let analyticsUseCase: AnalyticsUseCase
    private let calendar: Calendar
    private let currentDateProvider: @Sendable () -> Date

    public init(
        challengeUseCase: ChallengeUseCase,
        personalizedChallengeUseCase: PersonalizedChallengeUseCase,
        progressUseCase: HydrationProgressUseCase,
        analyticsUseCase: AnalyticsUseCase = NoOpAnalyticsUseCase(),
        calendar: Calendar = .autoupdatingCurrent,
        currentDateProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.challengeUseCase = challengeUseCase
        self.personalizedChallengeUseCase = personalizedChallengeUseCase
        self.progressUseCase = progressUseCase
        self.analyticsUseCase = analyticsUseCase
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
            recommendedChallenges = []
            inProgressChallenges = []
            completedChallenges = []
            return
        }

        async let recommended = personalizedChallengeUseCase.fetchPersonalizedChallenges(
            snapshot: snapshot,
            referenceDate: referenceDate,
            calendar: calendar
        )
        async let challenges = challengeUseCase.fetchChallenges(
            referenceDate: referenceDate,
            calendar: calendar
        )

        let recommendedCards = await recommended
        let fixedCards = await challenges
        let badgeHistories = await challengeUseCase.fetchBadgeHistories()

        recommendedChallenges = recommendedCards.map(makePersonalizedCardModel(from:))

        inProgressChallenges = fixedCards
            .filter { $0.isCompleted == false }
            .map { makeCardModel(from: $0, snapshot: snapshot) }
            .sorted(by: inProgressSort)
        completedChallenges = badgeHistories
            .map { makeHistoryCardModel(from: $0) }
            .sorted(by: completedSort)
    }

    func trackRoutineActionTapped(for challenge: PersonalizedChallengeCardModel) {
        analyticsUseCase.track(
            .challengeCTATapped(
                source: "challenge_recommendation",
                challengeKind: challenge.kind.rawValue,
                action: analyticsAction(for: challenge.routineActionIntent)
            )
        )
    }

    private func makePersonalizedCardModel(
        from challenge: PersonalizedHydrationChallenge
    ) -> PersonalizedChallengeCardModel {
        PersonalizedChallengeCardModel(
            id: challenge.kind,
            kind: challenge.kind,
            sourceText: sourceText(for: challenge.source),
            tierText: tierText(for: challenge.tier),
            title: personalizedTitle(for: challenge),
            description: personalizedDescription(for: challenge),
            reasonText: personalizedReasonText(for: challenge),
            actionText: personalizedActionText(for: challenge),
            routineActionTitle: personalizedRoutineActionTitle(for: challenge),
            routineActionIntent: personalizedRoutineActionIntent(for: challenge),
            symbolName: personalizedSymbolName(for: challenge.kind)
        )
    }

    private func makeCardModel(
        from challenge: HydrationChallenge,
        snapshot: HydrationProgressSnapshot
    ) -> ChallengeCardModel {
        ChallengeCardModel(
            id: challenge.kind,
            kind: challenge.kind,
            badgeText: L10n.tr("challengeInProgressBadge"),
            title: title(for: challenge.kind),
            symbolName: symbolName(for: challenge.kind),
            valueText: valueText(for: challenge),
            description: description(for: challenge),
            progress: challenge.progress,
            progressText: progressText(for: challenge),
            remainingConditionText: remainingConditionText(for: challenge),
            todayActionText: todayActionText(for: challenge, snapshot: snapshot),
            todayActionCompleted: todayActionCompleted(for: challenge, snapshot: snapshot),
            achievedAt: nil,
            achievedAtText: nil,
            isCompleted: false
        )
    }

    private func makeHistoryCardModel(
        from history: HydrationChallengeBadgeHistory
    ) -> ChallengeHistoryCardModel {
        ChallengeHistoryCardModel(
            id: history.id,
            kind: history.kind,
            badgeText: L10n.tr("challengeEarnedBadge"),
            title: title(for: history.kind),
            symbolName: symbolName(for: history.kind),
            description: completedDescription(for: history.kind),
            achievedAt: history.achievedAt,
            achievedAtText: achievedAtText(for: history.achievedAt)
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
            if challenge.primaryCurrentValue == 0 {
                return L10n.tr("challengeStreakStartDescription")
            }
            return L10n.tr("challengeRemainingDaysFormat", remainingDays)

        case .weeklyAchievement80:
            let achievedDays = challenge.secondaryCurrentValue ?? 0
            let elapsedDays = max(challenge.secondaryTargetValue ?? 1, 1)

            return L10n.tr("challengeWeeklyProgressDescriptionFormat", achievedDays, elapsedDays)

        case .goalAchievement30:
            let remainingCount = max(challenge.primaryTargetValue - challenge.primaryCurrentValue, 0)

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

    private func remainingConditionText(for challenge: HydrationChallenge) -> String {
        switch challenge.kind {
        case .streak7:
            let remainingDays = max(challenge.primaryTargetValue - challenge.primaryCurrentValue, 0)
            return L10n.tr("challengeRemainingConditionDaysFormat", remainingDays)

        case .weeklyAchievement80:
            let achievedDays = challenge.secondaryCurrentValue ?? 0
            let elapsedDays = max(challenge.secondaryTargetValue ?? 1, 1)
            let requiredDays = requiredWeeklyAchievedDays(for: elapsedDays)
            let remainingDays = max(requiredDays - achievedDays, 0)

            if remainingDays == 0 {
                return L10n.tr("challengeWeeklyRemainingConditionSatisfiedFormat", requiredDays, elapsedDays)
            }

            return L10n.tr(
                "challengeWeeklyRemainingConditionFormat",
                remainingDays,
                requiredDays,
                elapsedDays
            )

        case .goalAchievement30:
            let remainingCount = max(challenge.primaryTargetValue - challenge.primaryCurrentValue, 0)
            return L10n.tr("challengeGoalRemainingConditionFormat", remainingCount)
        }
    }

    private func todayActionText(
        for challenge: HydrationChallenge,
        snapshot: HydrationProgressSnapshot
    ) -> String {
        switch challenge.kind {
        case .streak7:
            if snapshot.hasAchievedTodayGoal {
                return L10n.tr("challengeTodayActionAlreadyDoneStreakFormat", challenge.primaryCurrentValue)
            }

            return L10n.tr(
                "challengeTodayActionStreakFormat",
                challenge.primaryCurrentValue + 1
            )

        case .weeklyAchievement80:
            let achievedDays = challenge.secondaryCurrentValue ?? 0
            let elapsedDays = max(challenge.secondaryTargetValue ?? 1, 1)

            if snapshot.hasAchievedTodayGoal {
                return L10n.tr(
                    "challengeTodayActionAlreadyDoneWeeklyFormat",
                    achievedDays,
                    elapsedDays
                )
            }

            let projectedAchievedDays = min(achievedDays + 1, elapsedDays)
            return L10n.tr(
                "challengeTodayActionWeeklyFormat",
                projectedAchievedDays,
                elapsedDays
            )

        case .goalAchievement30:
            if snapshot.hasAchievedTodayGoal {
                return L10n.tr(
                    "challengeTodayActionAlreadyDoneGoalFormat",
                    challenge.primaryCurrentValue,
                    challenge.primaryTargetValue
                )
            }

            return L10n.tr(
                "challengeTodayActionGoalFormat",
                challenge.primaryCurrentValue + 1,
                challenge.primaryTargetValue
            )
        }
    }

    private func todayActionCompleted(
        for challenge: HydrationChallenge,
        snapshot: HydrationProgressSnapshot
    ) -> Bool {
        switch challenge.kind {
        case .streak7, .weeklyAchievement80, .goalAchievement30:
            return snapshot.hasAchievedTodayGoal
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

    private func completedDescription(for kind: HydrationChallengeKind) -> String {
        switch kind {
        case .streak7:
            return L10n.tr("challengeCompletedDescription")
        case .weeklyAchievement80:
            return L10n.tr("challengeWeeklyCompletedDescription")
        case .goalAchievement30:
            return L10n.tr("challengeGoalCompletedDescription")
        }
    }

    private func sourceText(for source: HydrationChallengeRecommendationSource) -> String {
        switch source {
        case .routine:
            return L10n.tr("challengeRecommendationSourceRoutine")
        case .recentRecords:
            return L10n.tr("challengeRecommendationSourceRecentRecords")
        }
    }

    private func tierText(for tier: HydrationChallengeTier) -> String {
        switch tier {
        case .beginner:
            return L10n.tr("challengeRecommendationTierBeginner")
        case .steady:
            return L10n.tr("challengeRecommendationTierSteady")
        case .stretch:
            return L10n.tr("challengeRecommendationTierStretch")
        }
    }

    private func personalizedTitle(for challenge: PersonalizedHydrationChallenge) -> String {
        switch challenge.kind {
        case .routineAnchor:
            return L10n.tr(
                "challengePersonalizedRoutineTitleFormat",
                challenge.anchorRoutine?.title ?? L10n.tr("challengeRecommendationSourceRoutine")
            )
        case .morningKickstart:
            return L10n.tr("challengePersonalizedMorningTitle")
        case .dailyGoalBooster:
            return L10n.tr("challengePersonalizedBoosterTitle")
        case .consistencyDefender:
            return L10n.tr("challengePersonalizedConsistencyTitle")
        }
    }

    private func personalizedDescription(for challenge: PersonalizedHydrationChallenge) -> String {
        switch challenge.kind {
        case .routineAnchor:
            return L10n.tr(
                "challengePersonalizedRoutineDescriptionFormat",
                challenge.anchorRoutine?.weekdayText ?? "",
                challenge.anchorRoutine?.timeText ?? ""
            )
        case .morningKickstart:
            return L10n.tr("challengePersonalizedMorningDescription")
        case .dailyGoalBooster:
            return L10n.tr("challengePersonalizedBoosterDescription")
        case .consistencyDefender:
            return L10n.tr("challengePersonalizedConsistencyDescription")
        }
    }

    private func personalizedReasonText(for challenge: PersonalizedHydrationChallenge) -> String {
        switch challenge.kind {
        case .routineAnchor:
            return L10n.tr("challengePersonalizedRoutineReason")
        case .morningKickstart:
            return L10n.tr(
                "challengePersonalizedMorningReasonFormat",
                challenge.primaryCurrentValue,
                challenge.secondaryCurrentValue ?? 14
            )
        case .dailyGoalBooster:
            return L10n.tr(
                "challengePersonalizedBoosterReasonFormat",
                challenge.currentAverageML ?? challenge.primaryCurrentValue,
                challenge.dailyGoalML ?? 0
            )
        case .consistencyDefender:
            return L10n.tr(
                "challengePersonalizedConsistencyReasonFormat",
                challenge.primaryCurrentValue,
                challenge.secondaryCurrentValue ?? 7
            )
        }
    }

    private func personalizedActionText(for challenge: PersonalizedHydrationChallenge) -> String {
        switch challenge.kind {
        case .routineAnchor:
            return L10n.tr(
                "challengePersonalizedRoutineActionFormat",
                challenge.primaryTargetValue
            )
        case .morningKickstart:
            return L10n.tr("challengePersonalizedMorningAction")
        case .dailyGoalBooster:
            return L10n.tr(
                "challengePersonalizedBoosterActionFormat",
                challenge.recommendedTargetML ?? challenge.primaryTargetValue
            )
        case .consistencyDefender:
            return L10n.tr(
                "challengePersonalizedConsistencyActionFormat",
                challenge.primaryTargetValue
            )
        }
    }

    private func personalizedRoutineActionTitle(for challenge: PersonalizedHydrationChallenge) -> String {
        switch challenge.kind {
        case .routineAnchor:
            return L10n.tr("challengePersonalizedRoutineActionCTATitle")
        case .morningKickstart:
            return L10n.tr("challengePersonalizedMorningActionCTATitle")
        case .dailyGoalBooster:
            return L10n.tr("challengePersonalizedBoosterActionCTATitle")
        case .consistencyDefender:
            return L10n.tr("challengePersonalizedConsistencyActionCTATitle")
        }
    }

    private func personalizedRoutineActionIntent(
        for challenge: PersonalizedHydrationChallenge
    ) -> RoutineActionIntent {
        switch challenge.kind {
        case .routineAnchor:
            guard let routineID = challenge.anchorRoutine?.id else {
                return .create
            }

            return .edit(routineID)
        case .morningKickstart, .dailyGoalBooster, .consistencyDefender:
            return .create
        }
    }

    private func analyticsAction(for actionIntent: RoutineActionIntent) -> String {
        switch actionIntent {
        case .create:
            return "create_routine"
        case .edit:
            return "edit_routine"
        }
    }

    private func personalizedSymbolName(for kind: PersonalizedHydrationChallengeKind) -> String {
        switch kind {
        case .routineAnchor:
            return "calendar.badge.clock"
        case .morningKickstart:
            return "sun.max.fill"
        case .dailyGoalBooster:
            return "drop.circle.fill"
        case .consistencyDefender:
            return "shield.checkered"
        }
    }

    private func requiredWeeklyAchievedDays(for elapsedDays: Int) -> Int {
        Int(ceil(Double(max(elapsedDays, 1)) * 0.8))
    }

    private func inProgressSort(lhs: ChallengeCardModel, rhs: ChallengeCardModel) -> Bool {
        if lhs.progress != rhs.progress {
            return lhs.progress > rhs.progress
        }

        return lhs.kind.rawValue < rhs.kind.rawValue
    }

    private func completedSort(lhs: ChallengeHistoryCardModel, rhs: ChallengeHistoryCardModel) -> Bool {
        if lhs.achievedAt != rhs.achievedAt {
            return lhs.achievedAt > rhs.achievedAt
        }

        return lhs.id < rhs.id
    }
}
