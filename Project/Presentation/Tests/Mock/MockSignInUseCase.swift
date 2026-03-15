import DomainLayerInterface
import Foundation

final class MockSignInUseCase: SignInUseCase, @unchecked Sendable {
    var isAuthenticatedValue: Bool = false

    var signInWithAppleCallCount: Int = 0
    var signOutCallCount: Int = 0
    var deleteAccountCallCount: Int = 0

    var signInError: Error?
    var deleteAccountError: Error?

    var isAuthenticated: Bool {
        isAuthenticatedValue
    }

    func signInWithApple() async throws {
        signInWithAppleCallCount += 1
        if let signInError {
            throw signInError
        }
        isAuthenticatedValue = true
    }

    func signOut() {
        signOutCallCount += 1
        isAuthenticatedValue = false
    }

    func deleteAccount() async throws {
        deleteAccountCallCount += 1
        if let deleteAccountError {
            throw deleteAccountError
        }
        isAuthenticatedValue = false
    }
}
