import Foundation
import Localization
import UserNotifications

public enum HydrationReminderNotification {
    public static let identifierPrefix = "hydrationReminder."
    public static let categoryIdentifier = "hydrationReminder.record"
    public static let drinkActionIdentifier = "hydrationReminder.drink"
    public static let failureIdentifier = "hydrationReminderResult"

    public static var category: UNNotificationCategory {
        UNNotificationCategory(
            identifier: categoryIdentifier,
            actions: [UNNotificationAction(
                identifier: drinkActionIdentifier,
                title: L10n.tr("hydrationReminderDrinkAction"),
                options: [.authenticationRequired]
            )],
            intentIdentifiers: []
        )
    }

    private static let receiptKey = "hydrationReminder.lastRecordedOccurrences"

    @MainActor
    public static func wasRecorded(
        requestIdentifier: String, deliveredAt: Date, userDefaults: UserDefaults = .standard
    ) -> Bool {
        let receipts = userDefaults.dictionary(forKey: receiptKey) as? [String: Double] ?? [:]
        return receipts[requestIdentifier] == deliveredAt.timeIntervalSince1970
    }

    @MainActor
    public static func markRecorded(
        requestIdentifier: String, deliveredAt: Date, userDefaults: UserDefaults = .standard
    ) {
        // Delivery receipts only; hydration records remain exclusively in HealthKit.
        var receipts = userDefaults.dictionary(forKey: receiptKey) as? [String: Double] ?? [:]
        receipts[requestIdentifier] = deliveredAt.timeIntervalSince1970
        userDefaults.set(receipts, forKey: receiptKey)
    }

    public static func showFailure(messageKey: String) async throws {
        let content = UNMutableNotificationContent()
        content.title = L10n.tr("hydrationReminderRecordFailureTitle")
        content.body = L10n.tr(messageKey)
        content.sound = .default
        try await UNUserNotificationCenter.current().add(UNNotificationRequest(
            identifier: failureIdentifier, content: content, trigger: nil
        ))
    }
}
