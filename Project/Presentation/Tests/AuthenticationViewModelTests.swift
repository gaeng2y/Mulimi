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
        let appSession = AppSession()

        let viewModel = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: appSession
        )

        #expect(viewModel.isAuthenticated == true)
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
        let viewModel = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: AppSession()
        )

        await viewModel.signInWithApple()

        #expect(mockSignInUseCase.signInWithAppleCallCount == 1)
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
        let viewModel = AuthenticationViewModel(
            signInUseCase: mockSignInUseCase,
            appSession: AppSession()
        )

        viewModel.signOut()

        #expect(mockSignInUseCase.signOutCallCount == 1)
        #expect(viewModel.isAuthenticated == false)
    }
}
