import PresentationLayer

public final class MockRecordCoordinator: RecordCoordinator {
    override public init() {
        super.init()
    }

    override public func push(_ route: RecordRoute) {
        print("Mock Record Push: \(route)")
        super.push(route)
    }

    override public func present(_ route: RecordRoute) {
        print("Mock Record Present: \(route)")
        super.present(route)
    }

    override public func dismissPresentedRoute() {
        print("Mock Record Dismiss")
        super.dismissPresentedRoute()
    }
}
