import CoreDomain
import Foundation
import HydrationReminderDomain
import Localization
import Testing

@testable import HydrationReminderPresentation

@Suite("HydrationReminderPermissionViewModel Tests")
struct HydrationReminderPermissionViewModelTests {
    private enum MockError: Error {
        case failed
    }

    @MainActor
    @Test("프라이밍을 본 적 없으면 초기 상태는 미완료·미준비다")
    func initialStateShowsPriming() {
        let useCase = MockHydrationReminderUseCase()

        let viewModel = HydrationReminderPermissionViewModel(hydrationReminderUseCase: useCase)

        #expect(viewModel.isFinished == false)
        #expect(viewModel.isPrepared == false)
    }

    @MainActor
    @Test("프라이밍을 이미 봤으면 초기 상태부터 완료다")
    func initialStateSkipsPrimingWhenAlreadySeen() {
        let useCase = MockHydrationReminderUseCase()
        useCase.hasSeenPermissionPrimingValue = true

        let viewModel = HydrationReminderPermissionViewModel(hydrationReminderUseCase: useCase)

        #expect(viewModel.isFinished)
    }

    @MainActor
    @Test("prepareIfNeeded는 notDetermined 상태에서 자동으로 권한을 요청하지 않는다")
    func prepareIfNeededDoesNotRequestAuthorizationAutomatically() async {
        let useCase = MockHydrationReminderUseCase()
        let analyticsUseCase = MockAnalyticsUseCase()

        let viewModel = HydrationReminderPermissionViewModel(
            hydrationReminderUseCase: useCase,
            analyticsUseCase: analyticsUseCase
        )

        await viewModel.prepareIfNeeded()

        #expect(useCase.requestAuthorizationCallCount == 0)
        #expect(viewModel.isFinished == false)
        #expect(viewModel.isPrepared)
        #expect(analyticsUseCase.trackedEvents.map(\.name) == ["hydration_reminder_priming_viewed"])
    }

    @MainActor
    @Test("prepareIfNeeded는 이미 결정된 권한 상태면 프라이밍을 건너뛰고 동기화한다")
    func prepareIfNeededFinishesWhenStatusAlreadyDetermined() async {
        let useCase = MockHydrationReminderUseCase()
        useCase.authorizationStatusValue = .authorized

        let viewModel = HydrationReminderPermissionViewModel(hydrationReminderUseCase: useCase)

        await viewModel.prepareIfNeeded()

        #expect(viewModel.isFinished)
        #expect(viewModel.isPrepared)
        #expect(useCase.markPermissionPrimingSeenCallCount == 1)
        #expect(useCase.syncRemindersCallCount == 1)
        #expect(useCase.requestAuthorizationCallCount == 0)
    }

    @MainActor
    @Test("prepareIfNeeded는 프라이밍을 본 사용자의 리마인더를 한 번만 동기화한다")
    func prepareIfNeededSyncsOnceForReturningUser() async {
        let useCase = MockHydrationReminderUseCase()
        useCase.hasSeenPermissionPrimingValue = true
        useCase.authorizationStatusValue = .authorized

        let viewModel = HydrationReminderPermissionViewModel(hydrationReminderUseCase: useCase)

        await viewModel.prepareIfNeeded()
        await viewModel.prepareIfNeeded()

        #expect(useCase.syncRemindersCallCount == 1)
    }

    @MainActor
    @Test("requestPermission 허용 시 완료 처리하고 허용 이벤트를 남긴다")
    func requestPermissionAuthorized() async {
        let useCase = MockHydrationReminderUseCase()
        useCase.requestAuthorizationResult = .success(.authorized)
        let analyticsUseCase = MockAnalyticsUseCase()

        let viewModel = HydrationReminderPermissionViewModel(
            hydrationReminderUseCase: useCase,
            analyticsUseCase: analyticsUseCase
        )

        await viewModel.requestPermission()

        #expect(useCase.requestAuthorizationCallCount == 1)
        #expect(viewModel.authorizationStatus == .authorized)
        #expect(viewModel.isFinished)
        #expect(viewModel.errorMessage == nil)
        #expect(useCase.markPermissionPrimingSeenCallCount == 1)
        #expect(analyticsUseCase.trackedEvents.map(\.name) == [
            "hydration_reminder_request_tapped",
            "hydration_reminder_permission_authorized"
        ])
    }

    @MainActor
    @Test("requestPermission 거부 시에도 완료 처리하고 거부 이벤트를 남긴다")
    func requestPermissionDenied() async {
        let useCase = MockHydrationReminderUseCase()
        useCase.requestAuthorizationResult = .success(.denied)
        let analyticsUseCase = MockAnalyticsUseCase()

        let viewModel = HydrationReminderPermissionViewModel(
            hydrationReminderUseCase: useCase,
            analyticsUseCase: analyticsUseCase
        )

        await viewModel.requestPermission()

        #expect(viewModel.authorizationStatus == .denied)
        #expect(viewModel.isFinished)
        #expect(analyticsUseCase.trackedEvents.map(\.name) == [
            "hydration_reminder_request_tapped",
            "hydration_reminder_permission_denied"
        ])
    }

    @MainActor
    @Test("requestPermission 실패 시 에러 메시지를 남기고 프라이밍에 머문다")
    func requestPermissionFailure() async {
        let useCase = MockHydrationReminderUseCase()
        useCase.requestAuthorizationResult = .failure(MockError.failed)

        let viewModel = HydrationReminderPermissionViewModel(hydrationReminderUseCase: useCase)

        await viewModel.requestPermission()

        #expect(viewModel.isFinished == false)
        #expect(viewModel.errorMessage == L10n.tr("hydrationReminderPrimingRequestFailureDescription"))
        #expect(useCase.markPermissionPrimingSeenCallCount == 0)
    }

    @MainActor
    @Test("skipPriming은 프라이밍 노출 완료를 저장하고 스킵 이벤트를 남긴다")
    func skipPriming() {
        let useCase = MockHydrationReminderUseCase()
        let analyticsUseCase = MockAnalyticsUseCase()

        let viewModel = HydrationReminderPermissionViewModel(
            hydrationReminderUseCase: useCase,
            analyticsUseCase: analyticsUseCase
        )

        viewModel.skipPriming()

        #expect(viewModel.isFinished)
        #expect(useCase.markPermissionPrimingSeenCallCount == 1)
        #expect(useCase.requestAuthorizationCallCount == 0)
        #expect(analyticsUseCase.trackedEvents.map(\.name) == ["hydration_reminder_priming_skipped"])
    }

    @MainActor
    @Test("markSignedOut는 에러를 초기화하고 저장된 프라이밍 상태를 유지한다")
    func markSignedOutKeepsPersistedPrimingState() async {
        let useCase = MockHydrationReminderUseCase()
        useCase.requestAuthorizationResult = .failure(MockError.failed)

        let viewModel = HydrationReminderPermissionViewModel(hydrationReminderUseCase: useCase)

        await viewModel.prepareIfNeeded()
        await viewModel.requestPermission()
        viewModel.markSignedOut()

        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isFinished == false)
        #expect(viewModel.isPrepared == false)

        useCase.hasSeenPermissionPrimingValue = true
        viewModel.markSignedOut()

        #expect(viewModel.isFinished)
    }
}
