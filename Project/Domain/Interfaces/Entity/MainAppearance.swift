import Foundation

public enum MainIcon: String, CaseIterable, Identifiable, Sendable {
    case drop
    case heart
    case cloud
    
    public var id: Self { self }

    public static var `default`: MainIcon { .drop }
}
