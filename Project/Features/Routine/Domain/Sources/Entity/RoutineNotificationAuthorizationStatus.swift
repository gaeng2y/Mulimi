import Foundation

public enum RoutineNotificationAuthorizationStatus: Int, Codable, Sendable {
    case notDetermined
    case denied
    case authorized
}
