import AccountDomain
import MulimiAnalytics
import HydrationDomain
import RoutineDomain
import Foundation
import Localization
import Testing

@testable import HydrationPresentation

@Suite("HydrationGoalRecommendationViewModel Tests")
struct HydrationGoalRecommendationViewModelTests {
    @MainActor
    @Test("준비 가능 상태를 로드한다")
    func loadReadyState() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        useCase.availabilityValue = .ready

        let viewModel = makeViewModel(useCase: useCase)

        await viewModel.load()

        #expect(viewModel.state == .ready)
        #expect(viewModel.recommendation == nil)
        #expect(useCase.availabilityCallCount == 1)
    }

    @MainActor
    @Test("신체 정보가 부족하면 입력 유도 상태를 노출한다")
    func loadBodyProfileRequiredState() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        useCase.availabilityValue = .bodyProfileRequired(.incomplete)

        let viewModel = makeViewModel(useCase: useCase)

        await viewModel.load()

        #expect(viewModel.state == .bodyProfileRequired(.incomplete))
    }

    @MainActor
    @Test("추천 생성 성공 시 결과를 저장한다")
    func generateRecommendationSuccess() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        let viewModel = makeViewModel(useCase: useCase)

        await viewModel.generateRecommendation()

        #expect(viewModel.state == .ready)
        #expect(viewModel.recommendation?.recommendedLimitML == 2_250)
        #expect(viewModel.errorMessage == nil)
        #expect(useCase.generateRecommendationCallCount == 1)
    }

    @MainActor
    @Test("추천 생성 실패 시 공통 에러 메시지를 노출한다")
    func generateRecommendationFailure() async {
        struct DummyError: Error {}

        let useCase = MockHydrationGoalRecommendationUseCase()
        useCase.generateError = DummyError()

        let viewModel = makeViewModel(useCase: useCase)

        await viewModel.generateRecommendation()

        #expect(viewModel.recommendation == nil)
        #expect(
            viewModel.errorMessage == L10n.tr("hydrationGoalRecommendationGenerationFailureDescription")
        )
    }

    @MainActor
    @Test("진입 목적지는 신체 정보 필요 상태에서만 신체 정보 화면으로 분기한다")
    func entryDestinationPerState() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        let viewModel = makeViewModel(useCase: useCase)

        useCase.availabilityValue = .bodyProfileRequired(.needsPermission)
        await viewModel.load()

        #expect(viewModel.entryDestination == .bodyProfileSetting)

        useCase.availabilityValue = .ready
        await viewModel.load()

        #expect(viewModel.entryDestination == .dailyLimitSetting)

        useCase.availabilityValue = .modelUnavailable(.deviceNotEligible)
        await viewModel.load()

        #expect(viewModel.entryDestination == .dailyLimitSetting)
    }

    @MainActor
    @Test("진입 문구는 신체 정보/권한/모델 상태에 맞게 달라진다")
    func entryDescriptionPerState() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        let viewModel = makeViewModel(useCase: useCase)

        useCase.availabilityValue = .bodyProfileRequired(.needsPermission)
        await viewModel.load()

        #expect(
            viewModel.entryDescription
                == L10n.tr("profileGoalRecommendationEntryConnectHealthDescription")
        )

        useCase.availabilityValue = .bodyProfileRequired(.incomplete)
        await viewModel.load()

        #expect(
            viewModel.entryDescription
                == L10n.tr("profileGoalRecommendationEntryBodyProfileDescription")
        )

        useCase.availabilityValue = .modelUnavailable(.deviceNotEligible)
        await viewModel.load()

        #expect(
            viewModel.entryDescription
                == L10n.tr("profileGoalRecommendationEntryUnavailableDescription")
        )

        useCase.availabilityValue = .ready
        await viewModel.load()

        #expect(
            viewModel.entryDescription
                == L10n.tr("profileGoalRecommendationEntryDefaultDescription")
        )
    }

    @MainActor
    @Test("진입 문구는 목표 부족/초과 상태를 반영한다")
    func entryDescriptionReflectsGoalAlignment() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        useCase.availabilityValue = .ready
        let progressUseCase = MockHydrationProgressUseCase()
        let viewModel = makeViewModel(useCase: useCase, progressUseCase: progressUseCase)

        progressUseCase.snapshot = makeSnapshot(dailyGoalML: 2_000, weeklyAverageML: 1_000)
        await viewModel.load()

        #expect(viewModel.goalAlignment == .belowGoal)
        #expect(
            viewModel.entryDescription
                == L10n.tr("profileGoalRecommendationEntryBelowGoalDescription")
        )

        progressUseCase.snapshot = makeSnapshot(dailyGoalML: 2_000, weeklyAverageML: 2_400)
        await viewModel.load()

        #expect(viewModel.goalAlignment == .aboveGoal)
        #expect(
            viewModel.entryDescription
                == L10n.tr("profileGoalRecommendationEntryAboveGoalDescription")
        )

        progressUseCase.snapshot = makeSnapshot(dailyGoalML: 2_000, weeklyAverageML: 2_000)
        await viewModel.load()

        #expect(viewModel.goalAlignment == .aligned)
        #expect(
            viewModel.entryDescription
                == L10n.tr("profileGoalRecommendationEntryDefaultDescription")
        )
    }

    @MainActor
    @Test("기록이 없거나 표본 일수가 부족하면 목표 정렬 상태를 판단하지 않는다")
    func goalAlignmentRequiresEnoughData() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        let progressUseCase = MockHydrationProgressUseCase()
        let viewModel = makeViewModel(useCase: useCase, progressUseCase: progressUseCase)

        await viewModel.load()

        #expect(viewModel.goalAlignment == .unknown)

        progressUseCase.snapshot = makeSnapshot(
            dailyGoalML: 2_000,
            weeklyAverageML: 1_000,
            weeklyElapsedDays: 2
        )
        await viewModel.load()

        #expect(viewModel.goalAlignment == .unknown)
    }

    @MainActor
    private func makeViewModel(
        useCase: MockHydrationGoalRecommendationUseCase,
        progressUseCase: MockHydrationProgressUseCase = MockHydrationProgressUseCase()
    ) -> HydrationGoalRecommendationViewModel {
        HydrationGoalRecommendationViewModel(
            useCase: useCase,
            progressUseCase: progressUseCase
        )
    }

    private func makeSnapshot(
        dailyGoalML: Double,
        weeklyAverageML: Double,
        weeklyElapsedDays: Int = 4
    ) -> HydrationProgressSnapshot {
        HydrationProgressSnapshot(
            dailyGoalML: dailyGoalML,
            weeklyAverageML: weeklyAverageML,
            monthlyAverageML: weeklyAverageML,
            weeklyAchievementRate: 0,
            monthlyAchievementRate: 0,
            weeklyAchievedDays: 0,
            monthlyAchievedDays: 0,
            weeklyElapsedDays: weeklyElapsedDays,
            monthlyElapsedDays: 12,
            currentStreak: 0,
            isEmpty: false
        )
    }
}
