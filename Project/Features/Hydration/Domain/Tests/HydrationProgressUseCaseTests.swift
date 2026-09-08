import AccountDomain
import HydrationDomain
import Foundation
import Testing

@testable import HydrationDomain

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
        #expect(snapshot.recentRecordDate == nil)
        #expect(snapshot.comebackGapDays(referenceDate: referenceDate, calendar: calendar) == nil)
    }

    @Test("목표 달성과 무관하게 완전히 비어 있는 2~6일만 복귀 대상으로 계산한다",
          arguments: [0, 1, 2, 3, 4, 7, 8], ["Asia/Seoul", "America/Los_Angeles"])
    func comebackGap(daysAgo: Int, timeZone: String) async {
        var calendar = makeCalendar()
        calendar.timeZone = TimeZone(identifier: timeZone)!
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 10, hour: 9))!
        let recordDate = calendar.date(byAdding: .day, value: -daysAgo, to: referenceDate)!
        let repository = MockDrinkWaterRepository()
        repository.setHydrationEvents([
            HydrationEvent(id: UUID(), consumedAt: recordDate, volumeML: HydrationServing.defaultGlassVolumeML)
        ])
        let useCase = HydrationProgressUseCaseImpl(
            drinkWaterRepository: repository,
            userPreferencesRepository: MockUserPreferencesRepository()
        )

        let snapshot = await useCase.progressSnapshot(referenceDate: referenceDate, calendar: calendar)

        let expectedGap = (3...7).contains(daysAgo) ? daysAgo - 1 : nil
        #expect(snapshot.comebackGapDays(referenceDate: referenceDate, calendar: calendar) == expectedGap)
        #expect(snapshot.currentStreak == 0)
    }

    @Test("월 경계의 지난주 기록을 찾고 0ml와 미래 기록은 최근 기록에서 제외한다")
    func recentRecordAcrossMonthBoundary() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1, hour: 9))!
        let recordDate = calendar.date(byAdding: .day, value: -7, to: referenceDate)!
        let repository = MockDrinkWaterRepository()
        repository.setHydrationEvents([
            HydrationEvent(id: UUID(), consumedAt: recordDate, volumeML: HydrationServing.defaultGlassVolumeML),
            HydrationEvent(id: UUID(), consumedAt: referenceDate, volumeML: 0),
            HydrationEvent(
                id: UUID(),
                consumedAt: calendar.date(byAdding: .day, value: 1, to: referenceDate)!,
                volumeML: HydrationServing.defaultGlassVolumeML
            )
        ])
        let useCase = HydrationProgressUseCaseImpl(
            drinkWaterRepository: repository,
            userPreferencesRepository: MockUserPreferencesRepository()
        )

        let snapshot = await useCase.progressSnapshot(referenceDate: referenceDate, calendar: calendar)

        #expect(snapshot.recentRecordDate == recordDate)
        #expect(snapshot.comebackGapDays(referenceDate: referenceDate, calendar: calendar) == 6)
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
