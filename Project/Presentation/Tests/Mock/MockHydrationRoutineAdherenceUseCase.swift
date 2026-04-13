import DomainLayerInterface
import Foundation

final class MockHydrationRoutineAdherenceUseCase: HydrationRoutineAdherenceUseCase, @unchecked Sendable {
    var insight = HydrationRoutineAdherenceInsight.make(routines: [], events: [])
    private(set) var requestedReferenceDate: Date?
    private(set) var requestedCalendar: Calendar?

    func weeklyInsight(
        referenceDate: Date,
        calendar: Calendar
    ) async -> HydrationRoutineAdherenceInsight {
        requestedReferenceDate = referenceDate
        requestedCalendar = calendar
        return insight
    }
}
