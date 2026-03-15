public protocol SheetRouting: AnyObject {
    associatedtype SheetRoute: Identifiable

    var presentedRoute: SheetRoute? { get set }
}

public extension SheetRouting {
    func presentSheet(_ route: SheetRoute) {
        presentedRoute = route
    }

    func dismissSheet() {
        presentedRoute = nil
    }
}
