import DomainLayerInterface
import Foundation
import Localization
import UserNotifications

public protocol HydrationReminderNotificationDataSource: Sendable {
    func authorizationStatus() async -> HydrationReminderAuthorizationStatus
    func requestAuthorization() async throws -> HydrationReminderAuthorizationStatus
    func scheduleDailyReminders(for slots: [HydrationReminderSlot]) async throws
    func cancelDailyReminders() async
}

public final class HydrationReminderNotificationDataSourceImpl: HydrationReminderNotificationDataSource,
                                                                @unchecked Sendable {
    private enum Constant {
        static let identifierPrefix = "hydrationReminder"
        static let scheduledWeekdays = 1...7
        // 본문 3종을 7일에 단순 나머지로 배치하면 토요일(7)과 일요일(1)이 같은
        // 인덱스가 되어 주 경계에서 같은 문구가 이틀 연속 반복된다. 주 경계를
        // 포함해 연속 반복이 없도록 요일별 회전 테이블을 고정한다.
        static let weekdayVariantIndices = [0, 1, 2, 0, 1, 2, 1]
    }

    private var notificationCenter: UNUserNotificationCenter {
        .current()
    }

    public init() {}

    public func authorizationStatus() async -> HydrationReminderAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        return mapAuthorizationStatus(settings.authorizationStatus)
    }

    public func requestAuthorization() async throws -> HydrationReminderAuthorizationStatus {
        _ = try await notificationCenter.requestAuthorization(options: [.alert, .sound])
        return await authorizationStatus()
    }

    public func scheduleDailyReminders(for slots: [HydrationReminderSlot]) async throws {
        var scheduledIdentifiers = Set<String>()

        // 같은 식별자로 add()하면 기존 요청이 교체되므로 먼저 취소하지 않는다.
        // 덕분에 중간에 실패해도 이전 스케줄이 지워진 채 남지 않는다.
        for slot in slots {
            for weekday in Constant.scheduledWeekdays {
                let content = UNMutableNotificationContent()
                content.title = notificationTitle(for: slot)
                content.body = notificationBody(for: slot, weekday: weekday)
                content.sound = .default

                var dateComponents = DateComponents()
                dateComponents.weekday = weekday
                dateComponents.hour = slot.hour
                dateComponents.minute = slot.minute

                let identifier = reminderIdentifier(for: slot, weekday: weekday)
                let request = UNNotificationRequest(
                    identifier: identifier,
                    content: content,
                    trigger: UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                )

                try await notificationCenter.add(request)
                scheduledIdentifiers.insert(identifier)
            }
        }

        await cancelReminders(excluding: scheduledIdentifiers)
    }

    public func cancelDailyReminders() async {
        await cancelReminders(excluding: [])
    }

    private func cancelReminders(excluding scheduledIdentifiers: Set<String>) async {
        let reminderIdentifiers = await notificationCenter.pendingNotificationRequests()
            .map(\.identifier)
            .filter { $0.hasPrefix(Constant.identifierPrefix) && !scheduledIdentifiers.contains($0) }

        guard !reminderIdentifiers.isEmpty else {
            return
        }

        notificationCenter.removePendingNotificationRequests(withIdentifiers: reminderIdentifiers)
    }

    private func reminderIdentifier(for slot: HydrationReminderSlot, weekday: Int) -> String {
        "\(Constant.identifierPrefix).\(slot.rawValue).\(weekday)"
    }

    private func notificationTitle(for slot: HydrationReminderSlot) -> String {
        switch slot {
        case .morning:
            return L10n.tr("hydrationReminderMorningTitle")
        case .afternoon:
            return L10n.tr("hydrationReminderAfternoonTitle")
        case .evening:
            return L10n.tr("hydrationReminderEveningTitle")
        }
    }

    private func notificationBody(for slot: HydrationReminderSlot, weekday: Int) -> String {
        let bodyKeys = bodyKeys(for: slot)
        let slotOffset = HydrationReminderSlot.allCases.firstIndex(of: slot) ?? 0
        let variantIndices = Constant.weekdayVariantIndices
        let weekdayIndex = variantIndices[(weekday - 1) % variantIndices.count]
        let bodyKey = bodyKeys[(weekdayIndex + slotOffset) % bodyKeys.count]

        return L10n.tr(bodyKey)
    }

    private func bodyKeys(for slot: HydrationReminderSlot) -> [String] {
        switch slot {
        case .morning:
            return [
                "hydrationReminderMorningBodyVariant1",
                "hydrationReminderMorningBodyVariant2",
                "hydrationReminderMorningBodyVariant3"
            ]
        case .afternoon:
            return [
                "hydrationReminderAfternoonBodyVariant1",
                "hydrationReminderAfternoonBodyVariant2",
                "hydrationReminderAfternoonBodyVariant3"
            ]
        case .evening:
            return [
                "hydrationReminderEveningBodyVariant1",
                "hydrationReminderEveningBodyVariant2",
                "hydrationReminderEveningBodyVariant3"
            ]
        }
    }

    private func mapAuthorizationStatus(
        _ status: UNAuthorizationStatus
    ) -> HydrationReminderAuthorizationStatus {
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .authorized, .provisional, .ephemeral:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
}
