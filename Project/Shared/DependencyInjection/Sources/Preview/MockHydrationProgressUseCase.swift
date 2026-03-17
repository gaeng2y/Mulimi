import DomainLayerInterface
import Foundation

public final class MockHydrationProgressUseCase: HydrationProgressUseCase, @unchecked Sendable {
    public var snapshot: HydrationProgressSnapshot

    public init(
        snapshot: HydrationProgressSnapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            weeklyAverageML: 1750,
            monthlyAverageML: 1680,
            weeklyAchievementRate: 0.75,
            monthlyAchievementRate: 0.58,
            weeklyAchievedDays: 3,
            monthlyAchievedDays: 7,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 3,
            isEmpty: false
        )
    ) {
        self.snapshot = snapshot
    }

    public func progressSnapshot(referenceDate: Date, calendar: Calendar) async -> HydrationProgressSnapshot {
        snapshot
    }
}
