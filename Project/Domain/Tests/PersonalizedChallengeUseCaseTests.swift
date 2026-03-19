import DomainLayerInterface
import Foundation
import Testing

@testable import DomainLayer

@Suite("PersonalizedChallengeUseCase Tests")
struct PersonalizedChallengeUseCaseTests {
    @Test("활성 루틴이 있으면 루틴 기반 추천을 우선 노출한다")
    func routineAnchorRecommendation() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 19, hour: 9))!
        let routineRepository = MockRoutineRepository()
        routineRepository.routines = [
            HydrationRoutine(
                title: "출근 준비",
                hour: 8,
                minute: 30,
                weekdays: [.monday, .tuesday, .wednesday, .thursday, .friday],
                isEnabled: true
            )
        ]
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(
            makeMorningEvents(
                calendar: calendar,
                referenceDate: referenceDate,
                hydratedDayOffsets: [0, 2]
            )
        )
        let useCase = PersonalizedChallengeUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let challenges = await useCase.fetchPersonalizedChallenges(
            snapshot: makeSnapshot(monthlyAverageML: 1500, dailyGoalML: 2000, weeklyAchievementRate: 0.65),
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(challenges.first?.kind == .routineAnchor)
        #expect(challenges.first?.anchorRoutine?.title == "출근 준비")
        #expect(challenges.first?.tier == .steady)
    }

    @Test("오전 섭취 습관이 부족하면 기록 기반 추천은 오전 시작 챌린지를 반환한다")
    func morningKickstartRecommendation() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 19, hour: 9))!
        let routineRepository = MockRoutineRepository()
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(
            makeMorningEvents(
                calendar: calendar,
                referenceDate: referenceDate,
                hydratedDayOffsets: [0, 5, 10]
            )
        )
        let useCase = PersonalizedChallengeUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let challenges = await useCase.fetchPersonalizedChallenges(
            snapshot: makeSnapshot(monthlyAverageML: 1800, dailyGoalML: 2000, weeklyAchievementRate: 0.35),
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(challenges.count == 1)
        #expect(challenges.first?.kind == .morningKickstart)
        #expect(challenges.first?.primaryCurrentValue == 3)
        #expect(challenges.first?.primaryTargetValue == 5)
    }

    @Test("최근 평균이 목표보다 낮지만 오전 습관이 안정적이면 평균 증량 추천을 반환한다")
    func dailyGoalBoosterRecommendation() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 19, hour: 9))!
        let routineRepository = MockRoutineRepository()
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(
            makeMorningEvents(
                calendar: calendar,
                referenceDate: referenceDate,
                hydratedDayOffsets: Array(0..<6)
            )
        )
        let useCase = PersonalizedChallengeUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let challenges = await useCase.fetchPersonalizedChallenges(
            snapshot: makeSnapshot(monthlyAverageML: 1620, dailyGoalML: 2000, weeklyAchievementRate: 0.5),
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(challenges.first?.kind == .dailyGoalBooster)
        #expect(challenges.first?.recommendedTargetML == 1750)
        #expect(challenges.first?.tier == .steady)
    }

    @Test("목표를 안정적으로 달성 중이면 유지형 추천을 반환한다")
    func consistencyDefenderRecommendation() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 19, hour: 9))!
        let routineRepository = MockRoutineRepository()
        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(
            makeMorningEvents(
                calendar: calendar,
                referenceDate: referenceDate,
                hydratedDayOffsets: Array(0..<7)
            )
        )
        let useCase = PersonalizedChallengeUseCaseImpl(
            routineUseCase: RoutineUseCaseImpl(repository: routineRepository),
            drinkWaterRepository: drinkWaterRepository
        )

        let challenges = await useCase.fetchPersonalizedChallenges(
            snapshot: makeSnapshot(
                monthlyAverageML: 2150,
                dailyGoalML: 2000,
                weeklyAchievementRate: 0.9,
                weeklyAchievedDays: 4,
                weeklyElapsedDays: 4
            ),
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(challenges.first?.kind == .consistencyDefender)
        #expect(challenges.first?.primaryCurrentValue == 4)
        #expect(challenges.first?.primaryTargetValue == 5)
    }

    private func makeSnapshot(
        monthlyAverageML: Double,
        dailyGoalML: Double,
        weeklyAchievementRate: Double,
        weeklyAchievedDays: Int = 2,
        weeklyElapsedDays: Int = 4
    ) -> HydrationProgressSnapshot {
        HydrationProgressSnapshot(
            dailyGoalML: dailyGoalML,
            todayIntakeML: 1200,
            hasAchievedTodayGoal: false,
            weeklyAverageML: monthlyAverageML,
            monthlyAverageML: monthlyAverageML,
            weeklyAchievementRate: weeklyAchievementRate,
            monthlyAchievementRate: weeklyAchievementRate,
            weeklyAchievedDays: weeklyAchievedDays,
            monthlyAchievedDays: 10,
            weeklyElapsedDays: weeklyElapsedDays,
            monthlyElapsedDays: 19,
            currentStreak: 2,
            isEmpty: false
        )
    }

    private func makeMorningEvents(
        calendar: Calendar,
        referenceDate: Date,
        hydratedDayOffsets: [Int]
    ) -> [HydrationEvent] {
        hydratedDayOffsets.map { offset in
            let day = calendar.date(byAdding: .day, value: -offset, to: referenceDate) ?? referenceDate
            let consumedAt = calendar.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: day
            ) ?? day

            return HydrationEvent(
                id: UUID(),
                consumedAt: consumedAt,
                volumeML: 250
            )
        }
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
