import DomainLayer
import DomainLayerInterface
import Foundation
import Testing

@testable import DomainLayer

@Suite("HydrationProgressUseCase Tests")
struct HydrationProgressUseCaseTests {
    @Test("주간/월간 진행 스냅샷과 streak를 계산한다")
    func progressSnapshot() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let drinkWaterRepository = MockDrinkWaterRepository()
        let userPreferencesRepository = MockUserPreferencesRepository()
        userPreferencesRepository.setDailyWaterLimit(2000)
        var events: [HydrationEvent] = []

        appendTotal(2500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 2, hour: 9))!, into: &events)
        appendTotal(1000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 6, hour: 9))!, into: &events)
        appendTotal(1500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 7, hour: 9))!, into: &events)
        appendTotal(2000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 9, hour: 9))!, into: &events)
        appendTotal(2500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 10, hour: 9))!, into: &events)
        appendTotal(2000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 11, hour: 9))!, into: &events)
        appendTotal(1000, on: referenceDate, into: &events)
        drinkWaterRepository.setHydrationEvents(events)

        let useCase = HydrationProgressUseCaseImpl(
            drinkWaterRepository: drinkWaterRepository,
            userPreferencesRepository: userPreferencesRepository
        )

        let snapshot = await useCase.progressSnapshot(referenceDate: referenceDate, calendar: calendar)

        #expect(snapshot.dailyGoalML == 2000)
        #expect(snapshot.todayIntakeML == 1000)
        #expect(snapshot.hasAchievedTodayGoal == false)
        #expect(snapshot.weeklyElapsedDays == 4)
        #expect(snapshot.monthlyElapsedDays == 12)
        #expect(snapshot.weeklyAchievedDays == 3)
        #expect(snapshot.monthlyAchievedDays == 4)
        #expect(snapshot.weeklyAverageML == 1875)
        #expect(snapshot.monthlyAverageML == (12500.0 / 12.0))
        #expect(snapshot.weeklyAchievementRate == 0.75)
        #expect(snapshot.monthlyAchievementRate == (4.0 / 12.0))
        #expect(snapshot.currentStreak == 3)
        #expect(snapshot.currentStreakStartDate == calendar.date(from: DateComponents(year: 2026, month: 3, day: 9))!)
        #expect(snapshot.isEmpty == false)
    }

    @Test("최근 기록이 없으면 empty 스냅샷을 반환한다")
    func progressSnapshotEmptyState() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let useCase = HydrationProgressUseCaseImpl(
            drinkWaterRepository: MockDrinkWaterRepository(),
            userPreferencesRepository: MockUserPreferencesRepository()
        )

        let snapshot = await useCase.progressSnapshot(referenceDate: referenceDate, calendar: calendar)

        #expect(snapshot.isEmpty == true)
        #expect(snapshot.todayIntakeML == 0)
        #expect(snapshot.hasAchievedTodayGoal == false)
        #expect(snapshot.weeklyAverageML == 0)
        #expect(snapshot.monthlyAverageML == 0)
        #expect(snapshot.currentStreak == 0)
        #expect(snapshot.currentStreakStartDate == nil)
    }

    private func appendTotal(_ volumeML: Int, on date: Date, into events: inout [HydrationEvent]) {
        events.append(
            HydrationEvent(id: UUID(), consumedAt: date, volumeML: volumeML)
        )
    }

    private func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        calendar.firstWeekday = 2
        calendar.minimumDaysInFirstWeek = 4
        return calendar
    }
}
