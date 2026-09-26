import AccountDomain
import Foundation
import HydrationDomain
import MulimiPlatform
import Testing
@testable import HydrationPresentation

@MainActor
struct HydrationReminderActionHandlerTests {
    private final class WidgetReloader: WidgetTimelineReloading, @unchecked Sendable {
        var reloadCount = 0
        func reloadAllTimelines() { reloadCount += 1 }
    }

    @Test("같은 전달의 중복 탭은 한 번 저장하고 다음 주 알림은 새로 저장한다")
    func duplicateAndNextOccurrence() async {
        let water = MockDrinkWaterUseCase()
        water.shouldSuspendNextDrinkWater = true
        let analytics = MockAnalyticsUseCase()
        let widgets = WidgetReloader()
        let handler = makeHandler(water: water, analytics: analytics, widgets: widgets)
        let date = Date.now
        let first = Task { await handle(handler, date: date) }
        while !water.hasPendingDrinkWater { await Task.yield() }
        #expect(await handle(handler, date: date) == .duplicate)
        water.resumeDrinkWater()
        #expect(await first.value == .saved)
        #expect(await handle(handler, date: date) == .duplicate)
        #expect(await handle(handler, date: date.addingTimeInterval(7 * 86_400)) == .saved)
        #expect(water.drinkWaterCallCount == 2)
        #expect(widgets.reloadCount == 2)
        #expect(Set(water.recordedIdempotencyKeys.compactMap { $0 }).count == 2)
        #expect(analytics.trackedEvents.filter { $0.name == "hydration_reminder_action_selected" }.count == 2)
    }

    @Test("실패는 성공 이벤트나 위젯 갱신 없이 보고하고 재시도할 수 있다")
    func failureAndRetry() async {
        let water = MockDrinkWaterUseCase()
        water.drinkWaterResult = .failure(.permissionDenied)
        let analytics = MockAnalyticsUseCase()
        let widgets = WidgetReloader()
        let handler = makeHandler(water: water, analytics: analytics, widgets: widgets)
        let date = Date.now
        #expect(await handle(handler, date: date) == .permissionRequired)
        #expect(widgets.reloadCount == 0)
        #expect(!analytics.trackedEvents.contains { $0.name == "water_logged" })
        #expect(analytics.trackedEvents.last?.parameters["status"] == .string("permissionRequired"))
        water.drinkWaterResult = .success
        #expect(await handle(handler, date: date) == .saved)
        #expect(water.recordedIdempotencyKeys.first == water.recordedIdempotencyKeys.last)
    }

    @Test("잠금 또는 로그아웃 상태에서는 쓰지 않는다")
    func unavailableState() async {
        let water = MockDrinkWaterUseCase()
        let handler = makeHandler(water: water)
        #expect(await handle(handler, unlocked: false) == .protectedDataUnavailable)
        #expect(await handle(handler, authenticated: false) == .signInRequired)
        #expect(water.drinkWaterCallCount == 0)
    }

    @Test("전달 후 10분의 경계를 구분하되 오래된 알림도 명시적으로 기록할 수 있다", arguments: [0.0, 600.0, 601.0])
    func attributionWindow(delay: Double) async {
        let analytics = MockAnalyticsUseCase()
        let handler = makeHandler(analytics: analytics)
        let date = Date.now
        #expect(await handler.handle(
            requestIdentifier: "hydrationReminder.morning.1", deliveredAt: date,
            respondedAt: date.addingTimeInterval(delay), isProtectedDataAvailable: true, isAuthenticated: true
        ) == .saved)
        #expect(analytics.trackedEvents.last?.parameters["within_attribution_window"] == .bool(delay <= 600))
    }

    private func makeHandler(
        water: MockDrinkWaterUseCase = MockDrinkWaterUseCase(),
        analytics: MockAnalyticsUseCase = MockAnalyticsUseCase(),
        widgets: WidgetReloader = WidgetReloader()
    ) -> HydrationReminderActionHandler {
        let preferences = MockUserPreferencesUseCase()
        preferences.dailyWaterLimitValue = 2_000
        return HydrationReminderActionHandler(
            waterUseCase: water, userPreferencesUseCase: preferences, analytics: analytics, widgetReloader: widgets
        )
    }

    private func handle(
        _ handler: HydrationReminderActionHandler,
        date: Date = .now,
        unlocked: Bool = true,
        authenticated: Bool = true
    ) async -> HydrationReminderActionResult {
        await handler.handle(
            requestIdentifier: "hydrationReminder.morning.1", deliveredAt: date,
            isProtectedDataAvailable: unlocked, isAuthenticated: authenticated
        )
    }
}
