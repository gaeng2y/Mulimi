import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("ProfileRoutineViewModel Tests")
struct ProfileRoutineViewModelTests {
    private final class SpyRoutineUseCase: RoutineUseCase, @unchecked Sendable {
        var routines: [HydrationRoutine] = []
        var authorizationStatus: RoutineNotificationAuthorizationStatus = .notDetermined
        var requestAuthorizationResult: Result<RoutineNotificationAuthorizationStatus, Error> = .success(.authorized)
        private(set) var savedRoutine: HydrationRoutine?
        private(set) var deletedRoutineID: UUID?
        private(set) var requestAuthorizationCallCount = 0

        func fetchRoutines() -> [HydrationRoutine] {
            routines
        }

        func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus {
            authorizationStatus
        }

        func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
            requestAuthorizationCallCount += 1
            switch requestAuthorizationResult {
            case .success(let status):
                authorizationStatus = status
                return status
            case .failure(let error):
                throw error
            }
        }

        func saveRoutine(_ routine: HydrationRoutine) async throws {
            savedRoutine = routine
            if let index = routines.firstIndex(where: { $0.id == routine.id }) {
                routines[index] = routine
            } else {
                routines.append(routine)
            }
        }

        func deleteRoutine(id: UUID) async throws {
            deletedRoutineID = id
            routines.removeAll { $0.id == id }
        }
    }

    private final class SpyDrinkWaterUseCase: DrinkWaterUseCase, @unchecked Sendable {
        var currentWaterValue = 0

        var currentWater: Int {
            get async {
                currentWaterValue
            }
        }

        func hydrationEvents(on date: Date) async -> [HydrationEvent] {
            []
        }

        func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent] {
            []
        }

        func migrateLegacyDataIfNeeded() async {}

        func drinkWater() async {}

        func reset() async {}
    }

    private final class SpyUserPreferencesUseCase: UserPreferencesUseCase, @unchecked Sendable {
        var dailyWaterLimit: Double = 2000

        func getMainAppearance() -> MainAppearance {
            .drop
        }

        func setMainAppearance(_ appearance: MainAppearance) {}

        func getDailyWaterLimit() -> Double {
            dailyWaterLimit
        }

        func setDailyWaterLimit(_ limit: Double) {
            dailyWaterLimit = limit
        }
    }

    @MainActor
    private func makeViewModel(
        routineUseCase: SpyRoutineUseCase = SpyRoutineUseCase(),
        drinkWaterUseCase: SpyDrinkWaterUseCase = SpyDrinkWaterUseCase(),
        userPreferencesUseCase: SpyUserPreferencesUseCase = SpyUserPreferencesUseCase(),
        now: Date? = nil
    ) -> ProfileRoutineViewModel {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        let referenceDate = now ?? makeDate(year: 2026, month: 3, day: 16, hour: 10, minute: 30)

        return ProfileRoutineViewModel(
            routineUseCase: routineUseCase,
            drinkWaterUseCase: drinkWaterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            calendar: calendar,
            nowProvider: { referenceDate }
        )
    }

    @MainActor
    private func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute))!
    }

    @MainActor
    @Test("루틴이 없으면 empty 상태 요약을 노출한다")
    func emptyStateSummary() async {
        let useCase = SpyRoutineUseCase()
        let viewModel = makeViewModel(routineUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.hasConfiguredRoutine == false)
        #expect(viewModel.activeRoutineCount == 0)
        #expect(viewModel.summaryBadgeText == L10n.tr("profileRoutineStatusEmptyBadge"))
        #expect(viewModel.summaryHeadline == L10n.tr("profileRoutineEmptyHeadline"))
        #expect(viewModel.summaryDescription == L10n.tr("profileRoutineEmptyDescription"))
        #expect(viewModel.notificationStatus == .notDetermined)
    }

    @MainActor
    @Test("루틴이 있으면 요약과 상세 상태를 함께 계산한다")
    func configuredStateSummary() async {
        let routine = HydrationRoutine(
            title: "출근 전 알림",
            hour: 9,
            minute: 0,
            weekdays: [.monday, .tuesday, .wednesday, .thursday, .friday],
            isEnabled: true
        )
        let useCase = SpyRoutineUseCase()
        useCase.routines = [routine]
        useCase.authorizationStatus = .authorized
        let viewModel = makeViewModel(routineUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.hasConfiguredRoutine)
        #expect(viewModel.activeRoutineCount == 1)
        #expect(viewModel.summaryBadgeText == L10n.tr("profileRoutineStatusActiveCountFormat", 1))
        #expect(viewModel.summaryHeadline == L10n.tr("profileRoutineConfiguredHeadline"))
        #expect(viewModel.summaryDescription == "\(routine.timeText) · \(routine.weekdayText)")
        #expect(viewModel.notificationStatus == .authorized)
        #expect(viewModel.displayedRoutines == [routine])
    }

    @MainActor
    @Test("saveDraft는 유효한 루틴을 저장하고 시트를 닫는다")
    func saveDraft() async {
        let useCase = SpyRoutineUseCase()
        useCase.authorizationStatus = .authorized
        let viewModel = makeViewModel(routineUseCase: useCase)

        viewModel.presentCreateRoutine()
        viewModel.editorDraft.title = "오후 루틴"
        viewModel.editorDraft.selectedWeekdays = [.monday, .wednesday]

        await viewModel.saveDraft()

        #expect(useCase.savedRoutine?.title == "오후 루틴")
        #expect(viewModel.isEditorPresented == false)
        #expect(viewModel.displayedRoutines.count == 1)
    }

    @MainActor
    @Test("saveDraft는 권한이 미정이면 권한 요청 안내를 먼저 노출한다")
    func saveDraftShowsAuthorizationPromptWhenStatusIsNotDetermined() async {
        let useCase = SpyRoutineUseCase()
        useCase.authorizationStatus = .notDetermined
        let viewModel = makeViewModel(routineUseCase: useCase)

        viewModel.presentCreateRoutine()
        viewModel.editorDraft.title = "오후 루틴"
        viewModel.editorDraft.selectedWeekdays = [.monday, .wednesday]

        await viewModel.saveDraft()

        #expect(useCase.savedRoutine == nil)
        #expect(viewModel.permissionPrompt == .requestAuthorization)
        #expect(viewModel.isEditorPresented == true)
    }

    @MainActor
    @Test("권한 요청이 허용되면 활성 루틴을 저장하고 에디터를 닫는다")
    func requestDraftAuthorizationAndSave() async {
        let useCase = SpyRoutineUseCase()
        useCase.authorizationStatus = .notDetermined
        useCase.requestAuthorizationResult = .success(.authorized)
        let viewModel = makeViewModel(routineUseCase: useCase)

        viewModel.presentCreateRoutine()
        viewModel.editorDraft.title = "오후 루틴"
        viewModel.editorDraft.selectedWeekdays = [.monday, .wednesday]
        await viewModel.saveDraft()
        await viewModel.requestDraftNotificationAuthorization()

        #expect(useCase.requestAuthorizationCallCount == 1)
        #expect(useCase.savedRoutine?.isEnabled == true)
        #expect(viewModel.permissionPrompt == nil)
        #expect(viewModel.isEditorPresented == false)
    }

    @MainActor
    @Test("saveDraft는 권한이 거부된 상태면 설정 이동 안내를 노출한다")
    func saveDraftShowsOpenSettingsPromptWhenDenied() async {
        let useCase = SpyRoutineUseCase()
        useCase.authorizationStatus = .denied
        let viewModel = makeViewModel(routineUseCase: useCase)

        viewModel.presentCreateRoutine()
        viewModel.editorDraft.title = "오후 루틴"
        viewModel.editorDraft.selectedWeekdays = [.monday, .wednesday]

        await viewModel.saveDraft()

        #expect(useCase.savedRoutine == nil)
        #expect(viewModel.permissionPrompt == .openSettings)
        #expect(viewModel.isEditorPresented == true)
    }

    @MainActor
    @Test("알림 없이 저장을 선택하면 비활성 루틴으로 저장한다")
    func saveDraftWithoutNotifications() async {
        let useCase = SpyRoutineUseCase()
        useCase.authorizationStatus = .denied
        let viewModel = makeViewModel(routineUseCase: useCase)

        viewModel.presentCreateRoutine()
        viewModel.editorDraft.title = "오후 루틴"
        viewModel.editorDraft.selectedWeekdays = [.monday, .wednesday]
        await viewModel.saveDraft()
        await viewModel.saveDraftWithoutNotifications()

        #expect(useCase.savedRoutine?.isEnabled == false)
        #expect(viewModel.permissionPrompt == nil)
        #expect(viewModel.isEditorPresented == false)
    }

    @MainActor
    @Test("saveDraft는 요일이 없으면 검증 에러를 노출한다")
    func saveDraftValidation() async {
        let useCase = SpyRoutineUseCase()
        let viewModel = makeViewModel(routineUseCase: useCase)

        viewModel.presentCreateRoutine()
        viewModel.editorDraft.title = "오후 루틴"
        viewModel.editorDraft.selectedWeekdays = []

        await viewModel.saveDraft()

        #expect(viewModel.errorMessage == L10n.tr("profileRoutineValidationError"))
    }

    @MainActor
    @Test("오늘 활성 루틴과 현재 섭취량으로 권장 섭취 가이드를 계산한다")
    func guidanceSummary() async {
        let routineUseCase = SpyRoutineUseCase()
        routineUseCase.routines = [
            HydrationRoutine(
                title: "오전 루틴",
                hour: 9,
                minute: 0,
                weekdays: [.monday],
                isEnabled: true
            ),
            HydrationRoutine(
                title: "오후 루틴",
                hour: 18,
                minute: 0,
                weekdays: [.monday],
                isEnabled: true
            )
        ]
        let drinkWaterUseCase = SpyDrinkWaterUseCase()
        drinkWaterUseCase.currentWaterValue = 3
        let userPreferencesUseCase = SpyUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimit = 2000
        let now = makeDate(year: 2026, month: 3, day: 16, hour: 10, minute: 30)
        let viewModel = makeViewModel(
            routineUseCase: routineUseCase,
            drinkWaterUseCase: drinkWaterUseCase,
            userPreferencesUseCase: userPreferencesUseCase,
            now: now
        )

        await viewModel.load()

        #expect(viewModel.guidanceSummary.badgeText == L10n.tr("profileRoutineGuidanceProgressFormat", 50))
        #expect(viewModel.guidanceSummary.headline == L10n.tr("profileRoutineGuidanceBehindHeadlineFormat", L10n.tr("commonMilliliterFormat", 250)))
        #expect(viewModel.guidanceSummary.description == L10n.tr("profileRoutineGuidanceDescriptionFormat", L10n.tr("commonMilliliterFormat", 1000), L10n.tr("commonMilliliterFormat", 750)))
        #expect(viewModel.guidanceSummary.recommendedValueText == L10n.tr("commonMilliliterFormat", 1000))
        #expect(viewModel.guidanceSummary.actualValueText == L10n.tr("commonMilliliterFormat", 750))
    }

    @MainActor
    @Test("오늘에 해당하는 활성 루틴이 없으면 권장 섭취 안내는 빈 상태를 노출한다")
    func guidanceSummaryWithoutTodayRoutine() async {
        let routineUseCase = SpyRoutineUseCase()
        routineUseCase.routines = [
            HydrationRoutine(
                title: "주말 루틴",
                hour: 10,
                minute: 0,
                weekdays: [.saturday, .sunday],
                isEnabled: true
            )
        ]
        let viewModel = makeViewModel(routineUseCase: routineUseCase)

        await viewModel.load()

        #expect(viewModel.guidanceSummary.badgeText == L10n.tr("profileRoutineGuidanceNoScheduleBadge"))
        #expect(viewModel.guidanceSummary.headline == L10n.tr("profileRoutineGuidanceNoScheduleHeadline"))
        #expect(viewModel.guidanceSummary.recommendedValueText == nil)
        #expect(viewModel.guidanceSummary.actualValueText == nil)
    }
}
