import MulimiAnalytics
import HydrationReminderDomain

private enum HydrationReminderAnalyticsParameterName {
    static let source = "source"
    static let status = "status"
}

public extension ProductAnalyticsEvent {
    static func hydrationReminderPrimingViewed(
        status: HydrationReminderAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "hydration_reminder_priming_viewed",
            parameters: [
                HydrationReminderAnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func hydrationReminderPermissionRequestTapped(
        status: HydrationReminderAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "hydration_reminder_request_tapped",
            parameters: [
                HydrationReminderAnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func hydrationReminderPermissionAuthorized(
        source: String,
        status: HydrationReminderAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "hydration_reminder_permission_authorized",
            parameters: [
                HydrationReminderAnalyticsParameterName.source: .string(source),
                HydrationReminderAnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func hydrationReminderPermissionDenied(
        source: String,
        status: HydrationReminderAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "hydration_reminder_permission_denied",
            parameters: [
                HydrationReminderAnalyticsParameterName.source: .string(source),
                HydrationReminderAnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func hydrationReminderPrimingSkipped(
        status: HydrationReminderAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "hydration_reminder_priming_skipped",
            parameters: [
                HydrationReminderAnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }
}

private extension HydrationReminderAuthorizationStatus {
    var analyticsValue: String {
        switch self {
        case .notDetermined:
            return "not_determined"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        }
    }
}
