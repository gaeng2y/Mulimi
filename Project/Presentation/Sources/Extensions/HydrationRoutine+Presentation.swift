import DomainLayerInterface
import Foundation
import Localization

extension RoutineWeekday {
    var shortDisplayName: String {
        switch self {
        case .monday:
            return L10n.tr("commonWeekdayMondayShort")
        case .tuesday:
            return L10n.tr("commonWeekdayTuesdayShort")
        case .wednesday:
            return L10n.tr("commonWeekdayWednesdayShort")
        case .thursday:
            return L10n.tr("commonWeekdayThursdayShort")
        case .friday:
            return L10n.tr("commonWeekdayFridayShort")
        case .saturday:
            return L10n.tr("commonWeekdaySaturdayShort")
        case .sunday:
            return L10n.tr("commonWeekdaySundayShort")
        }
    }
}

extension HydrationRoutine {
    var timeText: String {
        var calendar = Calendar.current
        calendar.locale = .current

        let date = calendar.date(from: DateComponents(hour: hour, minute: minute)) ?? .now
        return DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
    }

    var weekdayText: String {
        if weekdays.count == RoutineWeekday.allCases.count {
            return L10n.tr("profileRoutineRepeatEverydayValue")
        }

        return weekdays.map(\.shortDisplayName).joined(separator: ", ")
    }
}
