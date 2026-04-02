//
//  DrinkWaterApp.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import DependencyInjection
import PresentationLayer
import SwiftUI

@main
struct DrinkWaterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView(
                authenticationViewModel: DIContainer.shared.resolve(AuthenticationViewModel.self),
                onboardingViewModel: DIContainer.shared.resolve(OnboardingViewModel.self),
                healthKitPermissionViewModel: DIContainer.shared.resolve(HealthKitPermissionViewModel.self)
            ) {
                ContentView()
            }
        }
    }
}
