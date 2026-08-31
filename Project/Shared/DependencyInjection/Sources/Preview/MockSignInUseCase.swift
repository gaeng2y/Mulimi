//
//  MockSignInUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Assistant on 2025-01-29.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import AccountDomain
import ChallengeDomain
import MulimiAnalytics
import HydrationDomain
import RoutineDomain

public final class MockSignInUseCase: SignInUseCase, @unchecked Sendable {
    public var isAuthenticated: Bool = true
    private let credential = UserCredential(
        userIdentifier: "preview-user-id",
        email: nil,
        name: nil
    )

    public init() {}

    public func currentUserCredential() -> UserCredential? {
        isAuthenticated ? credential : nil
    }

    public func signInWithApple() async throws -> UserCredential {
        isAuthenticated = true
        return credential
    }

    public func signOut() {
        isAuthenticated = false
    }

    public func deleteAccount() async throws {
        isAuthenticated = false
    }
}
