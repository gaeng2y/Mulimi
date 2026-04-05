import AlarmKit
import CryptoKit
import DomainLayerInterface
import Foundation
import Localization
import SwiftUI

public protocol RoutineNotificationDataSource: Sendable {
    func authorizationStatus() async -> RoutineNotificationAuthorizationStatus
    func requestAuthorization() async throws -> RoutineNotificationAuthorizationStatus
    func scheduleNotifications(for routines: [HydrationRoutine]) async throws
}

public final class RoutineNotificationDataSourceImpl: RoutineNotificationDataSource, @unchecked Sendable {
    private enum Constant {
        static let tintColor = Color.blue
        static let stopButtonSystemImageName = "drop.fill"
    }

    private let alarmManager: AlarmManager

    public init(alarmManager: AlarmManager = .shared) {
        self.alarmManager = alarmManager
    }

    public func authorizationStatus() async -> RoutineNotificationAuthorizationStatus {
        mapAuthorizationState(alarmManager.authorizationState)
    }

    public func requestAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
        let state = try await alarmManager.requestAuthorization()
        return mapAuthorizationState(state)
    }

    public func scheduleNotifications(for routines: [HydrationRoutine]) async throws {
        try cancelExistingAlarms()

        for routine in routines where routine.isEnabled {
            for weekday in routine.weekdays {
                let configuration = AlarmManager.AlarmConfiguration.alarm(
                    schedule: .relative(
                        .init(
                            time: .init(hour: routine.hour, minute: routine.minute),
                            repeats: .weekly([weekday.localeWeekday])
                        )
                    ),
                    attributes: AlarmAttributes(
                        presentation: alarmPresentation(for: routine),
                        metadata: RoutineAlarmMetadata(routineID: routine.id, weekday: weekday),
                        tintColor: Constant.tintColor
                    )
                )

                _ = try await alarmManager.schedule(
                    id: alarmIdentifier(for: routine.id, weekday: weekday),
                    configuration: configuration
                )
            }
        }
    }

    private func cancelExistingAlarms() throws {
        let alarms = try alarmManager.alarms

        // Mulimi currently uses AlarmKit only for routine reminders, so a full reset
        // keeps edit/delete flows deterministic before we schedule the latest routine set.
        for alarm in alarms {
            do {
                try alarmManager.cancel(id: alarm.id)
            } catch {
                continue
            }
        }
    }

    private func alarmPresentation(for routine: HydrationRoutine) -> AlarmPresentation {
        let title = localizedStringResource(
            for: L10n.tr("routineNotificationBodyFormat", routine.title)
        )

        if #available(iOS 26.1, *) {
            return AlarmPresentation(alert: .init(title: title))
        }

        return AlarmPresentation(
            alert: .init(
                title: title,
                stopButton: AlarmButton(
                    text: localizedStringResource(for: L10n.tr("routineAlarmStopTitle")),
                    textColor: .white,
                    systemImageName: Constant.stopButtonSystemImageName
                )
            )
        )
    }

    private func localizedStringResource(for value: String) -> LocalizedStringResource {
        LocalizedStringResource(String.LocalizationValue(value))
    }

    private func alarmIdentifier(for routineID: UUID, weekday: RoutineWeekday) -> Alarm.ID {
        UUID(stableHashInput: "\(routineID.uuidString).\(weekday.rawValue)")
    }

    private func mapAuthorizationState(
        _ state: AlarmManager.AuthorizationState
    ) -> RoutineNotificationAuthorizationStatus {
        switch state {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        @unknown default:
            return .notDetermined
        }
    }
}

private struct RoutineAlarmMetadata: AlarmMetadata {
    let routineID: UUID
    let weekday: RoutineWeekday
}

private extension RoutineWeekday {
    var localeWeekday: Locale.Weekday {
        switch self {
        case .sunday:
            .sunday
        case .monday:
            .monday
        case .tuesday:
            .tuesday
        case .wednesday:
            .wednesday
        case .thursday:
            .thursday
        case .friday:
            .friday
        case .saturday:
            .saturday
        }
    }
}

private extension UUID {
    init(stableHashInput value: String) {
        let digest = Array(SHA256.hash(data: Data(value.utf8)))
        let uuid = uuid_t(
            digest[0],
            digest[1],
            digest[2],
            digest[3],
            digest[4],
            digest[5],
            digest[6],
            digest[7],
            digest[8],
            digest[9],
            digest[10],
            digest[11],
            digest[12],
            digest[13],
            digest[14],
            digest[15]
        )

        self = UUID(uuid: uuid)
    }
}
