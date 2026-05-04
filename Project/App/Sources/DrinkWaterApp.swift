//
//  DrinkWaterApp.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import DependencyInjection
import FirebaseCore
import PresentationLayer
import SwiftUI

@main
struct DrinkWaterApp: App {
    init() {
        FirebaseApp.configure()
        DIContainer.shared.registerAnalyticsRepository(FirebaseAnalyticsRepository())
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                appSession: DIContainer.shared.resolve(AppSession.self),
                authenticationViewModel: DIContainer.shared.resolve(AuthenticationViewModel.self),
                onboardingViewModel: DIContainer.shared.resolve(OnboardingViewModel.self),
                healthKitPermissionViewModel: DIContainer.shared.resolve(HealthKitPermissionViewModel.self)
            ) {
                ContentView()
            }
        }
    }
}
