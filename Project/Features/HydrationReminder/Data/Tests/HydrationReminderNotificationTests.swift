import Foundation
import Testing
import UserNotifications
@testable import HydrationReminderData

struct HydrationReminderNotificationTests {
    @Test("Release에서도 잠금 해제 후 백그라운드로 동작하는 기록 액션 하나만 제공한다")
    func actionCategory() throws {
        let category = HydrationReminderNotification.category
        #expect(category.identifier == HydrationReminderNotification.categoryIdentifier)
        #expect(category.actions.count == 1)
        let action = try #require(category.actions.first)
        #expect(action.identifier == HydrationReminderNotification.drinkActionIdentifier)
        #expect(!action.title.isEmpty)
        #expect(action.options.contains(.authenticationRequired))
        #expect(!action.options.contains(.foreground))
    }

    @MainActor
    @Test("성공 전달 영수증은 재생성 후 유지되고 다음 전달은 차단하지 않는다")
    func deliveryReceipts() throws {
        let suite = "reminder-receipts-\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let date = Date(timeIntervalSince1970: 1_800_000_000)
        #expect(!HydrationReminderNotification.wasRecorded(
            requestIdentifier: "morning.1", deliveredAt: date, userDefaults: defaults
        ))
        HydrationReminderNotification.markRecorded(
            requestIdentifier: "morning.1", deliveredAt: date, userDefaults: defaults
        )
        let restored = try #require(UserDefaults(suiteName: suite))
        #expect(HydrationReminderNotification.wasRecorded(
            requestIdentifier: "morning.1", deliveredAt: date, userDefaults: restored
        ))
        #expect(!HydrationReminderNotification.wasRecorded(
            requestIdentifier: "morning.1", deliveredAt: date.addingTimeInterval(7 * 86_400), userDefaults: restored
        ))
    }
}
