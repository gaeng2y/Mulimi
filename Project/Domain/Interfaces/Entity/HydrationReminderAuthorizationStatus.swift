import Foundation

public enum HydrationReminderAuthorizationStatus: Int, Codable, Sendable {
    case notDetermined
    case denied
    case authorized
}
