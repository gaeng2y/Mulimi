import AccountDomain
import Foundation
import HydrationDomain
import MulimiAnalytics
import MulimiPlatform

public enum HydrationReminderActionResult: String, Sendable {
    case saved, failed, permissionRequired, goalExceeded, protectedDataUnavailable, signInRequired, duplicate
}

@MainActor
public final class HydrationReminderActionHandler {
    private let waterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let analytics: AnalyticsUseCase
    private let widgetReloader: any WidgetTimelineReloading
    private var inFlight = Set<String>()
    // One receipt per repeating request keeps memory bounded by the reminder schedule.
    private var completed: [String: Date] = [:]

    public init(
        waterUseCase: DrinkWaterUseCase,
        userPreferencesUseCase: UserPreferencesUseCase,
        analytics: AnalyticsUseCase,
        widgetReloader: any WidgetTimelineReloading
    ) {
        self.waterUseCase = waterUseCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.analytics = analytics
        self.widgetReloader = widgetReloader
    }

    public func handle(
        requestIdentifier: String,
        deliveredAt: Date,
        respondedAt: Date = .now,
        isProtectedDataAvailable: Bool,
        isAuthenticated: Bool
    ) async -> HydrationReminderActionResult {
        let occurrence = "\(requestIdentifier).\(deliveredAt.timeIntervalSince1970)"
        let delay = respondedAt.timeIntervalSince(deliveredAt)
        let parameters: [String: AnalyticsParameterValue] = [
            "source": .string("notification_action"),
            "within_attribution_window": .bool((0...600).contains(delay))
        ]
        guard !inFlight.contains(occurrence), completed[requestIdentifier] != deliveredAt else {
            return .duplicate
        }
        inFlight.insert(occurrence)
        defer { inFlight.remove(occurrence) }
        analytics.track(ProductAnalyticsEvent(name: "hydration_reminder_action_selected", parameters: parameters))

        let dailyGoalML = userPreferencesUseCase.getDailyWaterLimit()
        let result: HydrationReminderActionResult
        if !isAuthenticated {
            result = .signInRequired
        } else if !isProtectedDataAvailable {
            result = .protectedDataUnavailable
        } else {
            let write = await waterUseCase.drinkWaterFromReminder(
                idempotencyKey: occurrence,
                dailyGoalML: dailyGoalML
            )
            switch write {
            case .saved: result = .saved
            case .goalExceeded: result = .goalExceeded
            case .failed(.permissionDenied): result = .permissionRequired
            case .failed: result = .failed
            }
        }

        if result == .saved {
            completed[requestIdentifier] = deliveredAt
            widgetReloader.reloadAllTimelines()
            analytics.track(.waterLogged(
                source: "notification_action",
                servingType: "default_glass",
                volumeML: HydrationServing.defaultGlassVolumeML,
                dailyGoalML: Int(dailyGoalML.rounded())
            ))
        }
        var outcomeParameters = parameters
        outcomeParameters["status"] = .string(result.rawValue)
        analytics.track(ProductAnalyticsEvent(name: "hydration_reminder_action_result", parameters: outcomeParameters))
        return result
    }
}
