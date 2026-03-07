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
    public var isAuthenticated: Bool = false
    public var isLoading: Bool = false
    public var errorMessage: String?
    
    private let signInUseCase: SignInUseCase
    
    public init(signInUseCase: SignInUseCase) {
        self.signInUseCase = signInUseCase
        checkAuthenticationStatus()
    }
    
    public func checkAuthenticationStatus() {
        isAuthenticated = signInUseCase.isAuthenticated
    }
    
    @MainActor
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
