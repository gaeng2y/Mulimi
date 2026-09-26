import Foundation
import HydrationDomain
import MulimiAnalytics
import RoutineDomain
import Testing

@testable import HydrationPresentation

@MainActor
struct HydrationStarterPlanViewModelTests {
    private let repository = StarterPlanRepositorySpy()
    private let water = MockDrinkWaterUseCase()
    private let routine = StarterPlanRoutineStub()
    private let analytics = MockAnalyticsUseCase()
    private let now = Date(timeIntervalSince1970: 1_800_000_000)

    @Test("실패한 기록·다른 앱 기록·과거 기록으로는 시작하지 않는다")
    func requiresTodaysSavedAppRecord() async {
        let model = makeModel()
        water.drinkWaterResult = .failure(.permissionDenied)
        await water.drinkWater()
        water.setHydrationEvents([
            HydrationEvent(id: UUID(), consumedAt: now, volumeML: 100, isOwnedByCurrentApp: false),
            HydrationEvent(id: UUID(), consumedAt: now, volumeML: 0)
        ], on: now)
        let yesterday = now.addingTimeInterval(-86_400)
        water.setHydrationEvents([event(on: yesterday)], on: yesterday)
        await model.refresh()
        #expect(!model.isAvailable)
        #expect(repository.plan == nil)

        saveWater()
        await model.refresh()
        #expect(model.isAvailable)
        #expect(model.dayNumber == 1)
        #expect(model.completedStepCount == 1)
        #expect(repository.plan?.startedAt == now)
    }

    @Test("이동이나 권한 거부·저장 취소는 루틴 완료가 아니며 알림 없는 실제 저장은 완료다")
    func routineRequiresSavedData() async {
        saveWater()
        let model = makeModel()
        await model.refresh()
        model.trackAction("create_routine")
        await model.refresh()
        #expect(!model.hasSavedRoutine)
        #expect(!(await model.complete()))

        routine.routines = [HydrationRoutine(title: "아침", hour: 9, minute: 0, weekdays: [.monday], isEnabled: false)]
        await model.refresh()
        #expect(model.hasSavedRoutine)
        #expect(model.completedStepCount == 2)
        #expect(!(await model.complete()))
    }

    @Test("기록이나 루틴이 삭제되면 완료 직전 재확인에서 차단한다", arguments: [false, true])
    func completionRechecksSources(removeWater: Bool) async {
        saveWater()
        saveRoutine()
        let model = makeModel()
        await model.refresh()
        model.selectQuickRecordingMethod(.widget)
        #expect(model.completedStepCount == 3)
        if removeWater {
            water.setHydrationEvents([], on: now)
        } else {
            routine.routines = []
        }

        #expect(!(await model.complete()))
        #expect(repository.plan?.isCompleted == false)
        #expect(model.completedStepCount == 2)
    }

    @Test("방법 선택을 유지하며 설치를 주장하지 않고 완료 이벤트는 한 번만 보낸다")
    func selectionAndCompletion() async {
        saveWater()
        saveRoutine()
        let model = makeModel()
        await model.refresh()
        model.trackViewed()
        model.trackViewed()
        model.selectQuickRecordingMethod(.shortcuts)
        model.selectQuickRecordingMethod(.shortcuts)
        let reloaded = makeModel()
        await reloaded.refresh()
        #expect(reloaded.plan?.quickRecordingMethod == .shortcuts)
        #expect(await reloaded.complete())
        #expect(!(await reloaded.complete()))
        #expect(!reloaded.isAvailable)
        #expect(repository.plan?.isCompleted == true)
        #expect(analytics.trackedEvents.map(\.name) == [
            "starter_plan_viewed", "starter_plan_method_selected", "starter_plan_completed"
        ])
        #expect(analytics.trackedEvents[1].parameters["action"] == .string("shortcuts"))
        #expect(analytics.trackedEvents.allSatisfy {
            $0.parameters["source"] == .string("starter_plan") && Set($0.parameters.keys).isSubset(of: ["source", "action"])
        })
    }

    @Test("닫은 안내는 재실행 후 새 기록이 있어도 다시 시작하지 않는다")
    func dismissedPlanStaysDismissed() async {
        saveWater()
        let model = makeModel()
        await model.refresh()
        model.dismiss()
        model.dismiss()
        let reloaded = makeModel()
        await reloaded.refresh()
        reloaded.selectQuickRecordingMethod(.watch)
        #expect(!reloaded.isAvailable)
        #expect(reloaded.plan?.isDismissed == true)
        #expect(reloaded.plan?.quickRecordingMethod == nil)
        #expect(analytics.trackedEvents.map(\.name) == ["starter_plan_dismissed"])
    }

    @Test("기존 시작일을 유지하고 8일 차에는 새 기록이 있어도 만료된다", arguments: [1, 6, 7])
    func doesNotRestart(dayOffset: Int) async {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        let start = calendar.date(byAdding: .day, value: -dayOffset, to: now)!
        repository.plan = HydrationStarterPlan(startedAt: start)
        saveWater()
        let model = makeModel()
        await model.refresh()
        #expect(repository.plan?.startedAt == start)
        #expect(model.isAvailable == (dayOffset < 7))
        #expect(model.dayNumber == (dayOffset < 7 ? dayOffset + 1 : nil))
    }

    @Test("취소한 조회는 안내를 시작하거나 완료하지 않는다")
    func cancelledRefreshDoesNotPersist() async {
        saveWater()
        let model = makeModel()
        let task = Task { await model.refresh() }
        task.cancel()
        await task.value
        #expect(repository.plan == nil)
        #expect(!model.isAvailable)
        #expect(!model.isRefreshing)
    }

    private func makeModel() -> HydrationStarterPlanViewModel {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .gmt
        let now = now
        return HydrationStarterPlanViewModel(
            repository: repository, drinkWaterUseCase: water, routineUseCase: routine,
            analyticsUseCase: analytics, calendar: calendar, nowProvider: { now }
        )
    }

    private func event(on date: Date) -> HydrationEvent {
        HydrationEvent(id: UUID(), consumedAt: date, volumeML: HydrationServing.defaultGlassVolumeML)
    }

    private func saveWater() {
        water.setHydrationEvents([event(on: now)], on: now)
    }

    private func saveRoutine() {
        routine.routines = [HydrationRoutine(title: "아침", hour: 9, minute: 0, weekdays: [.monday], isEnabled: true)]
    }
}

private final class StarterPlanRepositorySpy: HydrationStarterPlanRepository, @unchecked Sendable {
    var plan: HydrationStarterPlan?
    func fetchPlan() -> HydrationStarterPlan? { plan }
    func savePlan(_ plan: HydrationStarterPlan) { self.plan = plan }
}

private final class StarterPlanRoutineStub: RoutineUseCase, @unchecked Sendable {
    var routines: [HydrationRoutine] = []
    func fetchRoutines() -> [HydrationRoutine] { routines }
    func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus { .denied }
    func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus { .denied }
    func saveRoutine(_ routine: HydrationRoutine) async throws { routines.append(routine) }
    func deleteRoutine(id: UUID) async throws { routines.removeAll { $0.id == id } }
}
