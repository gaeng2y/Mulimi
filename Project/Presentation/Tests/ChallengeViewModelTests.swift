import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("ChallengeViewModel Tests")
struct ChallengeViewModelTests {
    @MainActor
    @Test("loadChallenges는 진행 중 챌린지와 획득한 챌린지를 분리한다")
    func loadChallenges() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let progressUseCase = MockHydrationProgressUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            todayIntakeML: 1500,
            hasAchievedTodayGoal: false,
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
        let challengeUseCase = MockChallengeUseCase()
        challengeUseCase.challenges = [
            HydrationChallenge(
                kind: .streak7,
                progress: 3.0 / 7.0,
                currentValue: 3,
                targetValue: 7,
                primaryCurrentValue: 3,
                primaryTargetValue: 7,
                isCompleted: false,
                achievedAt: nil
            ),
            HydrationChallenge(
                kind: .weeklyAchievement80,
                progress: 1,
                currentValue: 0.8,
                targetValue: 0.8,
                primaryCurrentValue: 80,
                primaryTargetValue: 80,
                secondaryCurrentValue: 4,
                secondaryTargetValue: 5,
                isCompleted: true,
                achievedAt: calendar.date(from: DateComponents(year: 2026, month: 3, day: 11))
            ),
            HydrationChallenge(
                kind: .goalAchievement30,
                progress: 12.0 / 30.0,
                currentValue: 12,
                targetValue: 30,
                primaryCurrentValue: 12,
                primaryTargetValue: 30,
                isCompleted: false,
                achievedAt: nil
            )
        ]

        let viewModel = ChallengeViewModel(
            challengeUseCase: challengeUseCase,
            progressUseCase: progressUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadChallenges()

        #expect(viewModel.isEmpty == false)
        #expect(viewModel.inProgressChallenges.count == 2)
        #expect(viewModel.completedChallenges.count == 1)
        #expect(viewModel.inProgressChallenges.first?.kind == .streak7)
        #expect(viewModel.completedChallenges.first?.kind == .weeklyAchievement80)
        #expect(viewModel.completedChallenges.first?.badgeText == L10n.tr("challengeEarnedBadge"))
        #expect(viewModel.completedChallenges.first?.achievedAtText != nil)
        #expect(viewModel.inProgressChallenges.first?.description == L10n.tr("challengeRemainingDaysFormat", 4))
        #expect(viewModel.inProgressChallenges.first?.remainingConditionText == L10n.tr("challengeRemainingConditionDaysFormat", 4))
        #expect(viewModel.inProgressChallenges.first?.todayActionText == L10n.tr("challengeTodayActionStreakFormat", 4))
        #expect(viewModel.inProgressChallenges.last?.title == L10n.tr("challengeGoalCardTitle"))
        #expect(viewModel.inProgressChallenges.last?.todayActionText == L10n.tr("challengeTodayActionGoalFormat", 13, 30))
        #expect(challengeUseCase.requestedReferenceDate == referenceDate)
    }

    @MainActor
    @Test("loadChallenges는 최근 기록이 없으면 empty state를 노출한다")
    func loadChallengesEmptyState() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let progressUseCase = MockHydrationProgressUseCase()
        progressUseCase.snapshot = .empty(dailyGoalML: 2000)
        let challengeUseCase = MockChallengeUseCase()

        let viewModel = ChallengeViewModel(
            challengeUseCase: challengeUseCase,
            progressUseCase: progressUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadChallenges()

        #expect(viewModel.isEmpty == true)
        #expect(viewModel.inProgressChallenges.isEmpty)
        #expect(viewModel.completedChallenges.isEmpty)
        #expect(challengeUseCase.requestedReferenceDate == nil)
    }

