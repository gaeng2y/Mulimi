public protocol AnalyticsRepository: Sendable {
    func track(_ event: ProductAnalyticsEvent)
}

public struct NoOpAnalyticsRepository: AnalyticsRepository {
    public init() {}

    public func track(_ event: ProductAnalyticsEvent) {}
}
