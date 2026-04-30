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
        let routineUseCase = SpyRoutineUseCase()
        routineUseCase.authorizationStatus = .authorized
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
            routineUseCase: routineUseCase,
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
        #expect(viewModel.weeklyReport?.averageML == 1875)
        #expect(viewModel.weeklyReport?.achievedDays == 3)
        #expect(viewModel.weeklyReport?.elapsedDays == 4)
        #expect(viewModel.weeklyReport?.previousAverageML == 625)
        #expect(viewModel.weeklyReport?.averageDeltaML == 1250)
        #expect(viewModel.weeklyReport?.achievedDayDelta == 2)
        #expect(viewModel.weeklyReport?.frequentlyEmptySlot == .afternoon)
        #expect(viewModel.weeklyReport?.frequentlyEmptySlotMissingDays == 4)
        #expect(viewModel.weeklyReportMetrics.count == 3)
        #expect(viewModel.weeklyCoachingCards.first?.action == .routine(.manageRoutine(.create)))
        #expect(viewModel.notificationStatus == .authorized)
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
        let routineUseCase = SpyRoutineUseCase()
        progressUseCase.snapshot = .empty(dailyGoalML: 2000)

        let viewModel = HydrationInsightViewModel(
            waterUseCase: MockDrinkWaterUseCase(),
            progressUseCase: progressUseCase,
            routineAdherenceUseCase: routineAdherenceUseCase,
            routineUseCase: routineUseCase,
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
        #expect(viewModel.weeklyReport?.hasCurrentWeekRecords == false)
        #expect(viewModel.weeklyReport?.elapsedDays == 4)
        #expect(viewModel.weeklyReportMetrics.count == 3)
    }

    @MainActor
    @Test("기록이 없어도 도래한 루틴이 있으면 루틴 수행률 카드를 노출한다")
    func loadInsightsShowsRoutineAdherenceWithoutHydrationRecords() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        let routineUseCase = SpyRoutineUseCase()
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
            routineUseCase: routineUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.isEmpty == false)
        #expect(viewModel.routineAdherenceRows.map(\.status) == [.noRecords, .inactive])
        #expect(viewModel.routineAdherenceInsight?.scheduledCount == 4)
        #expect(viewModel.weeklyReport?.elapsedDays == 4)
    }

    @MainActor
    @Test("놓친 루틴이 있으면 수정 CTA와 지금 기록 CTA를 만든다")
    func routineRecoveryCardForMissedRoutine() async {
        let calendar = makeCalendar()
        let routineID = UUID()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        let routineUseCase = SpyRoutineUseCase()
        routineUseCase.authorizationStatus = .authorized
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            todayIntakeML: 500,
            weeklyAverageML: 500,
            monthlyAverageML: 500,
            weeklyAchievementRate: 0,
            monthlyAchievementRate: 0,
            weeklyAchievedDays: 0,
            monthlyAchievedDays: 0,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 0,
            isEmpty: false
        )
        routineAdherenceUseCase.insight = HydrationRoutineAdherenceInsight.make(
            routines: [
                HydrationRoutineSchedule(
                    id: routineID.uuidString,
                    title: "아침 루틴",
                    hour: 9,
                    minute: 0,
                    weekdayRawValues: [2, 3, 4, 5],
                    isEnabled: true
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
            routineUseCase: routineUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.routineRecoveryCard?.canRecordNow == true)
        #expect(viewModel.routineRecoveryCard?.reminderAction == .manageRoutine(.edit(routineID)))
    }

    @MainActor
    @Test("알림 권한 미결정 상태에서는 권한 요청 CTA로 분기한다")
    func routineRecoveryCardRequestsNotificationAuthorization() async {
        let calendar = makeCalendar()
        let routineID = UUID()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        let routineUseCase = SpyRoutineUseCase()
        routineUseCase.authorizationStatus = .notDetermined
        routineUseCase.requestAuthorizationResult = .authorized
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            todayIntakeML: 500,
            weeklyAverageML: 500,
            monthlyAverageML: 500,
            weeklyAchievementRate: 0,
            monthlyAchievementRate: 0,
            weeklyAchievedDays: 0,
            monthlyAchievedDays: 0,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 0,
            isEmpty: false
        )
        routineAdherenceUseCase.insight = HydrationRoutineAdherenceInsight.make(
            routines: [
                HydrationRoutineSchedule(
                    id: routineID.uuidString,
                    title: "아침 루틴",
                    hour: 9,
                    minute: 0,
                    weekdayRawValues: [2, 3, 4, 5],
                    isEnabled: true
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
            routineUseCase: routineUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()
        #expect(viewModel.routineRecoveryCard?.reminderAction == .requestNotificationAuthorization(.edit(routineID)))

        let nextAction = await viewModel.requestRecoveryNotificationAuthorization(then: .edit(routineID))

        #expect(routineUseCase.requestAuthorizationCallCount == 1)
        #expect(viewModel.notificationStatus == .authorized)
        #expect(nextAction == .edit(routineID))
    }

    @MainActor
    @Test("복구 기록은 목표 초과가 아니면 기본 한 잔을 기록한다")
    func recordRecoveryDrink() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let waterUseCase = MockDrinkWaterUseCase()
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        let routineUseCase = SpyRoutineUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            todayIntakeML: 500,
            weeklyAverageML: 500,
            monthlyAverageML: 500,
            weeklyAchievementRate: 0,
            monthlyAchievementRate: 0,
            weeklyAchievedDays: 0,
            monthlyAchievedDays: 0,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 0,
            isEmpty: false
        )

        let viewModel = HydrationInsightViewModel(
            waterUseCase: waterUseCase,
            progressUseCase: progressUseCase,
            routineAdherenceUseCase: routineAdherenceUseCase,
            routineUseCase: routineUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()
        let didRecord = await viewModel.recordRecoveryDrink()

        #expect(didRecord)
        #expect(waterUseCase.recordedVolumesML == [HydrationServing.defaultGlassVolumeML])
    }

    @MainActor
    @Test("주간 코칭은 놓친 기존 루틴을 수정 CTA로 연결한다")
    func weeklyCoachingMissedRoutineAction() async {
        let calendar = makeCalendar()
        let routineID = UUID()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        let routineUseCase = SpyRoutineUseCase()
        routineUseCase.authorizationStatus = .authorized
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            weeklyAverageML: 500,
            monthlyAverageML: 500,
            weeklyAchievementRate: 0,
            monthlyAchievementRate: 0,
            weeklyAchievedDays: 0,
            monthlyAchievedDays: 0,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 0,
            isEmpty: false
        )
        routineAdherenceUseCase.insight = HydrationRoutineAdherenceInsight.make(
            routines: [
                HydrationRoutineSchedule(
                    id: routineID.uuidString,
                    title: "아침 루틴",
                    hour: 9,
                    minute: 0,
                    weekdayRawValues: [2, 3, 4, 5],
                    isEnabled: true
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
            routineUseCase: routineUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.weeklyCoachingCards.first?.action == .routine(.manageRoutine(.edit(routineID))))
    }

    @MainActor
    @Test("주간 코칭은 빈 시간대를 새 루틴 생성 CTA로 연결한다")
    func weeklyCoachingEmptySlotAction() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let waterUseCase = MockDrinkWaterUseCase()
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        let routineUseCase = SpyRoutineUseCase()
        routineUseCase.authorizationStatus = .authorized
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 500,
            weeklyAverageML: 500,
            monthlyAverageML: 500,
            weeklyAchievementRate: 1,
            monthlyAchievementRate: 1,
            weeklyAchievedDays: 4,
            monthlyAchievedDays: 4,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 4,
            isEmpty: false
        )

        for day in 9...12 {
            setEvents(
                [makeEvent(calendar: calendar, day: day, hour: 9, volumeML: 500)],
                on: calendar.date(from: DateComponents(year: 2026, month: 3, day: day, hour: 9))!,
                using: waterUseCase
            )
        }

        let viewModel = HydrationInsightViewModel(
            waterUseCase: waterUseCase,
            progressUseCase: progressUseCase,
            routineAdherenceUseCase: routineAdherenceUseCase,
            routineUseCase: routineUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.weeklyCoachingCards.first?.action == .routine(.manageRoutine(.create)))
    }

    @MainActor
    @Test("주간 코칭은 목표 부족 패턴을 목표 조정 CTA로 연결한다")
    func weeklyCoachingLowGoalAction() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let waterUseCase = MockDrinkWaterUseCase()
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        let routineUseCase = SpyRoutineUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            weeklyAverageML: 300,
            monthlyAverageML: 300,
            weeklyAchievementRate: 0,
            monthlyAchievementRate: 0,
            weeklyAchievedDays: 0,
            monthlyAchievedDays: 0,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 0,
            isEmpty: false
        )

        for day in 9...12 {
            setEvents(
                [
                    makeEvent(calendar: calendar, day: day, hour: 9, volumeML: 100),
                    makeEvent(calendar: calendar, day: day, hour: 13, volumeML: 100),
                    makeEvent(calendar: calendar, day: day, hour: 19, volumeML: 100)
                ],
                on: calendar.date(from: DateComponents(year: 2026, month: 3, day: day, hour: 9))!,
                using: waterUseCase
            )
        }

        let viewModel = HydrationInsightViewModel(
            waterUseCase: waterUseCase,
            progressUseCase: progressUseCase,
            routineAdherenceUseCase: routineAdherenceUseCase,
            routineUseCase: routineUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.weeklyCoachingCards.map(\.action) == [.dailyGoal])
    }

    @MainActor
    @Test("추천할 액션이 없으면 주간 코칭은 중립 안내를 만든다")
    func weeklyCoachingNeutralState() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 10))!
        let waterUseCase = MockDrinkWaterUseCase()
        let progressUseCase = MockHydrationProgressUseCase()
        let routineAdherenceUseCase = MockHydrationRoutineAdherenceUseCase()
        let routineUseCase = SpyRoutineUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 300,
            weeklyAverageML: 300,
            monthlyAverageML: 300,
            weeklyAchievementRate: 1,
            monthlyAchievementRate: 1,
            weeklyAchievedDays: 4,
            monthlyAchievedDays: 4,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 4,
            isEmpty: false
        )

        for day in 9...12 {
            setEvents(
                [
                    makeEvent(calendar: calendar, day: day, hour: 9, volumeML: 100),
                    makeEvent(calendar: calendar, day: day, hour: 13, volumeML: 100),
                    makeEvent(calendar: calendar, day: day, hour: 19, volumeML: 100)
                ],
                on: calendar.date(from: DateComponents(year: 2026, month: 3, day: day, hour: 9))!,
                using: waterUseCase
            )
        }

        let viewModel = HydrationInsightViewModel(
            waterUseCase: waterUseCase,
            progressUseCase: progressUseCase,
            routineAdherenceUseCase: routineAdherenceUseCase,
            routineUseCase: routineUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadInsights()

        #expect(viewModel.weeklyCoachingCards.map(\.action) == [.none])
    }

    private func setTotal(_ volumeML: Int, on date: Date, using useCase: MockDrinkWaterUseCase) {
        useCase.setHydrationEvents(
            [HydrationEvent(id: UUID(), consumedAt: date, volumeML: volumeML)],
            on: date
        )
    }

    private func setEvents(
        _ events: [HydrationEvent],
        on date: Date,
        using useCase: MockDrinkWaterUseCase
    ) {
        useCase.setHydrationEvents(events, on: date)
    }

    private func makeEvent(
        calendar: Calendar,
        day: Int,
        hour: Int,
        volumeML: Int
    ) -> HydrationEvent {
        HydrationEvent(
            id: UUID(),
            consumedAt: calendar.date(from: DateComponents(year: 2026, month: 3, day: day, hour: hour))!,
            volumeML: volumeML
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

private final class SpyRoutineUseCase: RoutineUseCase, @unchecked Sendable {
    var routines: [HydrationRoutine] = []
    var authorizationStatus: RoutineNotificationAuthorizationStatus = .notDetermined
    var requestAuthorizationResult: RoutineNotificationAuthorizationStatus = .authorized
    private(set) var notificationStatusCallCount = 0
    private(set) var requestAuthorizationCallCount = 0

    func fetchRoutines() -> [HydrationRoutine] {
        routines
    }

    func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus {
        notificationStatusCallCount += 1
        return authorizationStatus
    }

    func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
        requestAuthorizationCallCount += 1
        authorizationStatus = requestAuthorizationResult
        return authorizationStatus
    }

    func saveRoutine(_ routine: HydrationRoutine) async throws {
        if let index = routines.firstIndex(where: { $0.id == routine.id }) {
            routines[index] = routine
        } else {
            routines.append(routine)
        }
    }

    func deleteRoutine(id: UUID) async throws {
        routines.removeAll { $0.id == id }
    }
}
