//
//  AuthenticationViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Combine
import DomainLayerInterface
import Foundation

@MainActor
public class AuthenticationViewModel: ObservableObject {
    @Published public var isAuthenticated: Bool = false
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?

    private let signInUseCase: SignInUseCase

    public init(signInUseCase: SignInUseCase) {
        self.signInUseCase = signInUseCase
        checkAuthenticationStatus()
    }

    public func checkAuthenticationStatus() {
        isAuthenticated = signInUseCase.isAuthenticated()
    }

    public func signInWithApple() async {
        isLoading = true
        errorMessage = nil

        do {
            try await signInUseCase.signInWithApple()
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func signOut() {
        signInUseCase.signOut()
        isAuthenticated = false
    }
}
