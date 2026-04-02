//
//  RootView.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI

public struct RootView<Content: View>: View {
    @State private var authenticationViewModel: AuthenticationViewModel
    @State private var onboardingViewModel: OnboardingViewModel
    @State private var healthKitPermissionViewModel: HealthKitPermissionViewModel
    private let content: () -> Content
    
    public init(
        authenticationViewModel: @autoclosure @escaping () -> AuthenticationViewModel,
        onboardingViewModel: @autoclosure @escaping () -> OnboardingViewModel,
        healthKitPermissionViewModel: @autoclosure @escaping () -> HealthKitPermissionViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._authenticationViewModel = State(wrappedValue: authenticationViewModel())
        self._onboardingViewModel = State(wrappedValue: onboardingViewModel())
        self._healthKitPermissionViewModel = State(wrappedValue: healthKitPermissionViewModel())
        self.content = content
    }
    
    public var body: some View {
        Group {
            if authenticationViewModel.isAuthenticated {
                if onboardingViewModel.hasCompletedOnboarding {
                    HealthKitPermissionGateView(viewModel: healthKitPermissionViewModel) {
                        content()
                    }
                } else {
                    OnboardingView(viewModel: onboardingViewModel)
                }
            } else {
                SignInView(viewModel: authenticationViewModel)
                    .onAppear {
                        onboardingViewModel.refreshState()
                        healthKitPermissionViewModel.markSignedOut()
                    }
            }
        }
    }
}
