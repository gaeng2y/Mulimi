//
//  DrinkWaterApp.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import DependencyInjection
import DomainLayerInterface
import FirebaseCore
import PostHog
import PresentationLayer
import SwiftUI

@main
struct DrinkWaterApp: App {
    init() {
        FirebaseApp.configure()
        DIContainer.shared.registerAnalyticsRepository(Self.makeAnalyticsRepository())
    }

    private static func makeAnalyticsRepository() -> AnalyticsRepository {
        var repositories: [any AnalyticsRepository] = [FirebaseAnalyticsRepository()]
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "PostHogAPIKey") as? String,
           apiKey.isEmpty == false {
            let config = PostHogConfig(apiKey: apiKey, host: "https://us.i.posthog.com")
            config.captureApplicationLifecycleEvents = true
            config.captureScreenViews = false
            config.captureElementInteractions = false
            PostHogSDK.shared.setup(config)
            repositories.append(PostHogAnalyticsRepository())
        }
        return CompositeAnalyticsRepository(repositories: repositories)
    }

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
