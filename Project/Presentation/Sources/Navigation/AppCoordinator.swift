import Foundation
import SwiftUI

@Observable
public final class AppCoordinator: DeepLinkHandling, StackRouting {
    public var path = NavigationPath()

    public init() {}

    public func push(_ route: AppRoute) {
        pushRoute(route)
    }

    public func handleDeepLink(_ url: URL) {
        guard url.scheme == "mulimi",
              url.host == "hydration",
              url.path == "/record" else {
            return
        }

        push(.hydrationLogging)
    }
}
