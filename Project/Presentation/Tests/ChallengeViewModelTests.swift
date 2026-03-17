import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("ChallengeViewModel Tests")
struct ChallengeViewModelTests {
    @MainActor
    @Test("loadChallenges는 streak와 주간/월간 달성률을 계산한다")
    func loadChallenges() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let waterUseCase = MockDrinkWaterUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 2000

        setTotal(2500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 2, hour: 9))!, using: waterUseCase)
        setTotal(1000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 6, hour: 9))!, using: waterUseCase)
        setTotal(1500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 7, hour: 9))!, using: waterUseCase)
        setTotal(2000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 9, hour: 9))!, using: waterUseCase)
        setTotal(2500, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 10, hour: 9))!, using: waterUseCase)
        setTotal(2000, on: calendar.date(from: DateComponents(year: 2026, month: 3, day: 11, hour: 9))!, using: waterUseCase)
        setTotal(1000, on: referenceDate, using: waterUseCase)

        let viewModel = ChallengeViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadChallenges()

        #expect(viewModel.isEmpty == false)
        #expect(viewModel.currentStreak == 3)
        #expect(viewModel.weeklyAchievementRate == 0.75)
        #expect(viewModel.monthlyAchievementRate == (4.0 / 12.0))
        #expect(viewModel.streakSummary.badgeText == L10n.tr("challengeInProgressBadge"))
        #expect(viewModel.streakSummary.valueText == L10n.tr("challengeCurrentStreakValueFormat", 3))
        #expect(viewModel.streakSummary.description == L10n.tr("challengeRemainingDaysFormat", 4))
        #expect(viewModel.streakSummary.progress == (3.0 / 7.0))
        #expect(viewModel.streakSummary.metrics[0].detail == L10n.tr("challengeAchievementDaysFormat", 3, 4))
        #expect(viewModel.streakSummary.metrics[1].detail == L10n.tr("challengeAchievementDaysFormat", 4, 12))
    }

    @MainActor
    @Test("loadChallenges는 최근 기록이 없으면 empty state를 노출한다")
    func loadChallengesEmptyState() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let viewModel = ChallengeViewModel(
            waterUseCase: MockDrinkWaterUseCase(),
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadChallenges()

        #expect(viewModel.isEmpty == true)
        #expect(viewModel.currentStreak == 0)
        #expect(viewModel.streakSummary.valueText == L10n.tr("challengeCurrentStreakEmptyValue"))
    }

    @MainActor
    @Test("7일 streak를 채우면 완료 상태를 노출한다")
    func completedStreakChallenge() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let waterUseCase = MockDrinkWaterUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 2000

        for day in 6...12 {
            let date = calendar.date(from: DateComponents(year: 2026, month: 3, day: day, hour: 9))!
            setTotal(2000, on: date, using: waterUseCase)
        }

        let viewModel = ChallengeViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadChallenges()

        #expect(viewModel.currentStreak == 7)
        #expect(viewModel.streakSummary.badgeText == L10n.tr("challengeCompletedBadge"))
        #expect(viewModel.streakSummary.progress == 1)
        #expect(viewModel.streakSummary.description == L10n.tr("challengeCompletedDescription"))
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
