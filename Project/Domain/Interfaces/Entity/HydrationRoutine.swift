import Foundation
import Localization

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

    public var shortDisplayName: String {
        switch self {
        case .monday:
            L10n.tr("commonWeekdayMondayShort")
        case .tuesday:
            L10n.tr("commonWeekdayTuesdayShort")
        case .wednesday:
            L10n.tr("commonWeekdayWednesdayShort")
        case .thursday:
            L10n.tr("commonWeekdayThursdayShort")
        case .friday:
            L10n.tr("commonWeekdayFridayShort")
        case .saturday:
            L10n.tr("commonWeekdaySaturdayShort")
        case .sunday:
            L10n.tr("commonWeekdaySundayShort")
        }
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

    public var timeText: String {
        var calendar = Calendar.current
        calendar.locale = .current

        let date = calendar.date(from: DateComponents(hour: hour, minute: minute)) ?? .now
        return DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
    }

    public var weekdayText: String {
        if weekdays.count == RoutineWeekday.allCases.count {
            return L10n.tr("profileRoutineRepeatEverydayValue")
        }

        return weekdays.map(\.shortDisplayName).joined(separator: ", ")
    }

    public var notificationTitle: String {
        L10n.tr("routineNotificationTitle")
    }

    public var notificationBody: String {
        L10n.tr("routineNotificationBodyFormat", title)
    }
}
