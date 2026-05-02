import DomainLayerInterface

final class MockAnalyticsUseCase: AnalyticsUseCase, @unchecked Sendable {
    private(set) var trackedEvents: [ProductAnalyticsEvent] = []

    func track(_ event: ProductAnalyticsEvent) {
        trackedEvents.append(event)
    }
}
