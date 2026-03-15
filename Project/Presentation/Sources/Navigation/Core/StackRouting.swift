import SwiftUI

public protocol StackRouting: AnyObject {
    var path: NavigationPath { get set }
    var hasPath: Bool { get }
}

public extension StackRouting {
    var hasPath: Bool {
        !path.isEmpty
    }

    func pushRoute(_ route: some Hashable) {
        path.append(route)
    }

    func popRoute() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func resetPath() {
        path = NavigationPath()
    }
}
