import DomainLayerInterface
import Foundation
import SwiftUI
import Testing

@testable import PresentationLayer

@Suite("SettingsViewModel Tests")
struct SettingsViewModelTests {
    private final class SpySettingsRouting: SettingsRouting {
        var path = NavigationPath()
        var hasPath: Bool { !path.isEmpty }
        private(set) var pushedRoutes: [SettingsRoute] = []
        private(set) var popCallCount = 0
        private(set) var resetCallCount = 0
        private(set) var handledDeepLinks: [URL] = []

        func push(_ route: SettingsRoute) {
            pushedRoutes.append(route)
            path.append(route)
        }

        func pop() {
            popCallCount += 1
            if !path.isEmpty {
                path.removeLast()
            }
        }

        func reset() {
            resetCallCount += 1
            path = NavigationPath()
        }

        func handleDeepLink(_ url: URL) {
            handledDeepLinks.append(url)
        }
    }

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
        let settingsRouting = SpySettingsRouting()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.mainAppearanceValue = .heart
        userPreferencesUseCase.dailyWaterLimitValue = 2100
        let signInUseCase = MockSignInUseCase()
        let authenticationViewModel = AuthenticationViewModel(signInUseCase: signInUseCase)

        let viewModel = SettingsViewModel(
            settingsRouting: settingsRouting,
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
    @Test("navigate/navigateBack/resetNavigation은 settingsPath를 제어한다")
    func navigationActions() {
        let settingsRouting = SpySettingsRouting()
        let viewModel = SettingsViewModel(
            settingsRouting: settingsRouting,
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            signInUseCase: MockSignInUseCase(),
            authenticationViewModel: AuthenticationViewModel(signInUseCase: MockSignInUseCase()),
            appVersion: "1.2.0",
            appBuildNumber: "15"
        )

        viewModel.navigate(to: .dailyLimit)
        #expect(viewModel.hasNavigationPath == true)
        #expect(settingsRouting.path.count == 1)
        #expect(settingsRouting.pushedRoutes == [.dailyLimit])

        viewModel.navigateBack()
        #expect(viewModel.hasNavigationPath == false)
        #expect(settingsRouting.path.count == 0)
        #expect(settingsRouting.popCallCount == 1)

        viewModel.navigate(to: .mainShape)
        viewModel.resetNavigation()
        #expect(viewModel.hasNavigationPath == false)
        #expect(settingsRouting.path.count == 0)
        #expect(settingsRouting.resetCallCount == 1)
    }

    @MainActor
    @Test("setMainAppearance는 상태와 UseCase를 함께 갱신한다")
    func setMainAppearance() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        let viewModel = SettingsViewModel(
            settingsRouting: SpySettingsRouting(),
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
            settingsRouting: SpySettingsRouting(),
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
            settingsRouting: SpySettingsRouting(),
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
            settingsRouting: SpySettingsRouting(),
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
            settingsRouting: SpySettingsRouting(),
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
