import Foundation

public enum RoutineActionIntent: Hashable, Sendable {
    case create
    case edit(UUID)
}
