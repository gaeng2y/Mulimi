import DomainLayerInterface
import Foundation

final class MockSignInUseCase: SignInUseCase, @unchecked Sendable {
    var isAuthenticatedValue: Bool = false

    var signInWithAppleCallCount: Int = 0
    var signOutCallCount: Int = 0
    var deleteAccountCallCount: Int = 0

    var signInError: Error?
    var deleteAccountError: Error?
    var currentCredential: UserCredential?
    var signInCredentialToReturn = UserCredential(
        userIdentifier: "mock-user-id",
        email: nil,
        name: nil
    )

    var isAuthenticated: Bool {
        isAuthenticatedValue
    }

    func currentUserCredential() -> UserCredential? {
        currentCredential
    }

    func signInWithApple() async throws -> UserCredential {
        signInWithAppleCallCount += 1
        if let signInError {
            throw signInError
        }
        isAuthenticatedValue = true
        currentCredential = signInCredentialToReturn
        return signInCredentialToReturn
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
