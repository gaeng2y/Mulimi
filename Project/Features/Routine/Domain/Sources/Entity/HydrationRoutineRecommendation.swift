import Foundation

public enum HydrationRoutineRecommendationKind: String, Equatable, Sendable {
    case morningStart
    case afternoonGap
    case frequentHydrationWindow
}

public struct HydrationRoutineRecommendation: Identifiable, Equatable, Sendable {
    public let kind: HydrationRoutineRecommendationKind
    public let hour: Int
    public let minute: Int
    public let weekdays: [RoutineWeekday]

    public init(
        kind: HydrationRoutineRecommendationKind,
        hour: Int,
        minute: Int,
        weekdays: [RoutineWeekday]
    ) {
        self.kind = kind
        self.hour = hour
        self.minute = minute
        self.weekdays = RoutineWeekday.normalized(weekdays)
    }

    public var id: String {
        let weekdayKey = weekdays.map(\.rawValue).map(String.init).joined(separator: "-")
        return "\(kind.rawValue)-\(hour)-\(minute)-\(weekdayKey)"
    }
}
