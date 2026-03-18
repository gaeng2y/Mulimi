import DomainLayerInterface
import Foundation

public final class MockHydrationProgressUseCaseForTesting: HydrationProgressUseCase, @unchecked Sendable {
    public var snapshot: HydrationProgressSnapshot

    public init(
        snapshot: HydrationProgressSnapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            weeklyAverageML: 0,
            monthlyAverageML: 0,
            weeklyAchievementRate: 0,
            monthlyAchievementRate: 0,
            weeklyAchievedDays: 0,
            monthlyAchievedDays: 0,
            weeklyElapsedDays: 0,
            monthlyElapsedDays: 0,
            currentStreak: 0,
            isEmpty: true
        )
    ) {
        self.snapshot = snapshot
    }

    public func progressSnapshot(referenceDate: Date, calendar: Calendar) async -> HydrationProgressSnapshot {
        snapshot
    }
}
