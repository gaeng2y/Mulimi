import DomainLayerInterface
import Foundation
import Localization

extension HydrationRoutineRecommendation {
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
