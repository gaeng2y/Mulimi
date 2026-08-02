import DomainLayerInterface
import Foundation
import PostHog

struct PostHogAnalyticsRepository: AnalyticsRepository {
    func track(_ event: ProductAnalyticsEvent) {
        PostHogSDK.shared.capture(
            event.name,
            properties: event.parameters.mapValues(\.postHogValue)
        )
    }

    func identify(userIdentifier: String) {
        PostHogSDK.shared.identify(userIdentifier)
    }

    func reset() {
        PostHogSDK.shared.reset()
    }
}

private extension AnalyticsParameterValue {
    var postHogValue: Any {
        switch self {
        case .string(let value):
            return value
        case .int(let value):
            return value
        case .double(let value):
            return value
        case .bool(let value):
            return value
        }
    }
}
