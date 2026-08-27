import CoreDomain
import HydrationDomain

public extension ProductAnalyticsEvent {
    static func healthKitPermissionGateViewed(
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        healthKitPermissionEvent(name: "healthkit_permission_gate_viewed", status: status)
    }

    static func healthKitPermissionRequestTapped(
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        healthKitPermissionEvent(name: "healthkit_permission_request_tapped", status: status)
    }

    static func healthKitPermissionAuthorized(
        source: String,
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        healthKitPermissionEvent(
            name: "healthkit_permission_authorized",
            status: status,
            source: source
        )
    }

    static func healthKitPermissionDenied(
        source: String,
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        healthKitPermissionEvent(
            name: "healthkit_permission_denied",
            status: status,
            source: source
        )
    }

    static func healthKitPermissionSettingsTapped(
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        healthKitPermissionEvent(name: "healthkit_permission_settings_tapped", status: status)
    }

    static func healthKitPermissionRefreshTapped(
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        healthKitPermissionEvent(name: "healthkit_permission_refresh_tapped", status: status)
    }

    private static func healthKitPermissionEvent(
        name: String,
        status: HealthKitAuthorizationStatus,
        source: String? = nil
    ) -> ProductAnalyticsEvent {
        var parameters: [String: AnalyticsParameterValue] = [
            "status": .string(status.analyticsValue)
        ]
        if let source {
            parameters["source"] = .string(source)
        }
        return ProductAnalyticsEvent(name: name, parameters: parameters)
    }
}

private extension HealthKitAuthorizationStatus {
    var analyticsValue: String {
        switch self {
        case .notDetermined:
            "not_determined"
        case .sharingDenied:
            "denied"
        case .sharingAuthorized:
            "authorized"
        }
    }
}
