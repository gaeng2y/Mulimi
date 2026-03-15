import Foundation
import SwiftUI

public protocol RecordRouting: StackRouting, SheetRouting, DeepLinkHandling where SheetRoute == RecordRoute {
    func push(_ route: RecordRoute)
    func pop()
    func reset()
    func present(_ route: RecordRoute)
    func dismissPresentedRoute()
}

public extension RecordRouting {
    func push(_ route: RecordRoute) {
        pushRoute(route)
    }

    func pop() {
        popRoute()
    }

    func reset() {
        resetPath()
    }

    func present(_ route: RecordRoute) {
        presentSheet(route)
    }

    func dismissPresentedRoute() {
        dismissSheet()
    }
}
