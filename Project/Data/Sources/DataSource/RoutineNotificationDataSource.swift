import DomainLayerInterface
import Foundation
import UserNotifications

public protocol RoutineNotificationDataSource: Sendable {
    func authorizationStatus() async -> RoutineNotificationAuthorizationStatus
    func requestAuthorization() async throws -> RoutineNotificationAuthorizationStatus
    func scheduleNotifications(for routines: [HydrationRoutine]) async throws
}

public final class RoutineNotificationDataSourceImpl: RoutineNotificationDataSource, @unchecked Sendable {
    private enum Constant {
        static let identifierPrefix = "hydrationRoutine"
    }

    private let notificationCenter: UNUserNotificationCenter

    public init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }

    public func authorizationStatus() async -> RoutineNotificationAuthorizationStatus {
        await withCheckedContinuation { continuation in
            notificationCenter.getNotificationSettings { settings in
                let status: RoutineNotificationAuthorizationStatus
                switch settings.authorizationStatus {
                case .notDetermined:
                    status = .notDetermined
                case .denied:
                    status = .denied
                case .authorized, .provisional, .ephemeral:
                    status = .authorized
                @unknown default:
                    status = .notDetermined
                }

                continuation.resume(returning: status)
            }
        }
    }

    public func requestAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
        let granted = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
        return granted ? .authorized : .denied
    }

    public func scheduleNotifications(for routines: [HydrationRoutine]) async throws {
        let identifiers = await scheduledRoutineIdentifiers()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        notificationCenter.removeDeliveredNotifications(withIdentifiers: identifiers)

        for routine in routines where routine.isEnabled {
            for weekday in routine.weekdays {
                let content = UNMutableNotificationContent()
                content.title = routine.notificationTitle
                content.body = routine.notificationBody
                content.sound = .default

                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: DateComponents(
                        hour: routine.hour,
                        minute: routine.minute,
                        weekday: weekday.rawValue
                    ),
                    repeats: true
                )
                let request = UNNotificationRequest(
                    identifier: notificationIdentifier(for: routine.id, weekday: weekday),
                    content: content,
                    trigger: trigger
                )

                try await notificationCenter.add(request)
            }
        }
    }

    private func scheduledRoutineIdentifiers() async -> [String] {
        await withCheckedContinuation { continuation in
            notificationCenter.getPendingNotificationRequests { requests in
                let identifiers = requests
                    .map(\.identifier)
                    .filter { $0.hasPrefix(Constant.identifierPrefix) }
                continuation.resume(returning: identifiers)
            }
        }
    }

    private func notificationIdentifier(for routineID: UUID, weekday: RoutineWeekday) -> String {
        "\(Constant.identifierPrefix).\(routineID.uuidString).\(weekday.rawValue)"
    }
}
