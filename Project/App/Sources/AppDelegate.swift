import AccountDomain
import DependencyInjection
import HydrationPresentation
import HydrationReminderData
import MulimiAnalytics
import MulimiNavigation
import OSLog
import UIKit
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, @unchecked Sendable {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.setNotificationCategories([HydrationReminderNotification.category])
        return true
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        guard isHydrationReminder(notification)
                || notification.request.identifier == HydrationReminderNotification.failureIdentifier else {
            return []
        }
        return [.banner, .sound]
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let notification = response.notification
        if isHydrationReminder(notification),
           response.actionIdentifier == HydrationReminderNotification.drinkActionIdentifier,
           notification.request.content.categoryIdentifier == HydrationReminderNotification.categoryIdentifier {
            await recordWater(from: notification)
        } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier,
                  isHydrationReminder(notification)
                    || notification.request.identifier == HydrationReminderNotification.failureIdentifier {
            await MainActor.run {
                if isHydrationReminder(notification) {
                    DIContainer.shared.resolve(AnalyticsUseCase.self).track(
                        ProductAnalyticsEvent(name: "hydration_reminder_opened")
                    )
                }
                if let url = URL(string: "mulimi://hydration/record") {
                    DIContainer.shared.resolve(AppCoordinator.self).handleDeepLink(url)
                }
            }
        }
    }

    @MainActor
    private func recordWater(from notification: UNNotification) async {
        let requestID = notification.request.identifier
        let deliveredAt = notification.date
        guard !HydrationReminderNotification.wasRecorded(requestIdentifier: requestID, deliveredAt: deliveredAt) else {
            return
        }
        let result = await DIContainer.shared.resolve(HydrationReminderActionHandler.self).handle(
            requestIdentifier: notification.request.identifier,
            deliveredAt: notification.date,
            isProtectedDataAvailable: UIApplication.shared.isProtectedDataAvailable,
            isAuthenticated: DIContainer.shared.resolve(SignInUseCase.self).isAuthenticated
        )
        let messageKey: String
        switch result {
        case .saved:
            HydrationReminderNotification.markRecorded(requestIdentifier: requestID, deliveredAt: deliveredAt)
            return
        case .duplicate: return
        case .permissionRequired: messageKey = "hydrationReminderRecordPermissionRequired"
        case .goalExceeded: messageKey = "hydrationReminderRecordGoalExceeded"
        case .signInRequired: messageKey = "hydrationReminderRecordSignInRequired"
        case .failed, .protectedDataUnavailable: messageKey = "hydrationReminderRecordFailed"
        }
        do {
            try await HydrationReminderNotification.showFailure(messageKey: messageKey)
        } catch {
            Logger(subsystem: "gaeng2y.DrinkWater", category: "HydrationReminderAction")
                .error("Failed to present reminder recording failure: \(String(describing: error))")
        }
    }

    nonisolated private func isHydrationReminder(_ notification: UNNotification) -> Bool {
        notification.request.identifier.hasPrefix(HydrationReminderNotification.identifierPrefix)
    }
}
