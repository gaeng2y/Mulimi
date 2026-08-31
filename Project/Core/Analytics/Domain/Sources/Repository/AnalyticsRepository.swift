public protocol AnalyticsRepository: Sendable {
    func track(_ event: ProductAnalyticsEvent)
    func identify(userIdentifier: String)
    func reset()
}

public extension AnalyticsRepository {
    func identify(userIdentifier: String) {}
    func reset() {}
}

public struct NoOpAnalyticsRepository: AnalyticsRepository {
    public init() {}

    public func track(_ event: ProductAnalyticsEvent) {}
}
