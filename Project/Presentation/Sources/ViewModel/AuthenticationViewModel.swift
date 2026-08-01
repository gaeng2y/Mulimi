//
//  AuthenticationViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation
import Observation

@Observable
public final class AuthenticationViewModel {
    public var isLoading: Bool = false
    public var errorMessage: String?

    private let signInUseCase: SignInUseCase
    private let analyticsUseCase: AnalyticsUseCase
    private let appSession: AppSession

    public var isAuthenticated: Bool {
        appSession.isAuthenticated
    }

    public init(
        signInUseCase: SignInUseCase,
        appSession: AppSession,
        analyticsUseCase: AnalyticsUseCase = NoOpAnalyticsUseCase()
    ) {
        self.signInUseCase = signInUseCase
        self.analyticsUseCase = analyticsUseCase
        self.appSession = appSession
        checkAuthenticationStatus()
    }

    public func checkAuthenticationStatus() {
        appSession.isAuthenticated = signInUseCase.isAuthenticated
        if appSession.isAuthenticated,
           let credential = signInUseCase.currentUserCredential() {
            analyticsUseCase.identify(userIdentifier: credential.userIdentifier)
        }
    }

    @MainActor
    public func signInWithApple() async {
        isLoading = true
        errorMessage = nil

        do {
            let credential = try await signInUseCase.signInWithApple()
            analyticsUseCase.identify(userIdentifier: credential.userIdentifier)
            appSession.isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func signOut() {
        signInUseCase.signOut()
        analyticsUseCase.reset()
        appSession.isAuthenticated = false
    }
}
