import Testing

@testable import PresentationLayer

@Suite("OnboardingViewModel Tests")
struct OnboardingViewModelTests {
    @MainActor
    @Test("초기 상태는 저장된 온보딩 완료 여부를 반영한다")
    func initializeState() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.hasCompletedOnboardingValue = true

        let viewModel = OnboardingViewModel(userPreferencesUseCase: userPreferencesUseCase)

        #expect(viewModel.hasCompletedOnboarding == true)
        #expect(viewModel.currentPage == 0)
    }

    @MainActor
    @Test("goToNextPage는 마지막 페이지 전까지 페이지를 이동한다")
    func advancePage() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        let viewModel = OnboardingViewModel(userPreferencesUseCase: userPreferencesUseCase)

        viewModel.goToNextPage()
        viewModel.goToNextPage()

        #expect(viewModel.currentPage == 2)
        #expect(viewModel.isLastPage == true)
        #expect(userPreferencesUseCase.setHasCompletedOnboardingCallCount == 0)
    }

    @MainActor
    @Test("마지막 페이지에서 다음을 누르면 온보딩을 완료 처리한다")
    func completeOnboardingFromLastPage() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        let viewModel = OnboardingViewModel(userPreferencesUseCase: userPreferencesUseCase)

        viewModel.currentPage = 2
        viewModel.goToNextPage()

        #expect(viewModel.hasCompletedOnboarding == true)
        #expect(userPreferencesUseCase.setHasCompletedOnboardingCallCount == 1)
        #expect(userPreferencesUseCase.capturedHasCompletedOnboarding == true)
        #expect(viewModel.currentPage == 0)
    }

    @MainActor
    @Test("prepareForSignedOutState는 온보딩 상태를 다시 읽고 페이지를 처음으로 되돌린다")
    func prepareForSignedOutStateResetsProgress() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        let viewModel = OnboardingViewModel(userPreferencesUseCase: userPreferencesUseCase)

        viewModel.currentPage = 2
        userPreferencesUseCase.hasCompletedOnboardingValue = false

        viewModel.prepareForSignedOutState()

        #expect(viewModel.currentPage == 0)
        #expect(viewModel.hasCompletedOnboarding == false)
        #expect(userPreferencesUseCase.hasCompletedOnboardingCallCount == 2)
    }
}
