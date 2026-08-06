import DependencyInjection
import PresentationLayer
import UIKit
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, @unchecked Sendable {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        guard isHydrationReminder(notification) else {
            return []
        }

        return [.banner, .sound]
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        guard isHydrationReminder(response.notification),
              let url = URL(string: "mulimi://hydration/record") else {
            return
        }

        await MainActor.run {
            DIContainer.shared.resolve(AppCoordinator.self).handleDeepLink(url)
        }
    }

    nonisolated private func isHydrationReminder(_ notification: UNNotification) -> Bool {
        notification.request.identifier.hasPrefix("hydrationReminder.")
    }
}
