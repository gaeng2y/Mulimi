public protocol FullScreenRouting: AnyObject {
    associatedtype FullScreenRoute: Identifiable

    var fullScreenRoute: FullScreenRoute? { get set }
}

public extension FullScreenRouting {
    func presentFullScreen(_ route: FullScreenRoute) {
        fullScreenRoute = route
    }

    func dismissFullScreen() {
        fullScreenRoute = nil
    }
}
