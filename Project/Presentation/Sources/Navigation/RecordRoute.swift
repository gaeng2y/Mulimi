import Foundation

public enum RecordRoute: NavigationRoute {
    case monthPicker
}

extension RecordRoute: Identifiable {
    public var id: String {
        switch self {
        case .monthPicker:
            return "month_picker"
        }
    }
}

extension RecordRoute {
    public var presentationStyle: NavigationPresentationStyle {
        switch self {
        case .monthPicker:
            return .sheet
        }
    }
}
