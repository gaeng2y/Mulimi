import DomainLayerInterface
import Foundation

public final class MockHydrationRoutineAdherenceUseCaseForTesting: HydrationRoutineAdherenceUseCase, @unchecked Sendable {
    public var insight: HydrationRoutineAdherenceInsight
    public private(set) var weeklyInsightCallCount = 0

    public init(
        insight: HydrationRoutineAdherenceInsight = HydrationRoutineAdherenceInsight.make(
            routines: [],
            events: []
        )
    ) {
        self.insight = insight
    }

    public func weeklyInsight(
        referenceDate: Date,
        calendar: Calendar
    ) async -> HydrationRoutineAdherenceInsight {
        weeklyInsightCallCount += 1
        return insight
    }
}
