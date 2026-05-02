import DomainLayerInterface

public struct AnalyticsUseCaseImpl: AnalyticsUseCase {
    private let repository: AnalyticsRepository

    public init(repository: AnalyticsRepository) {
        self.repository = repository
    }

    public func track(_ event: ProductAnalyticsEvent) {
        repository.track(event)
    }
}
