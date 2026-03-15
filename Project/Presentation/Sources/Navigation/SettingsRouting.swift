import SwiftUI

public protocol SettingsRouting: StackRouting, DeepLinkHandling {
    func push(_ route: SettingsRoute)
    func pop()
    func reset()
}

public extension SettingsRouting {
    func push(_ route: SettingsRoute) {
        pushRoute(route)
    }

    func pop() {
        popRoute()
    }

    func reset() {
        resetPath()
    }
}
