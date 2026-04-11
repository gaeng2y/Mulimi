import Foundation

public enum RoutineWeekday: Int, CaseIterable, Codable, Identifiable, Sendable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    public var id: Int { rawValue }

    public static var displayOrder: [RoutineWeekday] {
        [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    }

    static func normalized(_ weekdays: [RoutineWeekday]) -> [RoutineWeekday] {
        let unique = Set(weekdays)
        return displayOrder.filter(unique.contains)
    }
}

public struct HydrationRoutine: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public var title: String
    public var hour: Int
    public var minute: Int
    public var weekdays: [RoutineWeekday]
    public var isEnabled: Bool

    public init(
        id: UUID = UUID(),
        title: String,
        hour: Int,
        minute: Int,
        weekdays: [RoutineWeekday],
        isEnabled: Bool
    ) {
        self.id = id
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        self.hour = hour
        self.minute = minute
        self.weekdays = RoutineWeekday.normalized(weekdays)
        self.isEnabled = isEnabled
    }

    public var nextActionSchedule: HydrationRoutineSchedule {
        HydrationRoutineSchedule(
            id: id.uuidString,
            title: title,
            hour: hour,
            minute: minute,
            weekdayRawValues: Set(weekdays.map(\.rawValue)),
            isEnabled: isEnabled
        )
    }
}
