import DomainLayerInterface
import Foundation

public enum AppRoute: NavigationRoute, Sendable {
    case profileRoutine
    case setting(SettingMenu)

    public var id: String {
        switch self {
        case .profileRoutine:
            return "profile_routine"
        case let .setting(menu):
            return "setting_\(menu.settingKey)"
        }
    }

    public var presentationStyle: NavigationPresentationStyle {
        .push
    }
}
