import DomainLayerInterface
import Localization
import Testing

@testable import PresentationLayer

@Suite("HydrationGoalRecommendationViewModel Tests")
struct HydrationGoalRecommendationViewModelTests {
    @MainActor
    @Test("준비 가능 상태를 로드한다")
    func loadReadyState() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        useCase.availabilityValue = .ready

        let viewModel = HydrationGoalRecommendationViewModel(useCase: useCase)

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

        let viewModel = HydrationGoalRecommendationViewModel(useCase: useCase)

        await viewModel.load()

        #expect(viewModel.state == .bodyProfileRequired(.incomplete))
    }

    @MainActor
    @Test("추천 생성 성공 시 결과를 저장한다")
    func generateRecommendationSuccess() async {
        let useCase = MockHydrationGoalRecommendationUseCase()
        let viewModel = HydrationGoalRecommendationViewModel(useCase: useCase)

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

        let viewModel = HydrationGoalRecommendationViewModel(useCase: useCase)

        await viewModel.generateRecommendation()

        #expect(viewModel.recommendation == nil)
        #expect(
            viewModel.errorMessage == L10n.tr("hydrationGoalRecommendationGenerationFailureDescription")
        )
    }
}