    @MainActor
    @Test("획득한 챌린지는 최근 획득 순으로 정렬한다")
    func completedChallengesAreSortedByAchievedAt() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let progressUseCase = MockHydrationProgressUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            todayIntakeML: 2100,
            hasAchievedTodayGoal: true,
            weeklyAverageML: 2000,
            monthlyAverageML: 2000,
            weeklyAchievementRate: 1,
            monthlyAchievementRate: 1,
            weeklyAchievedDays: 7,
            monthlyAchievedDays: 20,
            weeklyElapsedDays: 7,
            monthlyElapsedDays: 20,
            currentStreak: 7,
            isEmpty: false
        )
        let challengeUseCase = MockChallengeUseCase()
        challengeUseCase.challenges = [
            HydrationChallenge(
                kind: .goalAchievement30,
                progress: 1,
                currentValue: 30,
                targetValue: 30,
                primaryCurrentValue: 30,
                primaryTargetValue: 30,
                isCompleted: true,
                achievedAt: calendar.date(from: DateComponents(year: 2026, month: 3, day: 10))
            ),
            HydrationChallenge(
                kind: .streak7,
                progress: 1,
                currentValue: 7,
                targetValue: 7,
                primaryCurrentValue: 7,
                primaryTargetValue: 7,
                isCompleted: true,
                achievedAt: calendar.date(from: DateComponents(year: 2026, month: 3, day: 12))
            )
        ]

        let viewModel = ChallengeViewModel(
            challengeUseCase: challengeUseCase,
            progressUseCase: progressUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadChallenges()

        #expect(
            viewModel.completedChallenges.map { $0.kind } == [
                HydrationChallengeKind.streak7,
                HydrationChallengeKind.goalAchievement30
            ]
        )
        #expect(viewModel.completedChallenges.first?.description == L10n.tr("challengeCompletedDescription"))
    }

    @MainActor
    @Test("오늘 목표를 이미 달성했으면 오늘 액션 문구를 완료 상태로 노출한다")
    func todayActionAlreadyDone() async {
        let calendar = makeCalendar()
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 12, hour: 9))!
        let progressUseCase = MockHydrationProgressUseCase()
        progressUseCase.snapshot = HydrationProgressSnapshot(
            dailyGoalML: 2000,
            todayIntakeML: 2200,
            hasAchievedTodayGoal: true,
            weeklyAverageML: 2100,
            monthlyAverageML: 1800,
            weeklyAchievementRate: 0.75,
            monthlyAchievementRate: 0.5,
            weeklyAchievedDays: 3,
            monthlyAchievedDays: 10,
            weeklyElapsedDays: 4,
            monthlyElapsedDays: 12,
            currentStreak: 4,
            isEmpty: false
        )
        let challengeUseCase = MockChallengeUseCase()
        challengeUseCase.challenges = [
            HydrationChallenge(
                kind: .goalAchievement30,
                progress: 12.0 / 30.0,
                currentValue: 12,
                targetValue: 30,
                primaryCurrentValue: 12,
                primaryTargetValue: 30,
                isCompleted: false,
                achievedAt: nil
            ),
            HydrationChallenge(
                kind: .weeklyAchievement80,
                progress: 0.75 / 0.8,
                currentValue: 0.75,
                targetValue: 0.8,
                primaryCurrentValue: 75,
                primaryTargetValue: 80,
                secondaryCurrentValue: 3,
                secondaryTargetValue: 4,
                isCompleted: false,
                achievedAt: nil
            )
        ]

        let viewModel = ChallengeViewModel(
            challengeUseCase: challengeUseCase,
            progressUseCase: progressUseCase,
            calendar: calendar,
            currentDateProvider: { referenceDate }
        )

        await viewModel.loadChallenges()

        let weeklyCard = viewModel.inProgressChallenges.first { $0.kind == .weeklyAchievement80 }
        let goalCard = viewModel.inProgressChallenges.first { $0.kind == .goalAchievement30 }

        #expect(weeklyCard?.todayActionCompleted == true)
        #expect(weeklyCard?.todayActionText == L10n.tr("challengeTodayActionAlreadyDoneWeeklyFormat", 3, 4))
        #expect(goalCard?.todayActionText == L10n.tr("challengeTodayActionAlreadyDoneGoalFormat", 12, 30))
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
