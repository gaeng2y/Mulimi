import AccountDomain
import MulimiAnalytics
import MulimiPlatform
import HydrationReminderDomain
import RoutineDomain
import Foundation
import Testing

@testable import AccountPresentation

@Suite("SettingsViewModel Tests")
struct SettingsViewModelTests {
    private struct SpyWidgetTimelineReloader: WidgetTimelineReloading {
        let onReload: @Sendable () -> Void

        func reloadAllTimelines() {
            onReload()
        }
    }

    private final class SpyRoutineUseCase: RoutineUseCase, @unchecked Sendable {
        var routines: [HydrationRoutine]
        var deleteError: Error?

        init(routines: [HydrationRoutine] = []) {
            self.routines = routines
        }

        func fetchRoutines() -> [HydrationRoutine] { routines }
        func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus { .authorized }
        func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus { .authorized }
        func saveRoutine(_ routine: HydrationRoutine) async throws {}

        func deleteRoutine(id: UUID) async throws {
            if let deleteError { throw deleteError }
            routines.removeAll { $0.id == id }
        }
    }

    private static func makeRoutines() -> [HydrationRoutine] {
        [
            HydrationRoutine(title: "아침", hour: 8, minute: 0, weekdays: [.monday], isEnabled: true),
            HydrationRoutine(title: "저녁", hour: 20, minute: 0, weekdays: [.friday], isEnabled: false)
        ]
    }

    private enum MockError: LocalizedError {
        case deleteFailed

        var errorDescription: String? {
            switch self {
            case .deleteFailed:
                return "delete-failed"
            }
        }
    }

    @MainActor
    @Test("초기화 시 사용자 설정 상태를 반영한다")
    func initializeState() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.mainIconValue = .heart
        userPreferencesUseCase.dailyWaterLimitValue = 2100
        let signInUseCase = MockSignInUseCase()
        let appSession = AppSession(isAuthenticated: true)

        let viewModel = SettingsViewModel(
            userPreferencesUseCase: userPreferencesUseCase,
            signInUseCase: signInUseCase,
            hydrationReminderUseCase: MockHydrationReminderUseCase(),
            routineUseCase: SpyRoutineUseCase(),
            appSession: appSession,
            widgetTimelineReloader: NoOpWidgetTimelineReloader(),
            appInfoProvider: StaticAppInfoProvider(appVersion: "1.2.0", appBuildNumber: "15")
        )

