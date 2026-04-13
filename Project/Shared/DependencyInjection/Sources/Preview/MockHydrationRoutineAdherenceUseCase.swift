import DomainLayerInterface
import Foundation

public final class MockHydrationRoutineAdherenceUseCase: HydrationRoutineAdherenceUseCase, @unchecked Sendable {
    public var insight: HydrationRoutineAdherenceInsight

    public init(
        insight: HydrationRoutineAdherenceInsight = HydrationRoutineAdherenceInsight.make(
            routines: [
                HydrationRoutineSchedule(
                    id: "morning",
                    title: "아침 루틴",
                    hour: 9,
                    minute: 0,
                    weekdayRawValues: [2, 3, 4, 5, 6],
                    isEnabled: true
                ),
                HydrationRoutineSchedule(
                    id: "afternoon",
                    title: "오후 루틴",
                    hour: 15,
                    minute: 0,
                    weekdayRawValues: [2, 3, 4, 5, 6],
                    isEnabled: true
                ),
                HydrationRoutineSchedule(
                    id: "inactive",
                    title: "쉬는 날 루틴",
                    hour: 20,
                    minute: 0,
                    weekdayRawValues: [7],
                    isEnabled: false
                )
            ],
            events: [
                HydrationRoutineAdherenceEvent(
                    id: "preview-morning",
                    consumedAt: .now.addingTimeInterval(-60 * 40)
                )
            ]
        )
    ) {
        self.insight = insight
    }

    public func weeklyInsight(
        referenceDate: Date,
        calendar: Calendar
    ) async -> HydrationRoutineAdherenceInsight {
        insight
    }
}
