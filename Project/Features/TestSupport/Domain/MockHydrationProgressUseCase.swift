import HydrationDomain
import Foundation

final class MockHydrationProgressUseCase: HydrationProgressUseCase, @unchecked Sendable {
    var readError: Error?
    var snapshot = HydrationProgressSnapshot.empty(dailyGoalML: 2000)

    func progressSnapshot(referenceDate: Date, calendar: Calendar) async throws -> HydrationProgressSnapshot {
        if let readError { throw readError }
        return snapshot
    }
}
