import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("DrinkWaterViewModel Tests")
struct DrinkWaterViewModelTests {
    @MainActor
    @Test("초기화 시 legacy 마이그레이션과 초기 상태를 반영한다")
    func initializeState() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterIntakeMLValue = 500
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.mainIconValue = .heart
        userPreferencesUseCase.dailyWaterLimitValue = 1500

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()

        #expect(waterUseCase.migrateLegacyDataIfNeededCallCount == 1)
        #expect(viewModel.drinkWaterCount == 2)
        #expect(viewModel.mainIcon == .heart)
        #expect(viewModel.dailyLimit == 1500)
        #expect(viewModel.currentWaterIntakeML == 500)
        #expect(viewModel.mililiters == L10n.tr("commonMilliliterFormat", 500))
        #expect(viewModel.isLimitReached == false)
    }

    @MainActor
    @Test("drinkWater는 제한 이하일 때 UseCase 상태를 갱신한다")
    func drinkWaterWithinLimit() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterIntakeMLValue = 0
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        await viewModel.drinkWater()

        #expect(viewModel.drinkWaterCount == 1)
        #expect(waterUseCase.drinkWaterCallCount == 1)
    }

    @MainActor
    @Test("drinkWater는 제한을 초과하면 동작하지 않는다")
    func drinkWaterOverLimit() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterIntakeMLValue = 1_000
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        await viewModel.drinkWater()

        #expect(viewModel.drinkWaterCount == 4)
        #expect(waterUseCase.drinkWaterCallCount == 0)
    }

    @MainActor
    @Test("프리셋 기록은 지정한 ml 단위를 UseCase에 전달한다")
    func recordPresetVolume() async {
        let waterUseCase = MockDrinkWaterUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let analyticsUseCase = MockAnalyticsUseCase()
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader(),
            analyticsUseCase: analyticsUseCase
        )

        await viewModel.loadInitialState()
        let didRecord = await viewModel.recordPresetWater(volumeML: HydrationServing.bottleML)

        #expect(didRecord)
        #expect(viewModel.currentWaterIntakeML == Double(HydrationServing.bottleML))
        #expect(waterUseCase.recordedVolumesML == [HydrationServing.bottleML])
        #expect(analyticsUseCase.trackedEvents.map(\.name) == ["water_logged", "water_preset_logged"])
    }

    @MainActor
    @Test("프리셋 기록은 목표 초과 시 차단된다")
    func recordPresetVolumeOverLimit() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterIntakeMLValue = 900
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        let didRecord = await viewModel.recordWater(volumeML: HydrationServing.bottleML)

        #expect(didRecord == false)
        #expect(viewModel.currentWaterIntakeML == 900)
        #expect(waterUseCase.drinkWaterCallCount == 0)
    }

    @MainActor
    @Test("HealthKit 기록 실패 시 성공 후처리를 실행하지 않고 복구 안내를 노출한다")
    func recordWaterFailureDoesNotRunSuccessEffects() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.drinkWaterResult = .failure(.permissionDenied)
        let widgetReloader = SpyWidgetTimelineReloader()
        let analyticsUseCase = MockAnalyticsUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: widgetReloader,
            analyticsUseCase: analyticsUseCase
        )

        await viewModel.loadInitialState()
        let didRecord = await viewModel.recordWater(volumeML: HydrationServing.defaultGlassVolumeML)

        #expect(didRecord == false)
        #expect(viewModel.currentWaterIntakeML == 0)
        #expect(viewModel.recentRecordUndo == nil)
        #expect(viewModel.recordFailureAlert?.showsOpenSettingsAction == true)
        #expect(
            viewModel.recordFailureAlert?.message ==
            L10n.tr("drinkWaterRecordPermissionFailureDescription")
        )
        #expect(widgetReloader.reloadCallCount == 0)
        #expect(analyticsUseCase.trackedEvents.map(\.name) == ["water_log_failed"])
        #expect(
            analyticsUseCase.trackedEvents.first?.parameters["failure_reason"] ==
            AnalyticsParameterValue.string("healthkit_permission_required")
        )
    }

    @MainActor
    @Test("직접 입력값은 숫자와 목표 초과 여부를 검증한다")
    func customAmountValidation() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterIntakeMLValue = 900
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()

        #expect(viewModel.customAmountValidation(for: "") == .empty)
        #expect(viewModel.customAmountValidation(for: "abc") == .invalid)
        #expect(viewModel.customAmountValidation(for: "101") == .overLimit(remainingML: 100))
        #expect(viewModel.customAmountValidation(for: "100") == .valid(volumeML: 100))
        #expect(viewModel.canRecordCustomAmount("100"))
        #expect(viewModel.canRecordCustomAmount("101") == false)
    }

    @MainActor
    @Test("직접 입력 기록은 입력한 ml 단위를 UseCase에 전달한다")
    func recordCustomAmount() async {
        let waterUseCase = MockDrinkWaterUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        let didRecord = await viewModel.recordCustomAmount("180")

        #expect(didRecord)
        #expect(viewModel.currentWaterIntakeML == 180)
        #expect(waterUseCase.recordedVolumesML == [180])
    }

    @MainActor
    @Test("drinkWater는 기록 후 최신 UseCase 값을 다시 반영한다")
    func drinkWaterRefreshesState() async {
        let waterUseCase = MockDrinkWaterUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        await viewModel.drinkWater()

        #expect(viewModel.drinkWaterCount == 1)
        #expect(waterUseCase.drinkWaterCallCount == 1)
    }

    @MainActor
    @Test("기록 후 최근 기록 되돌리기 모델을 만든다")
    func recordWaterCreatesUndoModel() async {
        let waterUseCase = MockDrinkWaterUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        await viewModel.recordWater(volumeML: HydrationServing.defaultGlassVolumeML)

        #expect(viewModel.recentRecordUndo != nil)
        #expect(viewModel.recentRecordUndo?.title == L10n.tr("drinkWaterUndoRecordTitle"))
    }

    @MainActor
    @Test("최근 기록 되돌리기는 HealthKit 이벤트 삭제 후 상태와 위젯을 갱신한다")
    func undoRecentRecord() async {
        let waterUseCase = MockDrinkWaterUseCase()
        let widgetReloader = SpyWidgetTimelineReloader()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: widgetReloader
        )

        await viewModel.loadInitialState()
        await viewModel.recordWater(volumeML: HydrationServing.defaultGlassVolumeML)
        let undoID = viewModel.recentRecordUndo?.id
        let didUndo = await viewModel.undoRecentRecord()

        #expect(didUndo)
        #expect(waterUseCase.deletedHydrationEventIDs.first == undoID)
        #expect(viewModel.currentWaterIntakeML == 0)
        #expect(viewModel.recentRecordUndo == nil)
        #expect(widgetReloader.reloadCallCount == 2)
    }

    @MainActor
    @Test("최근 기록 되돌리기 실패 시 사용자용 오류를 노출한다")
    func undoRecentRecordFailure() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.shouldDeleteHydrationEventSucceed = false
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        await viewModel.recordWater(volumeML: HydrationServing.defaultGlassVolumeML)
        let didUndo = await viewModel.undoRecentRecord()

        #expect(didUndo == false)
        #expect(viewModel.undoErrorMessage == L10n.tr("drinkWaterUndoRecordFailureDescription"))
        #expect(viewModel.recentRecordUndo != nil)
    }

    @MainActor
    @Test("reset은 카운트를 0으로 만들고 UseCase 리셋을 호출한다")
    func reset() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterIntakeMLValue = 750
        let userPreferencesUseCase = MockUserPreferencesUseCase()

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        await viewModel.reset()

        #expect(viewModel.drinkWaterCount == 0)
        #expect(waterUseCase.resetCallCount == 1)
    }

    @MainActor
    @Test("reset 성공 시 최근 기록 되돌리기 상태와 오류를 정리한다")
    func resetClearsUndoState() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.shouldDeleteHydrationEventSucceed = false
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 1000
        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()
        await viewModel.recordWater(volumeML: HydrationServing.defaultGlassVolumeML)
        _ = await viewModel.undoRecentRecord()

        #expect(viewModel.recentRecordUndo != nil)
        #expect(viewModel.undoErrorMessage != nil)

        await viewModel.reset()

        #expect(viewModel.currentWaterIntakeML == 0)
        #expect(viewModel.recentRecordUndo == nil)
        #expect(viewModel.undoErrorMessage == nil)
        #expect(waterUseCase.resetCallCount == 1)
    }

    @MainActor
    @Test("reset 실패 시 기존 상태를 유지하고 위젯을 갱신하지 않는다")
    func resetFailureDoesNotRunSuccessEffects() async {
        let waterUseCase = MockDrinkWaterUseCase()
        waterUseCase.currentWaterIntakeMLValue = 750
        waterUseCase.resetResult = .failure(.systemError)
        let widgetReloader = SpyWidgetTimelineReloader()
        let userPreferencesUseCase = MockUserPreferencesUseCase()

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: widgetReloader
        )

        await viewModel.loadInitialState()
        await viewModel.reset()

        #expect(viewModel.currentWaterIntakeML == 750)
        #expect(waterUseCase.resetCallCount == 1)
        #expect(viewModel.recordFailureAlert?.title == L10n.tr("drinkWaterResetFailureTitle"))
        #expect(widgetReloader.reloadCallCount == 0)
    }

    @MainActor
    @Test("refreshState는 UseCase 최신값으로 상태를 갱신한다")
    func refreshState() async {
        let waterUseCase = MockDrinkWaterUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()

        let viewModel = DrinkWaterViewModel(
            waterUseCase: waterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.loadInitialState()

        waterUseCase.currentWaterIntakeMLValue = 1_250
        userPreferencesUseCase.mainIconValue = .cloud
        userPreferencesUseCase.dailyWaterLimitValue = 2300

        await viewModel.refreshState()

        #expect(viewModel.drinkWaterCount == 5)
        #expect(viewModel.mainIcon == .cloud)
        #expect(viewModel.dailyLimit == 2300)
    }

    @MainActor
    @Test("refreshState는 다음 한 잔 가이드 문구를 갱신한다")
    func refreshNextActionGuide() async {
        let guideUseCase = StubHydrationNextActionGuideUseCase()
        guideUseCase.guideValue = HydrationNextActionGuide(
            state: .approachingRoutine,
            currentIntakeML: 1_250,
            dailyGoalML: 2_000,
            remainingML: 750,
            remainingGlassCount: 3,
            nextRoutine: HydrationNextRoutineContext(
                id: "routine",
                title: "오전 루틴",
                hour: 10,
                minute: 0,
                minutesUntil: 30
            )
        )
        let viewModel = DrinkWaterViewModel(
            waterUseCase: MockDrinkWaterUseCase(),
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            nextActionGuideUseCase: guideUseCase,
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        await viewModel.refreshState()

        #expect(guideUseCase.guideCallCount == 1)
        let nextRoutineTimeText = guideUseCase.guideValue.nextRoutine?.timeText ?? ""
        #expect(viewModel.nextActionBadgeText == L10n.tr("drinkWaterNextActionBadge"))
        #expect(
            viewModel.nextActionHeadline ==
            L10n.tr(
                "drinkWaterNextActionApproachingRoutineHeadlineFormat",
                L10n.tr("drinkWaterNextActionMinutesFormat", 30)
            )
        )
        #expect(
            viewModel.nextActionDescription ==
            L10n.tr(
                "drinkWaterNextActionRoutineDescriptionFormat",
                nextRoutineTimeText,
                L10n.tr("drinkWaterNextActionMinutesFormat", 30),
                L10n.tr("commonMilliliterFormat", 750),
                3
            )
        )
    }

    @MainActor
    @Test("startAnimation은 offset을 360으로 설정한다")
    func startAnimation() {
        let viewModel = DrinkWaterViewModel(
            waterUseCase: MockDrinkWaterUseCase(),
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            nextActionGuideUseCase: StubHydrationNextActionGuideUseCase(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader()
        )

        viewModel.startAnimation()

        #expect(viewModel.offset == 360)
    }
}

private final class SpyWidgetTimelineReloader: WidgetTimelineReloading, @unchecked Sendable {
    private(set) var reloadCallCount = 0

    func reloadAllTimelines() {
        reloadCallCount += 1
    }
}

private final class StubHydrationNextActionGuideUseCase: HydrationNextActionGuideUseCase, @unchecked Sendable {
    var guideValue = HydrationNextActionGuide.make(
        currentIntakeML: 0,
        dailyGoalML: 2_000
    )
    private(set) var guideCallCount = 0

    func guide(referenceDate: Date, calendar: Calendar) async -> HydrationNextActionGuide {
        guideCallCount += 1
        return guideValue
    }
}
