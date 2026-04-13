import DomainLayerInterface
import Foundation

public struct HydrationNextActionGuideUseCaseImpl: HydrationNextActionGuideUseCase {
    private let drinkWaterRepository: DrinkWaterRepository
    private let userPreferencesRepository: UserPreferencesRepository
    private let routineUseCase: RoutineUseCase

    public init(
        drinkWaterRepository: DrinkWaterRepository,
        userPreferencesRepository: UserPreferencesRepository,
        routineUseCase: RoutineUseCase
    ) {
        self.drinkWaterRepository = drinkWaterRepository
        self.userPreferencesRepository = userPreferencesRepository
        self.routineUseCase = routineUseCase
    }

    public func guide(referenceDate: Date, calendar: Calendar) async -> HydrationNextActionGuide {
        let currentIntakeML = await drinkWaterRepository.currentWaterIntakeML
        let dailyGoalML = userPreferencesRepository.getDailyWaterLimit()
        let routineSchedules = routineUseCase.fetchRoutines().map(\.nextActionSchedule)

        return HydrationNextActionGuide.make(
            currentIntakeML: currentIntakeML,
            dailyGoalML: dailyGoalML,
            routines: routineSchedules,
            referenceDate: referenceDate,
            calendar: calendar
        )
    }
}
