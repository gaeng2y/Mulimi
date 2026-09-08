import WidgetKit

public protocol WidgetTimelineReloading: Sendable {
    func reloadAllTimelines()
}

public struct SystemWidgetTimelineReloader: WidgetTimelineReloading {
    public init() {}

    public func reloadAllTimelines() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

public struct NoOpWidgetTimelineReloader: WidgetTimelineReloading {
    public init() {}

    public func reloadAllTimelines() {}
}
