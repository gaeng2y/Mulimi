//
//  RootView.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI

public struct RootView<Content: View>: View {
    @State private var appSession: AppSession
    @State private var authenticationViewModel: AuthenticationViewModel
    @State private var onboardingViewModel: OnboardingViewModel
    @State private var hydrationReminderPermissionViewModel: HydrationReminderPermissionViewModel
    @State private var healthKitPermissionViewModel: HealthKitPermissionViewModel
    private let content: () -> Content

    public init(
        appSession: @autoclosure @escaping () -> AppSession,
        authenticationViewModel: @autoclosure @escaping () -> AuthenticationViewModel,
        onboardingViewModel: @autoclosure @escaping () -> OnboardingViewModel,
        hydrationReminderPermissionViewModel: @autoclosure @escaping () -> HydrationReminderPermissionViewModel,
        healthKitPermissionViewModel: @autoclosure @escaping () -> HealthKitPermissionViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._appSession = State(wrappedValue: appSession())
        self._authenticationViewModel = State(wrappedValue: authenticationViewModel())
        self._onboardingViewModel = State(wrappedValue: onboardingViewModel())
        self._hydrationReminderPermissionViewModel = State(
            wrappedValue: hydrationReminderPermissionViewModel()
        )
        self._healthKitPermissionViewModel = State(wrappedValue: healthKitPermissionViewModel())
        self.content = content
    }

    public var body: some View {
        Group {
            if appSession.isAuthenticated {
                if onboardingViewModel.hasCompletedOnboarding {
                    HydrationReminderPermissionGateView(viewModel: hydrationReminderPermissionViewModel) {
                        HealthKitPermissionGateView(viewModel: healthKitPermissionViewModel) {
                            content()
                        }
                    }
                } else {
                    OnboardingView(viewModel: onboardingViewModel)
                }
            } else {
                SignInView(viewModel: authenticationViewModel)
                    .onAppear {
                        onboardingViewModel.prepareForSignedOutState()
                        hydrationReminderPermissionViewModel.markSignedOut()
                        healthKitPermissionViewModel.markSignedOut()
                    }
            }
        }
    }
}
