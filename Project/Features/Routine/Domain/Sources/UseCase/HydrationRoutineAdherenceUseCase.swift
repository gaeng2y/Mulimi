import Foundation

public protocol HydrationRoutineAdherenceUseCase: Sendable {
    func weeklyInsight(
        referenceDate: Date,
        calendar: Calendar
    ) async -> HydrationRoutineAdherenceInsight
}
