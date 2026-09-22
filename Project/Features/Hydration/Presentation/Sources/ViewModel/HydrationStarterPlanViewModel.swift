import Foundation
import HydrationDomain
import MulimiAnalytics
import Observation
import RoutineDomain

@MainActor
@Observable
public final class HydrationStarterPlanViewModel {
    public private(set) var plan: HydrationStarterPlan?
    public private(set) var hasRecordedWater = false
    public private(set) var hasSavedRoutine = false
    public private(set) var dayNumber: Int?
    public private(set) var isRefreshing = false

    private let repository: HydrationStarterPlanRepository
    private let drinkWaterUseCase: DrinkWaterUseCase
    private let routineUseCase: RoutineUseCase
    private let analyticsUseCase: AnalyticsUseCase
    private let calendar: Calendar
    private let nowProvider: @Sendable () -> Date
    private var hasTrackedView = false

    public init(
        repository: HydrationStarterPlanRepository,
        drinkWaterUseCase: DrinkWaterUseCase,
        routineUseCase: RoutineUseCase,
        analyticsUseCase: AnalyticsUseCase = NoOpAnalyticsUseCase(),
        calendar: Calendar = .current,
        nowProvider: @escaping @Sendable () -> Date = { .now }
    ) {
        self.repository = repository
        self.drinkWaterUseCase = drinkWaterUseCase
        self.routineUseCase = routineUseCase
        self.analyticsUseCase = analyticsUseCase
        self.calendar = calendar
        self.nowProvider = nowProvider
        self.plan = repository.fetchPlan()
    }

    public var isAvailable: Bool {
        dayNumber != nil && plan?.isDismissed == false && plan?.isCompleted == false
    }

    public var completedStepCount: Int {
        [hasRecordedWater, hasSavedRoutine, plan?.quickRecordingMethod != nil].filter { $0 }.count
    }

    public func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true
        defer { isRefreshing = false }

        let now = nowProvider()
        plan = repository.fetchPlan()
        dayNumber = plan?.dayNumber(on: now, calendar: calendar)
        if let plan, plan.isDismissed || plan.isCompleted || dayNumber == nil {
            return
        }

        let start = calendar.startOfDay(for: plan?.startedAt ?? now)
        let events = await drinkWaterUseCase.hydrationEvents(in: DateInterval(start: start, end: now))
        guard !Task.isCancelled else { return }
        // Re-read after suspension so a dismissal cannot be overwritten by a refresh.
        plan = repository.fetchPlan()
        guard plan?.isDismissed != true, plan?.isCompleted != true else { return }
        hasRecordedWater = events.contains {
            $0.isOwnedByCurrentApp && $0.volumeML > 0 && $0.consumedAt >= start && $0.consumedAt <= now
        }
        hasSavedRoutine = !routineUseCase.fetchRoutines().isEmpty
        if plan == nil, hasRecordedWater {
            plan = HydrationStarterPlan(startedAt: now)
            persist()
        }
        dayNumber = plan?.dayNumber(on: now, calendar: calendar)
    }

    public func trackViewed() {
        guard isAvailable, !hasTrackedView else { return }
        hasTrackedView = true
        track("starter_plan_viewed")
    }

    public func trackAction(_ action: String) {
        guard isAvailable, ["go_record", "create_routine"].contains(action) else { return }
        track("starter_plan_action_tapped", action: action)
    }

    public func selectQuickRecordingMethod(_ method: HydrationQuickRecordingMethod) {
        guard isAvailable, plan?.quickRecordingMethod != method else { return }
        plan?.quickRecordingMethod = method
        persist()
        track("starter_plan_method_selected", action: method.rawValue)
    }

    public func complete() async -> Bool {
        // Navigation taps and method selection alone must not certify saved data.
        await refresh()
        guard !Task.isCancelled, !isRefreshing, isAvailable, completedStepCount == 3 else { return false }
        plan?.isCompleted = true
        persist()
        track("starter_plan_completed")
        return true
    }

    public func dismiss() {
        guard isAvailable else { return }
        plan?.isDismissed = true
        persist()
        track("starter_plan_dismissed")
    }

    private func persist() {
        if let plan {
            repository.savePlan(plan)
        }
    }

    private func track(_ name: String, action: String? = nil) {
        var parameters: [String: AnalyticsParameterValue] = ["source": .string("starter_plan")]
        if let action {
            parameters["action"] = .string(action)
        }
        analyticsUseCase.track(ProductAnalyticsEvent(name: name, parameters: parameters))
    }
}
