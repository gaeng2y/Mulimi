import DomainLayerInterface
import FirebaseAnalytics
import Foundation

struct FirebaseAnalyticsRepository: AnalyticsRepository {
    func track(_ event: ProductAnalyticsEvent) {
        Analytics.logEvent(
            event.name,
            parameters: event.parameters.mapValues(\.firebaseValue)
        )
    }
}

private extension AnalyticsParameterValue {
    var firebaseValue: Any {
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
