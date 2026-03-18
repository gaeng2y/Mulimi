import DomainLayerInterface
import Foundation

final class MockHydrationProgressUseCase: HydrationProgressUseCase, @unchecked Sendable {
    var snapshot = HydrationProgressSnapshot.empty(dailyGoalML: 2000)

    func progressSnapshot(referenceDate: Date, calendar: Calendar) async -> HydrationProgressSnapshot {
        snapshot
    }
}
