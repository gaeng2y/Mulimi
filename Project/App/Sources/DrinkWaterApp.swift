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
        if let projectToken = Bundle.main.object(forInfoDictionaryKey: "PostHogProjectToken") as? String,
           projectToken.hasPrefix("phc_"),
           let host = Bundle.main.object(forInfoDictionaryKey: "PostHogHost") as? String,
           host.isEmpty == false {
            let config = PostHogConfig(projectToken: projectToken, host: host)
            config.captureApplicationLifecycleEvents = true
            config.errorTrackingConfig.autoCapture = true
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
