//
//  SignInUseCaseImpl.swift
//  DomainLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

public struct SignInUseCaseImpl: SignInUseCase {
    private let repository: AuthenticationRepository

    public init(repository: AuthenticationRepository) {
        self.repository = repository
    }

    public var isAuthenticated: Bool {
        repository.isAuthenticated
    }

    public func signInWithApple() async throws {
        _ = try await repository.signInWithApple()
    }

    public func signOut() {
        repository.signOut()
    }

    public func deleteAccount() async throws {
        try await repository.deleteAccount()
    }
}
