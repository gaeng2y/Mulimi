import DomainLayerInterface
import Foundation

final class MockHydrationProgressUseCase: HydrationProgressUseCase, @unchecked Sendable {
    var snapshot = HydrationProgressSnapshot(
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

    private(set) var requestedReferenceDate: Date?
    private(set) var requestedCalendar: Calendar?

    func progressSnapshot(referenceDate: Date, calendar: Calendar) async -> HydrationProgressSnapshot {
        requestedReferenceDate = referenceDate
        requestedCalendar = calendar
        return snapshot
    }
}
