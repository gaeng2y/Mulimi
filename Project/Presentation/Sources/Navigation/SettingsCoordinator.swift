import Foundation
import SwiftUI

@Observable
public final class SettingsCoordinator {
    public var path = NavigationPath()

    public init() {}

    public func push(_ route: SettingsRoute) {
        path.append(route)
    }

    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    public func reset() {
        path = NavigationPath()
    }

    public func handleDeepLink(_ url: URL) {
        // TODO: Implement URL parsing to SettingsRoute.
        // Example: myapp://settings/daily-limit -> SettingsRoute.dailyLimit
    }

    public var hasPath: Bool {
        !path.isEmpty
    }

    public var pathCount: Int {
        path.count
    }
}
