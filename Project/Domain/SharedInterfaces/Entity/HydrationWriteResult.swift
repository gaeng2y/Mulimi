import Foundation

public enum HydrationWriteFailureReason: Equatable, Sendable {
    case permissionDenied
    case invalidObjectType
    case systemError
}

public enum HydrationWriteResult: Equatable, Sendable {
    case success
    case failure(HydrationWriteFailureReason)

    public var isSuccess: Bool {
        self == .success
    }

    public var failureReason: HydrationWriteFailureReason? {
        switch self {
        case .success:
            return nil
        case let .failure(reason):
            return reason
        }
    }
}
