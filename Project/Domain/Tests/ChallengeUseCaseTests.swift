import DomainLayer
import DomainLayerInterface
import Foundation
import Testing

@testable import DomainLayer

@Suite("ChallengeUseCase Tests")
struct ChallengeUseCaseTests {
    @Test("3종 챌린지를 계산하고 신규 완료 상태를 저장한다")
    func fetchChallenges() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let progressUseCase = MockHydrationProgressUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            weeklyAverageML: 1900,
            monthlyAverageML: 1800,
            weeklyAchievementRate: 0.75,
            monthlyAchievementRate: 0.4,
            weeklyAchievedDays: 3,
            monthlyAchievedDays: 5,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 7,
            isEmpty: false
        )

        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents(makeGoalAchievementEvents(calendar: calendar))
        let challengeRepository = MockChallengeRepository()

        let useCase = ChallengeUseCaseImpl(
            progressUseCase: progressUseCase,
            challengeRepository: challengeRepository,
            drinkWaterRepository: drinkWaterRepository
        )

        let challenges = await useCase.fetchChallenges(referenceDate: referenceDate, calendar: calendar)

        #expect(challenges.count == 3)

        let streak = challenges.first { $0.kind == .streak7 }
        #expect(streak?.isCompleted == true)
        #expect(streak?.progress == 1)
        #expect(streak?.achievedAt == referenceDate)

        let weekly = challenges.first { $0.kind == .weeklyAchievement80 }
        #expect(weekly?.isCompleted == false)
        #expect(weekly?.primaryCurrentValue == 75)
        #expect(weekly?.secondaryCurrentValue == 3)
        #expect(weekly?.secondaryTargetValue == 4)

        let count = challenges.first { $0.kind == .goalAchievement30 }
        #expect(count?.primaryCurrentValue == 12)
        #expect(count?.primaryTargetValue == 30)
        #expect(count?.isCompleted == false)

        #expect(challengeRepository.saveChallengeStatesCallCount == 1)
        #expect(challengeRepository.lastSavedStates.count == 3)
    }

    @Test("이미 완료한 챌린지는 진행도가 떨어져도 완료 상태와 달성 시점을 유지한다")
    func keepsPersistedCompletion() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let achievedAt = calendar.date(from: DateComponents(year: 2026, month: 3, day: 10, hour: 8))!
        let progressUseCase = MockHydrationProgressUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            weeklyAverageML: 1200,
            monthlyAverageML: 1200,
            weeklyAchievementRate: 0.25,
            monthlyAchievementRate: 0.25,
            weeklyAchievedDays: 1,
            monthlyAchievedDays: 3,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 1,
            isEmpty: false
        )

        let challengeRepository = MockChallengeRepository()
        challengeRepository.setChallengeStates(
            [
                HydrationChallengeState(
                    kind: .weeklyAchievement80,
                    progress: 1,
                    isCompleted: true,
                    achievedAt: achievedAt,
                    updatedAt: achievedAt
                )
            ]
        )

        let useCase = ChallengeUseCaseImpl(
            progressUseCase: progressUseCase,
            challengeRepository: challengeRepository,
            drinkWaterRepository: MockDrinkWaterRepository()
        )

        let challenges = await useCase.fetchChallenges(referenceDate: referenceDate, calendar: calendar)
        let weekly = challenges.first { $0.kind == .weeklyAchievement80 }

        #expect(weekly?.isCompleted == true)
        #expect(weekly?.progress == 1)
        #expect(weekly?.achievedAt == achievedAt)
    }

    private func makeGoalAchievementEvents(calendar: Calendar) -> [HydrationEvent] {
        let achievedDays = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

        return achievedDays.compactMap { day in
            guard let date = calendar.date(from: DateComponents(year: 2026, month: 3, day: day, hour: 9)) else {
                return nil
            }

            return HydrationEvent(
                id: UUID(),
                consumedAt: date,
                volumeML: 2000
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
