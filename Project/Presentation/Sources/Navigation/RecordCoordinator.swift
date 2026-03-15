import Foundation
import SwiftUI

@Observable
public final class RecordCoordinator: RecordRouting {
    public var path = NavigationPath()
    public var presentedRoute: RecordRoute?
    public var fullScreenRoute: RecordRoute?

    public init() {}

    public func handleDeepLink(_ url: URL) {
        // TODO: Implement URL parsing to RecordRoute.
        // Example: myapp://history/month-picker -> RecordRoute.monthPicker
    }
}
