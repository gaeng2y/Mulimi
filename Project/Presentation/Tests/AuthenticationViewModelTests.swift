import DomainLayerInterface
import Foundation
import Testing

@testable import PresentationLayer

@Suite("AuthenticationViewModel Tests")
struct AuthenticationViewModelTests {
    private enum MockError: LocalizedError {
        case signInFailed

        var errorDescription: String? {
            switch self {
            case .signInFailed:
                return "sign-in-failed"
            }
        }
    }

    @MainActor
    @Test("초기 인증 상태는 UseCase 상태를 반영한다")
    func initializeAuthenticationState() {
        let mockSignInUseCase = MockSignInUseCase()
        mockSignInUseCase.isAuthenticatedValue = true
        mockSignInUseCase.currentCredential = mockSignInUseCase.signInCredentialToReturn
        let analyticsUseCase = MockAnalyticsUseCase()
        let appSession = AppSession()

        let viewModel = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: appSession,
            analyticsUseCase: analyticsUseCase
        )

        #expect(viewModel.isAuthenticated == true)
        #expect(analyticsUseCase.identifiedUserIdentifiers == [mockSignInUseCase.signInCredentialToReturn.userIdentifier])
    }

    @MainActor
    @Test("인증되지 않은 복원 세션은 사용자를 식별하지 않는다")
    func unauthenticatedSessionDoesNotIdentify() {
        let mockSignInUseCase = MockSignInUseCase()
        mockSignInUseCase.currentCredential = mockSignInUseCase.signInCredentialToReturn
        let analyticsUseCase = MockAnalyticsUseCase()

        _ = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: AppSession(),
            analyticsUseCase: analyticsUseCase
        )

        #expect(analyticsUseCase.identifiedUserIdentifiers.isEmpty)
    }

    @MainActor
    @Test("checkAuthenticationStatus는 최신 인증 상태를 반영한다")
    func checkAuthenticationStatus() {
        let mockSignInUseCase = MockSignInUseCase()
        mockSignInUseCase.isAuthenticatedValue = false
        let appSession = AppSession()
        let viewModel = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: appSession
        )

        mockSignInUseCase.isAuthenticatedValue = true
        viewModel.checkAuthenticationStatus()

        #expect(viewModel.isAuthenticated == true)
    }

    @MainActor
    @Test("signInWithApple 성공 시 인증 상태가 true가 된다")
    func signInWithAppleSuccess() async {
        let mockSignInUseCase = MockSignInUseCase()
        let analyticsUseCase = MockAnalyticsUseCase()
        let viewModel = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: AppSession(),
            analyticsUseCase: analyticsUseCase
        )

        await viewModel.signInWithApple()

        #expect(mockSignInUseCase.signInWithAppleCallCount == 1)
        #expect(analyticsUseCase.identifiedUserIdentifiers == [mockSignInUseCase.signInCredentialToReturn.userIdentifier])
        #expect(viewModel.isAuthenticated == true)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == nil)
    }

    @MainActor
    @Test("signInWithApple 실패 시 에러 메시지를 노출한다")
    func signInWithAppleFailure() async {
        let mockSignInUseCase = MockSignInUseCase()
        mockSignInUseCase.signInError = MockError.signInFailed
        let viewModel = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: AppSession()
        )

        await viewModel.signInWithApple()

        #expect(mockSignInUseCase.signInWithAppleCallCount == 1)
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.errorMessage == MockError.signInFailed.localizedDescription)
    }

    @MainActor
    @Test("signOut 호출 시 UseCase와 상태가 함께 갱신된다")
    func signOut() {
        let mockSignInUseCase = MockSignInUseCase()
        mockSignInUseCase.isAuthenticatedValue = true
        let analyticsUseCase = MockAnalyticsUseCase()
        let viewModel = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: AppSession(),
            analyticsUseCase: analyticsUseCase
        )

        viewModel.signOut()

        #expect(mockSignInUseCase.signOutCallCount == 1)
        #expect(analyticsUseCase.resetCallCount == 1)
        #expect(viewModel.isAuthenticated == false)
    }
}
