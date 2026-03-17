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
    public private(set) var dailyGoalML: Double
    public private(set) var weeklyAchievementRate: Double = 0
    public private(set) var monthlyAchievementRate: Double = 0
    public private(set) var weeklyAchievedDays: Int = 0
    public private(set) var monthlyAchievedDays: Int = 0
    public private(set) var weeklyElapsedDays: Int = 0
    public private(set) var monthlyElapsedDays: Int = 0
    public private(set) var currentStreak: Int = 0

    private let waterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let calendar: Calendar
    private let currentDateProvider: @Sendable () -> Date
    private let streakGoal = 7

    public init(
        waterUseCase: DrinkWaterUseCase,
        userPreferencesUseCase: UserPreferencesUseCase,
        calendar: Calendar = .autoupdatingCurrent,
        currentDateProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.waterUseCase = waterUseCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.calendar = calendar
        self.currentDateProvider = currentDateProvider
        self.dailyGoalML = userPreferencesUseCase.getDailyWaterLimit()
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

        let referenceDate = currentDateProvider()
        dailyGoalML = userPreferencesUseCase.getDailyWaterLimit()

        guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: referenceDate),
              let monthInterval = calendar.dateInterval(of: .month, for: referenceDate) else {
            resetState()
            return
        }

        let elapsedWeekInterval = elapsedInterval(from: weekInterval, upTo: referenceDate)
        let elapsedMonthInterval = elapsedInterval(from: monthInterval, upTo: referenceDate)

        async let weeklyEvents = waterUseCase.hydrationEvents(in: elapsedWeekInterval)
        async let monthlyEvents = waterUseCase.hydrationEvents(in: elapsedMonthInterval)

        let (resolvedWeeklyEvents, resolvedMonthlyEvents) = await (weeklyEvents, monthlyEvents)
        let weeklyTotals = dailyTotals(from: resolvedWeeklyEvents)
        let monthlyTotals = dailyTotals(from: resolvedMonthlyEvents)

        weeklyElapsedDays = elapsedDayCount(in: elapsedWeekInterval)
        monthlyElapsedDays = elapsedDayCount(in: elapsedMonthInterval)
        weeklyAchievedDays = achievedDayCount(in: weeklyTotals)
        monthlyAchievedDays = achievedDayCount(in: monthlyTotals)
        weeklyAchievementRate = achievementRate(achievedDays: weeklyAchievedDays, dayCount: weeklyElapsedDays)
        monthlyAchievementRate = achievementRate(achievedDays: monthlyAchievedDays, dayCount: monthlyElapsedDays)
        currentStreak = await calculateCurrentStreak(referenceDate: referenceDate)
        isEmpty = resolvedWeeklyEvents.isEmpty && resolvedMonthlyEvents.isEmpty
    }

    private func resetState() {
        isEmpty = true
        weeklyAchievementRate = 0
        monthlyAchievementRate = 0
        weeklyAchievedDays = 0
        monthlyAchievedDays = 0
        weeklyElapsedDays = 0
        monthlyElapsedDays = 0
        currentStreak = 0
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

    private func elapsedInterval(from interval: DateInterval, upTo referenceDate: Date) -> DateInterval {
        let intervalEnd = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: referenceDate)
        ) ?? interval.end

        return DateInterval(
            start: interval.start,
            end: min(interval.end, intervalEnd)
        )
    }

    private func elapsedDayCount(in interval: DateInterval) -> Int {
        max(
            calendar.dateComponents([.day], from: interval.start, to: interval.end).day ?? 0,
            1
        )
    }

    private func dailyTotals(from events: [HydrationEvent]) -> [Date: Double] {
        events.reduce(into: [:]) { partialResult, event in
            let day = calendar.startOfDay(for: event.consumedAt)
            partialResult[day, default: 0] += Double(event.volumeML)
        }
    }

    private func achievedDayCount(in totals: [Date: Double]) -> Int {
        guard dailyGoalML > 0 else {
            return 0
        }

        return totals.values.filter { $0 >= dailyGoalML }.count
    }

    private func achievementRate(achievedDays: Int, dayCount: Int) -> Double {
        guard dayCount > 0 else {
            return 0
        }

        return Double(achievedDays) / Double(dayCount)
    }

    private func calculateCurrentStreak(referenceDate: Date) async -> Int {
        guard dailyGoalML > 0 else {
            return 0
        }

        var date = calendar.startOfDay(for: referenceDate)
        if await totalIntake(on: date) < dailyGoalML {
            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: date) else {
                return 0
            }
            date = previousDate
        }

        var streak = 0

        while await totalIntake(on: date) >= dailyGoalML {
            streak += 1

            guard let previousDate = calendar.date(byAdding: .day, value: -1, to: date) else {
                break
            }
            date = previousDate
        }

        return streak
    }

    private func totalIntake(on date: Date) async -> Double {
        (await waterUseCase.hydrationEvents(on: date)).reduce(0) { partialResult, event in
            partialResult + Double(event.volumeML)
        }
    }

    private func percentText(_ ratio: Double) -> String {
        L10n.tr("commonPercentFormat", Int((ratio * 100).rounded()))
    }
}
