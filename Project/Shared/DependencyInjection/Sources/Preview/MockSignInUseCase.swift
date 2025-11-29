//
//  MockSignInUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Assistant on 2025-01-29.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface

public final class MockSignInUseCase: SignInUseCase {
    public var isAuthenticated: Bool = true

    public init() {}

    public func signInWithApple() async throws {
        isAuthenticated = true
    }

    public func signOut() {
        isAuthenticated = false
    }

    public func deleteAccount() async throws {
        isAuthenticated = false
    }
}
