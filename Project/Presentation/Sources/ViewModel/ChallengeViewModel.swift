import DomainLayerInterface
import Foundation
import Localization
import Observation

struct ChallengeMetric: Identifiable, Equatable {
    let id: String
    let title: String
    let value: String
    let detail: String
}

struct ChallengeStreakSummary: Equatable {
    let badgeText: String
    let title: String
    let valueText: String
    let description: String
    let progress: Double
    let metrics: [ChallengeMetric]
}

@MainActor
@Observable
public final class ChallengeViewModel {
    public private(set) var isLoading = false
    public private(set) var isEmpty = false
    public private(set) var dailyGoalML: Double = 0
    public private(set) var weeklyAchievementRate: Double = 0
    public private(set) var monthlyAchievementRate: Double = 0
    public private(set) var weeklyAchievedDays: Int = 0
    public private(set) var monthlyAchievedDays: Int = 0
    public private(set) var weeklyElapsedDays: Int = 0
    public private(set) var monthlyElapsedDays: Int = 0
    public private(set) var currentStreak: Int = 0

    private let progressUseCase: HydrationProgressUseCase
    private let calendar: Calendar
    private let currentDateProvider: @Sendable () -> Date
    private let streakGoal = 7

    public init(
        progressUseCase: HydrationProgressUseCase,
        calendar: Calendar = .autoupdatingCurrent,
        currentDateProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.progressUseCase = progressUseCase
        self.calendar = calendar
        self.currentDateProvider = currentDateProvider
    }

    var streakSummary: ChallengeStreakSummary {
        let isCompleted = currentStreak >= streakGoal
        let remainingDays = max(streakGoal - currentStreak, 0)

        return ChallengeStreakSummary(
            badgeText: isCompleted ? L10n.tr("challengeCompletedBadge") : L10n.tr("challengeInProgressBadge"),
            title: L10n.tr("challengeStreakCardTitle"),
            valueText: currentStreak > 0
                ? L10n.tr("challengeCurrentStreakValueFormat", currentStreak)
                : L10n.tr("challengeCurrentStreakEmptyValue"),
            description: challengeDescription(isCompleted: isCompleted, remainingDays: remainingDays),
            progress: min(Double(currentStreak) / Double(streakGoal), 1),
            metrics: [
                ChallengeMetric(
                    id: "weekly",
                    title: L10n.tr("challengeMetricWeeklyTitle"),
                    value: percentText(weeklyAchievementRate),
                    detail: L10n.tr(
                        "challengeAchievementDaysFormat",
                        weeklyAchievedDays,
                        max(weeklyElapsedDays, 1)
                    )
                ),
                ChallengeMetric(
                    id: "monthly",
                    title: L10n.tr("challengeMetricMonthlyTitle"),
                    value: percentText(monthlyAchievementRate),
                    detail: L10n.tr(
                        "challengeAchievementDaysFormat",
                        monthlyAchievedDays,
                        max(monthlyElapsedDays, 1)
                    )
                )
            ]
        )
    }

    public func loadChallenges() async {
        isLoading = true
        defer { isLoading = false }

        let snapshot = await progressUseCase.progressSnapshot(
            referenceDate: currentDateProvider(),
            calendar: calendar
        )

        dailyGoalML = snapshot.dailyGoalML
        weeklyAchievementRate = snapshot.weeklyAchievementRate
        monthlyAchievementRate = snapshot.monthlyAchievementRate
        weeklyAchievedDays = snapshot.weeklyAchievedDays
        monthlyAchievedDays = snapshot.monthlyAchievedDays
        weeklyElapsedDays = snapshot.weeklyElapsedDays
        monthlyElapsedDays = snapshot.monthlyElapsedDays
        currentStreak = snapshot.currentStreak
        isEmpty = snapshot.isEmpty
    }

    private func challengeDescription(isCompleted: Bool, remainingDays: Int) -> String {
        if currentStreak == 0 {
            return L10n.tr("challengeStreakStartDescription")
        }

        if isCompleted {
            return L10n.tr("challengeCompletedDescription")
        }

        return L10n.tr("challengeRemainingDaysFormat", remainingDays)
    }

    private func percentText(_ ratio: Double) -> String {
        L10n.tr("commonPercentFormat", Int((ratio * 100).rounded()))
    }
}
