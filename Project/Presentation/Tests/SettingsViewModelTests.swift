import DomainLayerInterface
import Foundation
import Testing

@testable import PresentationLayer

@Suite("SettingsViewModel Tests")
struct SettingsViewModelTests {
    private enum MockError: LocalizedError {
        case deleteFailed

        var errorDescription: String? {
            switch self {
            case .deleteFailed:
                return "delete-failed"
            }
        }
    }

    @MainActor
    @Test("초기화 시 사용자 설정 상태를 반영한다")
    func initializeState() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.mainAppearanceValue = .heart
        userPreferencesUseCase.dailyWaterLimitValue = 2100
        let signInUseCase = MockSignInUseCase()
        let authenticationViewModel = AuthenticationViewModel(signInUseCase: signInUseCase)

        let viewModel = SettingsViewModel(
            userPreferencesUseCase: userPreferencesUseCase,
            signInUseCase: signInUseCase,
            authenticationViewModel: authenticationViewModel,
            appVersion: "1.2.0",
            appBuildNumber: "15"
        )

        #expect(viewModel.currentMainAppearance == .heart)
        #expect(viewModel.currentDailyWaterLimit == 2100)
        #expect(viewModel.appVersion == "1.2.0")
        #expect(viewModel.appBuildNumber == "15")
        #expect(userPreferencesUseCase.getMainAppearanceCallCount == 1)
        #expect(userPreferencesUseCase.getDailyWaterLimitCallCount == 1)
    }

    @MainActor
    @Test("setMainAppearance는 상태와 UseCase를 함께 갱신한다")
    func setMainAppearance() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: userPreferencesUseCase,
            signInUseCase: MockSignInUseCase(),
            authenticationViewModel: AuthenticationViewModel(signInUseCase: MockSignInUseCase()),
            appVersion: "1.2.0",
            appBuildNumber: "15"
        )

        viewModel.setMainAppearance(.cloud)

        #expect(viewModel.currentMainAppearance == .cloud)
        #expect(userPreferencesUseCase.setMainAppearanceCallCount == 1)
        #expect(userPreferencesUseCase.capturedMainAppearance == .cloud)
    }

    @MainActor
    @Test("dailyWaterLimit setter는 상태와 UseCase를 함께 갱신한다")
    func setDailyWaterLimit() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: userPreferencesUseCase,
            signInUseCase: MockSignInUseCase(),
            authenticationViewModel: AuthenticationViewModel(signInUseCase: MockSignInUseCase()),
            appVersion: "1.2.0",
            appBuildNumber: "15"
        )

        viewModel.dailyWaterLimit = 2750

        #expect(viewModel.currentDailyWaterLimit == 2750)
        #expect(userPreferencesUseCase.setDailyWaterLimitCallCount == 1)
        #expect(userPreferencesUseCase.capturedDailyWaterLimit == 2750)
    }

    @MainActor
    @Test("requestWithdrawal/cancelWithdrawal은 확인 상태를 토글한다")
    func withdrawalRequestAndCancel() {
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            signInUseCase: MockSignInUseCase(),
            authenticationViewModel: AuthenticationViewModel(signInUseCase: MockSignInUseCase()),
            appVersion: "1.2.0",
            appBuildNumber: "15"
        )

        viewModel.requestWithdrawal()
        #expect(viewModel.showWithdrawalConfirmation == true)

        viewModel.withdrawalError = "temporary-error"
        viewModel.cancelWithdrawal()
        #expect(viewModel.showWithdrawalConfirmation == false)
        #expect(viewModel.withdrawalError == nil)
    }

    @MainActor
    @Test("confirmWithdrawal 성공 시 인증 상태를 false로 전환한다")
    func confirmWithdrawalSuccess() async {
        let signInUseCase = MockSignInUseCase()
        signInUseCase.isAuthenticatedValue = true
        let authenticationViewModel = AuthenticationViewModel(signInUseCase: signInUseCase)
        authenticationViewModel.isAuthenticated = true
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            signInUseCase: signInUseCase,
            authenticationViewModel: authenticationViewModel,
            appVersion: "1.2.0",
            appBuildNumber: "15"
        )
        viewModel.requestWithdrawal()

        await viewModel.confirmWithdrawal()

        #expect(signInUseCase.deleteAccountCallCount == 1)
        #expect(viewModel.isWithdrawing == false)
        #expect(viewModel.showWithdrawalConfirmation == false)
        #expect(viewModel.withdrawalError == nil)
        #expect(authenticationViewModel.isAuthenticated == false)
    }

    @MainActor
    @Test("confirmWithdrawal 실패 시 에러를 노출하고 인증 상태를 유지한다")
    func confirmWithdrawalFailure() async {
        let signInUseCase = MockSignInUseCase()
        signInUseCase.deleteAccountError = MockError.deleteFailed
        let authenticationViewModel = AuthenticationViewModel(signInUseCase: signInUseCase)
        authenticationViewModel.isAuthenticated = true
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            signInUseCase: signInUseCase,
            authenticationViewModel: authenticationViewModel,
            appVersion: "1.2.0",
            appBuildNumber: "15"
        )
        viewModel.requestWithdrawal()

        await viewModel.confirmWithdrawal()

        #expect(signInUseCase.deleteAccountCallCount == 1)
        #expect(viewModel.isWithdrawing == false)
        #expect(viewModel.showWithdrawalConfirmation == true)
        #expect(viewModel.withdrawalError == MockError.deleteFailed.localizedDescription)
        #expect(authenticationViewModel.isAuthenticated == true)
    }
}
