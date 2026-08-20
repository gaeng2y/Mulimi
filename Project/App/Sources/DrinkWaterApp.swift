//
//  DrinkWaterApp.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import DependencyInjection
import DomainLayerInterface
import Foundation
import PostHog
import PresentationLayer
import SwiftUI

@main
struct DrinkWaterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    init() {
        DIContainer.shared.registerAnalyticsRepository(Self.makeAnalyticsRepository())
    }

    private static func makeAnalyticsRepository() -> AnalyticsRepository {
        guard let projectToken = Bundle.main.object(forInfoDictionaryKey: "PostHogProjectToken") as? String,
              projectToken.hasPrefix("phc_"),
              projectToken.count > 4,
              let host = Bundle.main.object(forInfoDictionaryKey: "PostHogHost") as? String,
              let hostURL = URL(string: host),
              let hostScheme = hostURL.scheme?.lowercased(),
              ["http", "https"].contains(hostScheme),
              hostURL.host?.isEmpty == false else {
            return NoOpAnalyticsRepository()
        }

        let config = PostHogConfig(projectToken: projectToken, host: host)
        config.captureApplicationLifecycleEvents = true
        config.errorTrackingConfig.autoCapture = true
        config.captureScreenViews = false
        config.captureElementInteractions = false
        config.capturePushNotificationSubscriptions = false
        config.capturePushNotificationOpened = false
        PostHogSDK.shared.setup(config)
        return PostHogAnalyticsRepository()
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
