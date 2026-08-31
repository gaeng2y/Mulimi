public protocol AnalyticsUseCase: Sendable {
    func track(_ event: ProductAnalyticsEvent)
    func identify(userIdentifier: String)
    func reset()
}

public extension AnalyticsUseCase {
    func identify(userIdentifier: String) {}
    func reset() {}
}

public struct NoOpAnalyticsUseCase: AnalyticsUseCase {
    public init() {}

    public func track(_ event: ProductAnalyticsEvent) {}
}
