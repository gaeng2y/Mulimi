//
//  MockAuthenticationRepository.swift
//  DomainLayerTests
//
//  Created by Codex on 3/11/26.
//

import DomainLayerInterface
import Foundation

final class MockAuthenticationRepository: AuthenticationRepository, @unchecked Sendable {
    var isAuthenticatedValue: Bool = false

    private(set) var signInWithAppleCallCount = 0
    private(set) var signOutCallCount = 0
    private(set) var deleteAccountCallCount = 0

    var signInError: Error?
    var deleteAccountError: Error?
    var signInCredentialToReturn = UserCredential(
        userIdentifier: "mock-user-id",
        email: "mock@example.com",
        name: "Mock User"
    )

    var isAuthenticated: Bool {
        isAuthenticatedValue
    }

    func signInWithApple() async throws -> UserCredential {
        signInWithAppleCallCount += 1

        if let signInError {
            throw signInError
        }

        isAuthenticatedValue = true
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
