import SwiftUI
import PresentationLayer

public final class MockSettingsCoordinator: SettingsCoordinator {
    override public init() {
        super.init()
    }

    // Mock implementation with debug logging for previews
    override public func push(_ route: SettingsRoute) {
        print("Mock Navigation to: \(route)")
        super.push(route)
    }

    override public func pop() {
        print("Mock Navigation Back")
        super.pop()
    }

    override public func reset() {
        print("Mock Reset Settings Path")
        super.reset()
    }

    // Convenience method for preview setup
    public func setupPreviewData() {
        // Add some sample navigation state for previews if needed
    }
}
