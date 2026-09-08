import Foundation

public struct HydrationProgressSnapshot: Equatable, Sendable {
    public let dailyGoalML: Double
    public let todayIntakeML: Double
    public let hasAchievedTodayGoal: Bool
    public let weeklyAverageML: Double
    public let monthlyAverageML: Double
    public let weeklyAchievementRate: Double
    public let monthlyAchievementRate: Double
    public let weeklyAchievedDays: Int
    public let monthlyAchievedDays: Int
    public let weeklyElapsedDays: Int
    public let monthlyElapsedDays: Int
    public let currentStreak: Int
    public let currentStreakStartDate: Date?
    /// The latest positive record in the seven-day lookback, including today.
    public let recentRecordDate: Date?
    public let isEmpty: Bool

    public init(
        dailyGoalML: Double,
        todayIntakeML: Double = 0,
        hasAchievedTodayGoal: Bool = false,
        weeklyAverageML: Double,
        monthlyAverageML: Double,
        weeklyAchievementRate: Double,
        monthlyAchievementRate: Double,
        weeklyAchievedDays: Int,
        monthlyAchievedDays: Int,
        weeklyElapsedDays: Int,
        monthlyElapsedDays: Int,
        currentStreak: Int,
        currentStreakStartDate: Date? = nil,
        recentRecordDate: Date? = nil,
        isEmpty: Bool
    ) {
        self.dailyGoalML = dailyGoalML
        self.todayIntakeML = todayIntakeML
        self.hasAchievedTodayGoal = hasAchievedTodayGoal
        self.weeklyAverageML = weeklyAverageML
        self.monthlyAverageML = monthlyAverageML
        self.weeklyAchievementRate = weeklyAchievementRate
        self.monthlyAchievementRate = monthlyAchievementRate
        self.weeklyAchievedDays = weeklyAchievedDays
        self.monthlyAchievedDays = monthlyAchievedDays
        self.weeklyElapsedDays = weeklyElapsedDays
        self.monthlyElapsedDays = monthlyElapsedDays
        self.currentStreak = currentStreak
        self.currentStreakStartDate = currentStreakStartDate
        self.recentRecordDate = recentRecordDate
        self.isEmpty = isEmpty
    }

    public func comebackGapDays(referenceDate: Date, calendar: Calendar) -> Int? {
        guard todayIntakeML == 0, let recentRecordDate, recentRecordDate <= referenceDate,
              let elapsedDays = calendar.dateComponents(
                [.day],
                from: calendar.startOfDay(for: recentRecordDate),
                to: calendar.startOfDay(for: referenceDate)
              ).day else {
            return nil
        }

        // Exclude the last recorded day and the incomplete return day.
        let gapDays = elapsedDays - 1
        return (2...6).contains(gapDays) ? gapDays : nil
    }

    public static func empty(dailyGoalML: Double) -> HydrationProgressSnapshot {
        HydrationProgressSnapshot(
            dailyGoalML: dailyGoalML,
            todayIntakeML: 0,
            hasAchievedTodayGoal: false,
            weeklyAverageML: 0,
            monthlyAverageML: 0,
            weeklyAchievementRate: 0,
            monthlyAchievementRate: 0,
            weeklyAchievedDays: 0,
            monthlyAchievedDays: 0,
            weeklyElapsedDays: 0,
            monthlyElapsedDays: 0,
            currentStreak: 0,
            currentStreakStartDate: nil,
            isEmpty: true
        )
    }
}
