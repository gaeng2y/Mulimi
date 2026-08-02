import DomainLayerInterface

public struct AnalyticsUseCaseImpl: AnalyticsUseCase {
    private let repository: AnalyticsRepository

    public init(repository: AnalyticsRepository) {
        self.repository = repository
    }

    public func track(_ event: ProductAnalyticsEvent) {
        repository.track(event)
    }

    public func identify(userIdentifier: String) {
        repository.identify(userIdentifier: userIdentifier)
    }

    public func reset() {
        repository.reset()
    }
}
