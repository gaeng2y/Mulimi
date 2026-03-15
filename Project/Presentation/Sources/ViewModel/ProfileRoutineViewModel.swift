import Localization
import SwiftUI

public enum RoutineNotificationStatus: Equatable {
    case notRequested
    case authorized
    case denied

    var displayText: String {
        switch self {
        case .notRequested:
            L10n.tr("profileRoutineNotificationPendingValue")
        case .authorized:
            L10n.tr("profileRoutineNotificationAuthorizedValue")
        case .denied:
            L10n.tr("profileRoutineNotificationDeniedValue")
        }
    }
}

public struct RoutineScheduleSummary: Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let timeDescription: String
    public let repeatDescription: String
    public let isEnabled: Bool

    public init(
        id: UUID = UUID(),
        title: String,
        timeDescription: String,
        repeatDescription: String,
        isEnabled: Bool
    ) {
        self.id = id
        self.title = title
        self.timeDescription = timeDescription
        self.repeatDescription = repeatDescription
        self.isEnabled = isEnabled
    }
}

struct RoutineDetailRow: Identifiable, Equatable {
    let id: String
    let title: String
    let value: String
    let systemImage: String
}

@Observable
public final class ProfileRoutineViewModel {
    public private(set) var notificationStatus: RoutineNotificationStatus
    public private(set) var routines: [RoutineScheduleSummary]

    public init(
        notificationStatus: RoutineNotificationStatus = .notRequested,
        routines: [RoutineScheduleSummary] = []
    ) {
        self.notificationStatus = notificationStatus
        self.routines = routines
    }

    public var hasConfiguredRoutine: Bool {
        !routines.isEmpty
    }

    public var activeRoutineCount: Int {
        routines.filter(\.isEnabled).count
    }

    public var summaryBadgeText: String {
        if hasConfiguredRoutine {
            return L10n.tr("profileRoutineStatusActiveCountFormat", activeRoutineCount)
        }

        return L10n.tr("profileRoutineStatusEmptyBadge")
    }

    public var summaryHeadline: String {
        if hasConfiguredRoutine {
            return L10n.tr("profileRoutineConfiguredHeadline")
        }

        return L10n.tr("profileRoutineEmptyHeadline")
    }

    public var summaryDescription: String {
        guard let primaryRoutine else {
            return L10n.tr("profileRoutineEmptyDescription")
        }

        return "\(primaryRoutine.timeDescription) · \(primaryRoutine.repeatDescription)"
    }

    var detailRows: [RoutineDetailRow] {
        [
            RoutineDetailRow(
                id: "notificationStatus",
                title: L10n.tr("profileRoutineNotificationStatusTitle"),
                value: notificationStatus.displayText,
                systemImage: "bell.badge"
            ),
            RoutineDetailRow(
                id: "activeRoutineCount",
                title: L10n.tr("profileRoutineActiveCountTitle"),
                value: activeRoutineCountText,
                systemImage: "clock.badge"
            ),
            RoutineDetailRow(
                id: "time",
                title: L10n.tr("profileRoutineTimeTitle"),
                value: primaryRoutine?.timeDescription ?? L10n.tr("profileRoutineDetailEmptyValue"),
                systemImage: "clock"
            ),
            RoutineDetailRow(
                id: "repeat",
                title: L10n.tr("profileRoutineRepeatTitle"),
                value: primaryRoutine?.repeatDescription ?? L10n.tr("profileRoutineDetailEmptyValue"),
                systemImage: "calendar"
            )
        ]
    }

    var displayedRoutines: [RoutineScheduleSummary] {
        routines
    }

    private var activeRoutineCountText: String {
        if activeRoutineCount == 0 {
            return L10n.tr("profileRoutineActiveCountNoneValue")
        }

        return L10n.tr("profileRoutineCountFormat", activeRoutineCount)
    }

    private var primaryRoutine: RoutineScheduleSummary? {
        routines.first(where: \.isEnabled) ?? routines.first
    }
}
