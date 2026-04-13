import DomainLayerInterface
import Foundation

public enum AppRoute: NavigationRoute, Sendable {
    case profileRoutine
    case profileRoutineAction(RoutineActionIntent)
    case setting(SettingMenu)

    public var id: String {
        switch self {
        case .profileRoutine:
            return "profile_routine"
        case let .profileRoutineAction(action):
            return "profile_routine_\(action.id)"
        case let .setting(menu):
            return "setting_\(menu.rawValue)"
        }
    }

    public var presentationStyle: NavigationPresentationStyle {
        .push
    }
}

private extension RoutineActionIntent {
    var id: String {
        switch self {
        case .create:
            return "create"
        case let .edit(routineID):
            return "edit_\(routineID.uuidString)"
        }
    }
}