        #expect(viewModel.currentMainIcon == .heart)
        #expect(viewModel.currentDailyWaterLimit == 2100)
        #expect(viewModel.appVersion == "1.2.0")
        #expect(viewModel.appBuildNumber == "15")
        #expect(userPreferencesUseCase.getMainIconCallCount == 1)
        #expect(userPreferencesUseCase.getDailyWaterLimitCallCount == 1)
    }

    @MainActor
    @Test("setMainIcon는 상태와 UseCase를 함께 갱신한다")
    func setMainIcon() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        final class ReloadCounter: @unchecked Sendable {
            var count = 0
        }
        let counter = ReloadCounter()
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: userPreferencesUseCase,
            signInUseCase: MockSignInUseCase(),
            hydrationReminderUseCase: MockHydrationReminderUseCase(),
            routineUseCase: SpyRoutineUseCase(),
            appSession: AppSession(),
            widgetTimelineReloader: SpyWidgetTimelineReloader {
                counter.count += 1
            },
            appInfoProvider: StaticAppInfoProvider(appVersion: "1.2.0", appBuildNumber: "15")
        )

        viewModel.setMainIcon(.cloud)

        #expect(viewModel.currentMainIcon == .cloud)
        #expect(userPreferencesUseCase.setMainIconCallCount == 1)
        #expect(userPreferencesUseCase.capturedMainIcon == .cloud)
        #expect(counter.count == 1)
    }

    @MainActor
    @Test("dailyWaterLimit setter는 상태와 UseCase를 함께 갱신한다")
    func setDailyWaterLimit() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        final class ReloadCounter: @unchecked Sendable {
            var count = 0
        }
        let counter = ReloadCounter()
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: userPreferencesUseCase,
            signInUseCase: MockSignInUseCase(),
            hydrationReminderUseCase: MockHydrationReminderUseCase(),
            routineUseCase: SpyRoutineUseCase(),
            appSession: AppSession(),
            widgetTimelineReloader: SpyWidgetTimelineReloader {
                counter.count += 1
            },
            appInfoProvider: StaticAppInfoProvider(appVersion: "1.2.0", appBuildNumber: "15")
        )

        viewModel.dailyWaterLimit = 2750

        #expect(viewModel.currentDailyWaterLimit == 2750)
        #expect(userPreferencesUseCase.setDailyWaterLimitCallCount == 1)
        #expect(userPreferencesUseCase.capturedDailyWaterLimit == 2750)
        #expect(counter.count == 1)
    }

    @MainActor
    @Test("requestWithdrawal/cancelWithdrawal은 확인 상태를 토글한다")
    func withdrawalRequestAndCancel() {
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            signInUseCase: MockSignInUseCase(),
            hydrationReminderUseCase: MockHydrationReminderUseCase(),
            routineUseCase: SpyRoutineUseCase(),
            appSession: AppSession(),
            widgetTimelineReloader: NoOpWidgetTimelineReloader(),
            appInfoProvider: StaticAppInfoProvider(appVersion: "1.2.0", appBuildNumber: "15")
        )

        viewModel.requestWithdrawal()
        #expect(viewModel.showWithdrawalConfirmation == true)

        viewModel.withdrawalError = "temporary-error"
        viewModel.cancelWithdrawal()
        #expect(viewModel.showWithdrawalConfirmation == false)
        #expect(viewModel.withdrawalError == nil)
    }

    @MainActor
    @Test("confirmWithdrawal 성공 시 인증 상태를 false로 전환한다")
    func confirmWithdrawalSuccess() async {
        let signInUseCase = MockSignInUseCase()
        signInUseCase.isAuthenticatedValue = true
        let analyticsUseCase = MockAnalyticsUseCase()
        let hydrationReminderUseCase = MockHydrationReminderUseCase()
        let routineUseCase = SpyRoutineUseCase(routines: Self.makeRoutines())
        let appSession = AppSession(isAuthenticated: true)
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            signInUseCase: signInUseCase,
            hydrationReminderUseCase: hydrationReminderUseCase,
            routineUseCase: routineUseCase,
            appSession: appSession,
            widgetTimelineReloader: NoOpWidgetTimelineReloader(),
            appInfoProvider: StaticAppInfoProvider(appVersion: "1.2.0", appBuildNumber: "15"),
            analyticsUseCase: analyticsUseCase
        )
        viewModel.requestWithdrawal()

        await viewModel.confirmWithdrawal()

        #expect(routineUseCase.routines.isEmpty)
        #expect(signInUseCase.deleteAccountCallCount == 1)
        #expect(hydrationReminderUseCase.cancelRemindersCallCount == 1)
        #expect(analyticsUseCase.resetCallCount == 1)
        #expect(viewModel.isWithdrawing == false)
        #expect(viewModel.showWithdrawalConfirmation == false)
        #expect(viewModel.withdrawalError == nil)
        #expect(appSession.isAuthenticated == false)
    }

    @MainActor
    @Test("confirmWithdrawal 실패 시 에러를 노출하고 인증 상태를 유지한다")
    func confirmWithdrawalFailure() async {
        let signInUseCase = MockSignInUseCase()
        signInUseCase.deleteAccountError = MockError.deleteFailed
        let hydrationReminderUseCase = MockHydrationReminderUseCase()
        let routineUseCase = SpyRoutineUseCase()
        let appSession = AppSession(isAuthenticated: true)
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            signInUseCase: signInUseCase,
            hydrationReminderUseCase: hydrationReminderUseCase,
            routineUseCase: routineUseCase,
            appSession: appSession,
            widgetTimelineReloader: NoOpWidgetTimelineReloader(),
            appInfoProvider: StaticAppInfoProvider(appVersion: "1.2.0", appBuildNumber: "15")
        )
        viewModel.requestWithdrawal()

        await viewModel.confirmWithdrawal()

        #expect(signInUseCase.deleteAccountCallCount == 1)
        #expect(hydrationReminderUseCase.cancelRemindersCallCount == 0)
        #expect(viewModel.isWithdrawing == false)
        #expect(viewModel.showWithdrawalConfirmation == true)
        #expect(viewModel.withdrawalError == MockError.deleteFailed.localizedDescription)
        #expect(appSession.isAuthenticated == true)
    }

    @MainActor
    @Test("루틴 정리에 실패하면 계정을 유지하고 재시도로 탈퇴를 마친다")
    func confirmWithdrawalRoutineFailureKeepsAccountUntilRetry() async {
        let signInUseCase = MockSignInUseCase()
        let hydrationReminderUseCase = MockHydrationReminderUseCase()
        let routineUseCase = SpyRoutineUseCase(routines: Self.makeRoutines())
        routineUseCase.deleteError = MockError.deleteFailed
        let appSession = AppSession(isAuthenticated: true)
        let viewModel = SettingsViewModel(
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            signInUseCase: signInUseCase,
            hydrationReminderUseCase: hydrationReminderUseCase,
            routineUseCase: routineUseCase,
            appSession: appSession,
            widgetTimelineReloader: NoOpWidgetTimelineReloader(),
            appInfoProvider: StaticAppInfoProvider(appVersion: "1.2.0", appBuildNumber: "15")
        )
        viewModel.requestWithdrawal()

        await viewModel.confirmWithdrawal()

        #expect(routineUseCase.routines.count == 2)
        #expect(signInUseCase.deleteAccountCallCount == 0)
        #expect(hydrationReminderUseCase.cancelRemindersCallCount == 0)
        #expect(viewModel.withdrawalError == MockError.deleteFailed.localizedDescription)
        #expect(appSession.isAuthenticated == true)

        routineUseCase.deleteError = nil
        await viewModel.confirmWithdrawal()

        #expect(routineUseCase.routines.isEmpty)
        #expect(signInUseCase.deleteAccountCallCount == 1)
        #expect(appSession.isAuthenticated == false)
    }
}
