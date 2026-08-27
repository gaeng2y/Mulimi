import Foundation

public protocol HydrationProgressUseCase: Sendable {
    func progressSnapshot(referenceDate: Date, calendar: Calendar) async -> HydrationProgressSnapshot
}
