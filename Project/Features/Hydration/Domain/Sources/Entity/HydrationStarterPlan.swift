import Foundation

public enum HydrationQuickRecordingMethod: String, CaseIterable, Codable, Sendable {
    case widget
    case watch
    case shortcuts
}

/// On-device setup progress, not a hydration ledger or proof of installation.
public struct HydrationStarterPlan: Codable, Equatable, Sendable {
    public let startedAt: Date
    public var quickRecordingMethod: HydrationQuickRecordingMethod?
    public var isDismissed: Bool
    public var isCompleted: Bool

    public init(
        startedAt: Date,
        quickRecordingMethod: HydrationQuickRecordingMethod? = nil,
        isDismissed: Bool = false,
        isCompleted: Bool = false
    ) {
        self.startedAt = startedAt
        self.quickRecordingMethod = quickRecordingMethod
        self.isDismissed = isDismissed
        self.isCompleted = isCompleted
    }

    public func dayNumber(on date: Date, calendar: Calendar) -> Int? {
        guard date >= startedAt,
              let days = calendar.dateComponents(
                [.day],
                from: calendar.startOfDay(for: startedAt),
                to: calendar.startOfDay(for: date)
              ).day,
              (0..<7).contains(days) else {
            return nil
        }
        return days + 1
    }
}
