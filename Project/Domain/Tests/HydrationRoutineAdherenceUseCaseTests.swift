import DomainLayerInterface
import Foundation
import Testing

@testable import DomainLayer

@Suite("HydrationRoutineAdherenceUseCase Tests")
struct HydrationRoutineAdherenceUseCaseTests {
    @Test("이번 주 도래한 루틴별 수행률과 미스 시간대를 계산한다")
    func weeklyInsightCalculatesRoutineRatesAndMissPattern() async {
        let calendar = makeCalendar()
        let referenceDate = makeDate(year: 2026, month: 4, day: 10, hour: 18, minute: 0, calendar: calendar)
        let morningRoutine = HydrationRoutine(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            title: "아침 루틴",
            hour: 9,
            minute: 0,
            weekdays: [.monday, .wednesday, .friday],
            isEnabled: true
        )
        let afternoonRoutine = HydrationRoutine(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            title: "오후 루틴",
            hour: 15,
            minute: 0,
            weekdays: [.tuesday, .thursday],
            isEnabled: true
        )
        let inactiveRoutine = HydrationRoutine(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            title: "비활성 루틴",
            hour: 20,
            minute: 0,
            weekdays: [.monday],
            isEnabled: false
        )
        let routineRepository = MockRoutineRepository()
        routineRepository.routines = [morningRoutine, afternoonRoutine, inactiveRoutine]
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents([
            makeEvent(year: 2026, month: 4, day: 6, hour: 9, minute: 20, calendar: calendar),
            makeEvent(year: 2026, month: 4, day: 10, hour: 8, minute: 10, calendar: calendar)
        ])
        let useCase = HydrationRoutineAdherenceUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let insight = await useCase.weeklyInsight(referenceDate: referenceDate, calendar: calendar)

        let morningSummary = insight.routineSummaries.first { $0.id == morningRoutine.id.uuidString }
        let afternoonSummary = insight.routineSummaries.first { $0.id == afternoonRoutine.id.uuidString }
        let inactiveSummary = insight.routineSummaries.first { $0.id == inactiveRoutine.id.uuidString }
        #expect(insight.scheduledCount == 5)
        #expect(insight.completedCount == 2)
        #expect(insight.missedCount == 3)
        #expect(insight.activeRoutineCount == 2)
        #expect(insight.inactiveRoutineCount == 1)
        #expect(morningSummary?.scheduledCount == 3)
        #expect(morningSummary?.completedCount == 2)
        #expect(morningSummary?.missedCount == 1)
        #expect(morningSummary?.status == .needsAttention)
        #expect(abs((morningSummary?.adherenceRate ?? 0) - (2.0 / 3.0)) < 0.001)
        #expect(afternoonSummary?.scheduledCount == 2)
        #expect(afternoonSummary?.completedCount == 0)
        #expect(afternoonSummary?.status == .noRecords)
        #expect(inactiveSummary?.status == .inactive)
        #expect(insight.mostMissedTimeSlot?.hour == 15)
        #expect(insight.mostMissedTimeSlot?.missedCount == 2)
    }

    @Test("하나의 기록은 가장 가까운 루틴 슬롯 하나에만 매칭한다")
    func recordMatchesSingleNearestRoutineSlot() {
        let calendar = makeCalendar()
        let referenceDate = makeDate(year: 2026, month: 4, day: 6, hour: 12, minute: 0, calendar: calendar)
        let insight = HydrationRoutineAdherenceInsight.make(
            routines: [
                HydrationRoutineSchedule(
                    id: "morning",
                    title: "아침 루틴",
                    hour: 9,
                    minute: 0,
                    weekdayRawValues: [2],
                    isEnabled: true
                ),
                HydrationRoutineSchedule(
                    id: "lateMorning",
                    title: "늦은 오전 루틴",
                    hour: 10,
                    minute: 0,
                    weekdayRawValues: [2],
                    isEnabled: true
                )
            ],
            events: [
                HydrationRoutineAdherenceEvent(
                    id: "event",
                    consumedAt: makeDate(year: 2026, month: 4, day: 6, hour: 9, minute: 30, calendar: calendar)
                )
            ],
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(insight.completedCount == 1)
        #expect(insight.missedCount == 1)
        #expect(insight.routineSummaries.first { $0.id == "morning" }?.completedCount == 1)
        #expect(insight.routineSummaries.first { $0.id == "lateMorning" }?.completedCount == 0)
    }

    @Test("아직 도래하지 않은 활성 루틴은 기록 없음과 구분한다")
    func futureRoutineIsNoDueOccurrences() {
        let calendar = makeCalendar()
        let referenceDate = makeDate(year: 2026, month: 4, day: 6, hour: 10, minute: 0, calendar: calendar)
        let insight = HydrationRoutineAdherenceInsight.make(
            routines: [
                HydrationRoutineSchedule(
                    id: "evening",
                    title: "저녁 루틴",
                    hour: 18,
                    minute: 0,
                    weekdayRawValues: [2],
                    isEnabled: true
                )
            ],
            events: [],
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(insight.scheduledCount == 0)
        #expect(insight.routineSummaries.first?.status == .noDueOccurrences)
    }

    private func makeEvent(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        calendar: Calendar
    ) -> HydrationEvent {
        HydrationEvent(
            id: UUID(),
            consumedAt: makeDate(
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute,
                calendar: calendar
            ),
            volumeML: Int(HydrationServing.defaultGlassML)
        )
    }

    private func makeDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        calendar: Calendar
    ) -> Date {
        calendar.date(
            from: DateComponents(
                year: year,
                month: month,
                day: day,
                hour: hour,
                minute: minute
            )
        )!
    }

    private func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        calendar.firstWeekday = 2
        calendar.minimumDaysInFirstWeek = 4
        return calendar
    }
}
