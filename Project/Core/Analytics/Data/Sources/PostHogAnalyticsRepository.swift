import MulimiAnalytics
import Foundation
import PostHog

public struct PostHogAnalyticsRepository: AnalyticsRepository {
    public init(projectToken: String, host: String) {
        let config = PostHogConfig(projectToken: projectToken, host: host)
        config.captureApplicationLifecycleEvents = true
        config.errorTrackingConfig.autoCapture = true
        config.captureScreenViews = false
        config.captureElementInteractions = false
        config.capturePushNotificationSubscriptions = false
        config.capturePushNotificationOpened = false
        PostHogSDK.shared.setup(config)
    }

    public func track(_ event: ProductAnalyticsEvent) {
        PostHogSDK.shared.capture(
            event.name,
            properties: event.parameters.mapValues(\.postHogValue)
        )
    }

    public func identify(userIdentifier: String) {
        PostHogSDK.shared.identify(userIdentifier)
    }

    public func reset() {
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
