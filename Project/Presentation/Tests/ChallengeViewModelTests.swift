import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("ChallengeViewModel Tests")
struct ChallengeViewModelTests {
    @MainActor
    @Test("loadChallenges는 진행 스냅샷을 챌린지 상태로 매핑한다")
    func loadChallenges() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let progressUseCase = MockHydrationProgressUseCase()
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

        let viewModel = ChallengeViewModel(
            progressUseCase: progressUseCase,
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
        #expect(progressUseCase.requestedReferenceDate == referenceDate)
    }

    @MainActor
    @Test("loadChallenges는 최근 기록이 없으면 empty state를 노출한다")
    func loadChallengesEmptyState() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let progressUseCase = MockHydrationProgressUseCase()
        progressUseCase.snapshot = .empty(dailyGoalML: 2000)

        let viewModel = ChallengeViewModel(
            progressUseCase: progressUseCase,
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
        let progressUseCase = MockHydrationProgressUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            weeklyAverageML: 2000,
            monthlyAverageML: 2000,
            weeklyAchievementRate: 1,
            monthlyAchievementRate: 1,
            weeklyAchievedDays: 7,
            monthlyAchievedDays: 12,
            weeklyElapsedDays: 7,
            monthlyElapsedDays: 12,
            currentStreak: 7,
            isEmpty: false
        )

        let viewModel = ChallengeViewModel(
            progressUseCase: progressUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadChallenges()

        #expect(viewModel.currentStreak == 7)
        #expect(viewModel.streakSummary.badgeText == L10n.tr("challengeCompletedBadge"))
        #expect(viewModel.streakSummary.progress == 1)
        #expect(viewModel.streakSummary.description == L10n.tr("challengeCompletedDescription"))
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
