import DomainLayerInterface
import Foundation

extension HydrationNextRoutineContext {
    var timeText: String {
        var calendar = Calendar.current
        calendar.locale = .current

        let date = calendar.date(from: DateComponents(hour: hour, minute: minute)) ?? .now
        return DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
    }
}
