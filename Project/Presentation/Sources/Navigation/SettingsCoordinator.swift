import Foundation
import SwiftUI

@Observable
public final class SettingsCoordinator: SettingsRouting {
    public var path = NavigationPath()

    public init() {}

    public func handleDeepLink(_ url: URL) {
        // TODO: Implement URL parsing to SettingsRoute.
        // Example: myapp://settings/daily-limit -> SettingsRoute.dailyLimit
    }

    public var pathCount: Int {
        path.count
    }
}
