//
//  DrinkWaterApp.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import DependencyInjection
import HydrationReminderPresentation
import AccountPresentation
import HydrationPresentation
import SwiftUI

@main
struct DrinkWaterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView(
                appSession: DIContainer.shared.resolve(AppSession.self),
                authenticationViewModel: DIContainer.shared.resolve(AuthenticationViewModel.self),
                onboardingViewModel: DIContainer.shared.resolve(OnboardingViewModel.self),
                hydrationReminderPermissionViewModel: DIContainer.shared.resolve(
                    HydrationReminderPermissionViewModel.self
                ),
                healthKitPermissionViewModel: DIContainer.shared.resolve(HealthKitPermissionViewModel.self)
            ) {
                ContentView()
            }
        }
    }
}
