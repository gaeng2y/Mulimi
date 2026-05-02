public protocol AnalyticsUseCase: Sendable {
    func track(_ event: ProductAnalyticsEvent)
}

public struct NoOpAnalyticsUseCase: AnalyticsUseCase {
    public init() {}

    public func track(_ event: ProductAnalyticsEvent) {}
}
