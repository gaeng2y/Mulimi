import Foundation
import Localization

public enum RoutineNotificationAuthorizationStatus: Int, Codable, Sendable {
    case notDetermined
    case denied
    case authorized

    public var displayName: String {
        switch self {
        case .notDetermined:
            L10n.tr("profileRoutineNotificationPendingValue")
        case .denied:
            L10n.tr("profileRoutineNotificationDeniedValue")
        case .authorized:
            L10n.tr("profileRoutineNotificationAuthorizedValue")
        }
    }
}
