import Foundation

public struct HydrationProgressSnapshot: Equatable, Sendable {
    public let dailyGoalML: Double
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
    public let isEmpty: Bool

    public init(
        dailyGoalML: Double,
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
        isEmpty: Bool
    ) {
        self.dailyGoalML = dailyGoalML
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
        self.isEmpty = isEmpty
    }

    public static func empty(dailyGoalML: Double) -> HydrationProgressSnapshot {
        HydrationProgressSnapshot(
            dailyGoalML: dailyGoalML,
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
