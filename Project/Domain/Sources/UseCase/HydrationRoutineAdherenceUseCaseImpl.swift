import DomainLayerInterface
import Foundation

public struct HydrationRoutineAdherenceUseCaseImpl: HydrationRoutineAdherenceUseCase {
    private let routineUseCase: RoutineUseCase
    private let drinkWaterRepository: DrinkWaterRepository

    public init(
        routineUseCase: RoutineUseCase,
        drinkWaterRepository: DrinkWaterRepository
    ) {
        self.routineUseCase = routineUseCase
        self.drinkWaterRepository = drinkWaterRepository
    }

    public func weeklyInsight(
        referenceDate: Date,
        calendar: Calendar
    ) async -> HydrationRoutineAdherenceInsight {
        let routines = routineUseCase.fetchRoutines().map(\.nextActionSchedule)
        let fetchInterval = fetchInterval(referenceDate: referenceDate, calendar: calendar)
        let events = await drinkWaterRepository.hydrationEvents(in: fetchInterval).map {
            HydrationRoutineAdherenceEvent(
                id: $0.id.uuidString,
                consumedAt: $0.consumedAt
            )
        }

        return HydrationRoutineAdherenceInsight.make(
            routines: routines,
            events: events,
            referenceDate: referenceDate,
            calendar: calendar
        )
    }

    private func fetchInterval(referenceDate: Date, calendar: Calendar) -> DateInterval {
        let start = calendar.dateInterval(of: .weekOfYear, for: referenceDate)?.start
            ?? calendar.startOfDay(for: referenceDate)
        let end = referenceDate.addingTimeInterval(1)
        return DateInterval(start: start, end: max(end, start.addingTimeInterval(1)))
    }
}
