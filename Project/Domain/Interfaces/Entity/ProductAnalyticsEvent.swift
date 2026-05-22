import Foundation

public enum AnalyticsParameterValue: Equatable, Sendable {
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
}

public struct ProductAnalyticsEvent: Equatable, Sendable {
    public let name: String
    public let parameters: [String: AnalyticsParameterValue]

    public init(
        name: String,
        parameters: [String: AnalyticsParameterValue] = [:]
    ) {
        self.name = name
        self.parameters = parameters
    }
}

private enum AnalyticsParameterName {
    static let source = "source"
    static let context = "context"
    static let status = "status"
    static let volumeML = "volume_ml"
    static let dailyGoalML = "daily_goal_ml"
    static let servingType = "serving_type"
    static let failureReason = "failure_reason"
    static let preset = "preset"
    static let enabled = "enabled"
    static let weekdayCount = "weekday_count"
    static let action = "action"
    static let challengeKind = "challenge_kind"
    static let previousGoalML = "previous_goal_ml"
    static let newGoalML = "new_goal_ml"
}

public extension ProductAnalyticsEvent {
    static func onboardingCompleted(source: String = "onboarding") -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "onboarding_completed",
            parameters: [
                AnalyticsParameterName.source: .string(source)
            ]
        )
    }

    static func healthKitPermissionGateViewed(
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "healthkit_permission_gate_viewed",
            parameters: [
                AnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func healthKitPermissionRequestTapped(
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "healthkit_permission_request_tapped",
            parameters: [
                AnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func healthKitPermissionAuthorized(
        source: String,
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "healthkit_permission_authorized",
            parameters: [
                AnalyticsParameterName.source: .string(source),
                AnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func healthKitPermissionDenied(
        source: String,
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "healthkit_permission_denied",
            parameters: [
                AnalyticsParameterName.source: .string(source),
                AnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func healthKitPermissionSettingsTapped(
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "healthkit_permission_settings_tapped",
            parameters: [
                AnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func healthKitPermissionRefreshTapped(
        status: HealthKitAuthorizationStatus
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "healthkit_permission_refresh_tapped",
            parameters: [
                AnalyticsParameterName.status: .string(status.analyticsValue)
            ]
        )
    }

    static func waterLogged(
        source: String,
        servingType: String,
        volumeML: Int,
        dailyGoalML: Int
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "water_logged",
            parameters: [
                AnalyticsParameterName.source: .string(source),
                AnalyticsParameterName.servingType: .string(servingType),
                AnalyticsParameterName.volumeML: .int(volumeML),
                AnalyticsParameterName.dailyGoalML: .int(dailyGoalML)
            ]
        )
    }

    static func waterPresetLogged(
        source: String,
        preset: String,
        volumeML: Int
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "water_preset_logged",
            parameters: [
                AnalyticsParameterName.source: .string(source),
                AnalyticsParameterName.preset: .string(preset),
                AnalyticsParameterName.volumeML: .int(volumeML)
            ]
        )
    }

    static func waterLogFailed(
        source: String,
        servingType: String,
        failureReason: String,
        volumeML: Int? = nil,
        dailyGoalML: Int? = nil
    ) -> ProductAnalyticsEvent {
        var parameters: [String: AnalyticsParameterValue] = [
            AnalyticsParameterName.source: .string(source),
            AnalyticsParameterName.servingType: .string(servingType),
            AnalyticsParameterName.failureReason: .string(failureReason)
        ]

        if let volumeML {
            parameters[AnalyticsParameterName.volumeML] = .int(volumeML)
        }

        if let dailyGoalML {
            parameters[AnalyticsParameterName.dailyGoalML] = .int(dailyGoalML)
        }

        return ProductAnalyticsEvent(
            name: "water_log_failed",
            parameters: parameters
        )
    }

    static func routineCreated(
        source: String,
        enabled: Bool,
        weekdayCount: Int
    ) -> ProductAnalyticsEvent {
        routineEvent(
            name: "routine_created",
            source: source,
            enabled: enabled,
            weekdayCount: weekdayCount
        )
    }

    static func routineUpdated(
        source: String,
        enabled: Bool,
        weekdayCount: Int
    ) -> ProductAnalyticsEvent {
        routineEvent(
            name: "routine_updated",
            source: source,
            enabled: enabled,
            weekdayCount: weekdayCount
        )
    }

    static func routineDeleted(
        source: String,
        enabled: Bool,
        weekdayCount: Int
    ) -> ProductAnalyticsEvent {
        routineEvent(
            name: "routine_deleted",
            source: source,
            enabled: enabled,
            weekdayCount: weekdayCount
        )
    }

    static func insightCTATapped(
        source: String,
        context: String,
        action: String
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "insight_cta_tapped",
            parameters: [
                AnalyticsParameterName.source: .string(source),
                AnalyticsParameterName.context: .string(context),
                AnalyticsParameterName.action: .string(action)
            ]
        )
    }

    static func challengeCTATapped(
        source: String,
        challengeKind: String,
        action: String
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "challenge_cta_tapped",
            parameters: [
                AnalyticsParameterName.source: .string(source),
                AnalyticsParameterName.challengeKind: .string(challengeKind),
                AnalyticsParameterName.action: .string(action)
            ]
        )
    }

    static func dailyGoalChanged(
        source: String,
        previousGoalML: Int,
        newGoalML: Int
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: "daily_goal_changed",
            parameters: [
                AnalyticsParameterName.source: .string(source),
                AnalyticsParameterName.previousGoalML: .int(previousGoalML),
                AnalyticsParameterName.newGoalML: .int(newGoalML)
            ]
        )
    }

    private static func routineEvent(
        name: String,
        source: String,
        enabled: Bool,
        weekdayCount: Int
    ) -> ProductAnalyticsEvent {
        ProductAnalyticsEvent(
            name: name,
            parameters: [
                AnalyticsParameterName.source: .string(source),
                AnalyticsParameterName.enabled: .bool(enabled),
                AnalyticsParameterName.weekdayCount: .int(weekdayCount)
            ]
        )
    }
}

private extension HealthKitAuthorizationStatus {
    var analyticsValue: String {
        switch self {
        case .notDetermined:
            return "not_determined"
        case .sharingDenied:
            return "denied"
        case .sharingAuthorized:
            return "authorized"
        }
    }
}
