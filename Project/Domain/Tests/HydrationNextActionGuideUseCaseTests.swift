import DomainLayer
import DomainLayerInterface
import Foundation
import Testing

@testable import DomainLayer

@Suite("HydrationNextActionGuideUseCase Tests")
struct HydrationNextActionGuideUseCaseTests {
    @Test("남은 양과 잔 수, 다음 루틴까지 시간을 함께 계산한다")
    func guideCombinesRemainingServingAndNextRoutine() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 4, day: 10, hour: 9, minute: 30))!
        let weekday = RoutineWeekday(rawValue: calendar.component(.weekday, from: referenceDate))!
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setCurrentWaterIntakeML(1_250)
        let userPreferencesRepository = MockUserPreferencesRepository()
        userPreferencesRepository.setDailyWaterLimit(2_000)
        let routineRepository = MockRoutineRepository()
        routineRepository.routines = [
            HydrationRoutine(
                title: "오전 루틴",
                hour: 10,
                minute: 0,
                weekdays: [weekday],
                isEnabled: true
            )
        ]
        let useCase = HydrationNextActionGuideUseCaseImpl(
            drinkWaterRepository: drinkWaterRepository,
            userPreferencesRepository: userPreferencesRepository,
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository)
        )

        let guide = await useCase.guide(referenceDate: referenceDate, calendar: calendar)

        #expect(guide.state == .approachingRoutine)
        #expect(guide.remainingML == 750)
        #expect(guide.remainingGlassCount == 3)
        #expect(guide.nextRoutine?.title == "오전 루틴")
        #expect(guide.nextRoutine?.minutesUntil == 30)
    }

    @Test("오늘 목표를 달성했으면 유지 상태로 전환한다")
    func guideGoalReached() {
        let guide = HydrationNextActionGuide.make(
            currentIntakeML: 2_000,
            dailyGoalML: 2_000
        )

        #expect(guide.state == .goalReached)
        #expect(guide.remainingML == 0)
        #expect(guide.remainingGlassCount == 0)
    }

    @Test("오늘 루틴 시간이 지났으면 다음 예정 루틴을 다음 날짜로 계산한다")
    func nextRoutineUsesFutureOccurrence() {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 4, day: 10, hour: 11))!
        let weekday = calendar.component(.weekday, from: referenceDate)
        let guide = HydrationNextActionGuide.make(
            currentIntakeML: 500,
            dailyGoalML: 2_000,
            routines: [
                HydrationRoutineSchedule(
                    id: "morning",
                    title: "오전 루틴",
                    hour: 10,
                    minute: 0,
                    weekdayRawValues: [weekday],
                    isEnabled: true
                )
            ],
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(guide.nextRoutine?.minutesUntil == 10_020)
    }

    private func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }
}
