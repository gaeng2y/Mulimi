import Foundation
import RoutineDomain

public enum AppRoute: NavigationRoute, Sendable {
    case hydrationLogging
    case hydrationStarterPlan
    case profileRoutineAction(RoutineActionIntent)

    public var id: String {
        switch self {
        case .hydrationLogging:
            return "hydration_logging"
        case .hydrationStarterPlan:
            return "hydration_starter_plan"
        case let .profileRoutineAction(action):
            return "profile_routine_\(action.id)"
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
