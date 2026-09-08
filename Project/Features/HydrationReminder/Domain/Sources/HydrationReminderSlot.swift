import Foundation

public enum HydrationReminderSlot: String, CaseIterable, Codable, Sendable {
    case morning
    case afternoon
    case evening

    public var hour: Int {
        switch self {
        case .morning:
            return 9
        case .afternoon:
            return 14
        case .evening:
            return 20
        }
    }

    public var minute: Int {
        0
    }
}
