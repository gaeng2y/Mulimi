import CoreDomain

final class MockAnalyticsUseCase: AnalyticsUseCase, @unchecked Sendable {
    private(set) var trackedEvents: [ProductAnalyticsEvent] = []
    private(set) var identifiedUserIdentifiers: [String] = []
    private(set) var resetCallCount = 0

    func track(_ event: ProductAnalyticsEvent) {
        trackedEvents.append(event)
    }

    func identify(userIdentifier: String) {
        identifiedUserIdentifiers.append(userIdentifier)
    }

    func reset() {
        resetCallCount += 1
    }
}
