import Foundation
import SwiftUI

@Observable
public final class AppCoordinator: StackRouting {
    public var path = NavigationPath()

    public init() {}

    public func push(_ route: AppRoute) {
        pushRoute(route)
    }

    public func handleDeepLink(_ url: URL) {
        // TODO: Map deep links to app routes.
    }
}
