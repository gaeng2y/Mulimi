import DomainLayerInterface

struct CompositeAnalyticsRepository: AnalyticsRepository {
    private let repositories: [any AnalyticsRepository]

    init(repositories: [any AnalyticsRepository]) {
        self.repositories = repositories
    }

    func track(_ event: ProductAnalyticsEvent) {
        for repository in repositories {
            repository.track(event)
        }
    }

    func identify(userIdentifier: String) {
        for repository in repositories {
            repository.identify(userIdentifier: userIdentifier)
        }
    }

    func reset() {
        for repository in repositories {
            repository.reset()
        }
    }
}
