import Observation

@Observable
public final class AppSession {
    public var isAuthenticated: Bool

    public init(isAuthenticated: Bool = false) {
        self.isAuthenticated = isAuthenticated
    }
}
