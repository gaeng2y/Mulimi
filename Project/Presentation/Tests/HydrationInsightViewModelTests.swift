import DomainLayerInterface
import Foundation
import Testing

@testable import PresentationLayer

@Suite("HydrationInsightViewModel Tests")
struct HydrationInsightViewModelTests {
    @MainActor
    @Test("loadInsights는 공통 진행 스냅샷과 요일 패턴을 함께 반영한다")
    func loadInsights() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let waterUseCase = MockDrinkWaterUseCase()
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        routineAdherenceUseCase.insight = HydrationRoutineAdherenceInsight.make(
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
                    id: "inactive",
                    title: "비활성 루틴",
                    hour: 20,
                    minute: 0,
                    weekdayRawValues: [2],
                    isEnabled: false
                )
            ],
            events: [
                HydrationRoutineAdherenceEvent(
                    id: "monday",
                    consumedAt: calendar.date(from: DateComponents(year: 2026, month: 3, day: 9, hour: 9, minute: 20))!
                ),
                HydrationRoutineAdherenceEvent(
                    id: "tuesday",
                    consumedAt: calendar.date(from: DateComponents(year: 2026, month: 3, day: 10, hour: 9, minute: 0))!
                )
            ],
            referenceDate: referenceDate,
            calendar: calendar
        )
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            weeklyAverageML: 1875,
            monthlyAverageML: 12500.0 / 12.0,
            weeklyAchievementRate: 0.75,
            monthlyAchievementRate: 4.0 / 12.0,
            weeklyAchievedDays: 3,
            monthlyAchievedDays: 4,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 3,
            isEmpty: false
        )

        setTotal(2500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 2, hour: 9))!, using: waterUseCase)
        setTotal(1000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 6, hour: 9))!, using: waterUseCase)
        setTotal(1500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 7, hour: 9))!, using: waterUseCase)
        setTotal(2000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 9, hour: 9))!, using: waterUseCase)
        setTotal(2500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 10, hour: 9))!, using: waterUseCase)
        setTotal(2000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 11, hour: 9))!, using: waterUseCase)
        setTotal(1000, on: referenceDate, using: waterUseCase)

        let viewModel = HydrationInsightViewModel(
            waterUseCase: waterUseCase,
            progressUseCase: progressUseCase,
            routineAdherenceUseCase: routineAdherenceUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.isEmpty == false)
        #expect(viewModel.dailyGoalML == 2000)
        #expect(viewModel.weeklyElapsedDays == 4)
        #expect(viewModel.monthlyElapsedDays == 12)
        #expect(viewModel.weeklyAverageML == 1875)
        #expect(viewModel.monthlyAverageML == (12500.0 / 12.0))
        #expect(viewModel.weekdayDistributions.count == 7)
        #expect(viewModel.bestWeekday?.weekday == 2)
        #expect(viewModel.bestWeekday?.averageIntakeML == 2250)
        #expect(viewModel.leastWeekday?.weekday == 1)
        #expect(viewModel.leastWeekday?.averageIntakeML == 0)
        #expect(viewModel.routineAdherenceInsight?.scheduledCount == 4)
        #expect(viewModel.routineAdherenceInsight?.completedCount == 2)
        #expect(viewModel.routineAdherenceRows.first?.status == .needsAttention)
        #expect(viewModel.routineAdherenceRows.last?.status == .inactive)
        #expect(progressUseCase.requestedReferenceDate == referenceDate)
        #expect(routineAdherenceUseCase.requestedReferenceDate == referenceDate)
    }

    @MainActor
    @Test("loadInsights는 최근 기록이 없으면 empty state를 노출한다")
    func loadInsightsEmptyState() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        progressUseCase.snapshot = .empty(dailyGoalML: 2000)

        let viewModel = HydrationInsightViewModel(
            waterUseCase: MockDrinkWaterUseCase(),
            progressUseCase: progressUseCase,
            routineAdherenceUseCase: routineAdherenceUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.isEmpty == true)
        #expect(viewModel.weeklyAverageML == 0)
        #expect(viewModel.monthlyAverageML == 0)
        #expect(viewModel.weekdayDistributions.isEmpty)
        #expect(viewModel.dailyGoalML == 2000)
        #expect(viewModel.routineAdherenceInsight != nil)
    }

    @MainActor
    @Test("기록이 없어도 도래한 루틴이 있으면 루틴 수행률 카드를 노출한다")
    func loadInsightsShowsRoutineAdherenceWithoutHydrationRecords() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        progressUseCase.snapshot = .empty(dailyGoalML: 2000)
        routineAdherenceUseCase.insight = HydrationRoutineAdherenceInsight.make(
            routines: [
                HydrationRoutineSchedule(
                    id: "morning",
                    title: "아침 루틴",
                    hour: 9,
                    minute: 0,
                    weekdayRawValues: [2, 3, 4, 5],
                    isEnabled: true
                ),
                HydrationRoutineSchedule(
                    id: "inactive",
                    title: "비활성 루틴",
                    hour: 21,
                    minute: 0,
                    weekdayRawValues: [5],
                    isEnabled: false
                )
            ],
            events: [],
            referenceDate: referenceDate,
            calendar: calendar
        )

        let viewModel = HydrationInsightViewModel(
            waterUseCase: MockDrinkWaterUseCase(),
            progressUseCase: progressUseCase,
            routineAdherenceUseCase: routineAdherenceUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.isEmpty == false)
        #expect(viewModel.routineAdherenceRows.map(\.status) == [.noRecords, .inactive])
        #expect(viewModel.routineAdherenceInsight?.scheduledCount == 4)
    }

    private func setTotal(_ volumeML: Int, on date: Date, using useCase: MockDrinkWaterUseCase) {
        useCase.setHydrationEvents(
            [HydrationEvent(id: UUID(), consumedAt: date, volumeML: volumeML)],
            on: date
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
