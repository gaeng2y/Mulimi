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

        func fetchRoutines() -> [HydrationRoutine] {
            routines
        }

        func notificationAuthorizationStatus() async -> RoutineNotificationAuthorizationStatus {
            authorizationStatus
        }

        func requestNotificationAuthorization() async throws -> RoutineNotificationAuthorizationStatus {
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

    @MainActor
    @Test("루틴이 없으면 empty 상태 요약을 노출한다")
    func emptyStateSummary() async {
        let useCase = SpyRoutineUseCase()
        let viewModel = ProfileRoutineViewModel(routineUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.hasConfiguredRoutine == false)
        #expect(viewModel.summaryBadgeText == L10n.tr("profileRoutineStatusEmptyBadge"))
        #expect(viewModel.summaryHeadline == L10n.tr("profileRoutineEmptyHeadline"))
        #expect(viewModel.summaryDescription == L10n.tr("profileRoutineEmptyDescription"))
        #expect(viewModel.detailRows[0].value == L10n.tr("profileRoutineNotificationPendingValue"))
        #expect(viewModel.detailRows[1].value == L10n.tr("profileRoutineActiveCountNoneValue"))
        #expect(viewModel.detailRows[2].value == L10n.tr("profileRoutineDetailEmptyValue"))
        #expect(viewModel.detailRows[3].value == L10n.tr("profileRoutineDetailEmptyValue"))
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
        let viewModel = ProfileRoutineViewModel(routineUseCase: useCase)

        await viewModel.load()

        #expect(viewModel.hasConfiguredRoutine)
        #expect(viewModel.summaryBadgeText == L10n.tr("profileRoutineStatusActiveCountFormat", 1))
        #expect(viewModel.summaryHeadline == L10n.tr("profileRoutineConfiguredHeadline"))
        #expect(viewModel.summaryDescription == "\(routine.timeText) · \(routine.weekdayText)")
        #expect(viewModel.detailRows[0].value == L10n.tr("profileRoutineNotificationAuthorizedValue"))
        #expect(viewModel.detailRows[1].value == L10n.tr("profileRoutineCountFormat", 1))
        #expect(viewModel.detailRows[2].value == routine.timeText)
        #expect(viewModel.detailRows[3].value == routine.weekdayText)
        #expect(viewModel.displayedRoutines == [routine])
    }

    @MainActor
    @Test("saveDraft는 유효한 루틴을 저장하고 시트를 닫는다")
    func saveDraft() async {
        let useCase = SpyRoutineUseCase()
        let viewModel = ProfileRoutineViewModel(routineUseCase: useCase)

        viewModel.presentCreateRoutine()
        viewModel.editorDraft.title = "오후 루틴"
        viewModel.editorDraft.selectedWeekdays = [.monday, .wednesday]

        await viewModel.saveDraft()

        #expect(useCase.savedRoutine?.title == "오후 루틴")
        #expect(viewModel.isEditorPresented == false)
        #expect(viewModel.displayedRoutines.count == 1)
    }

    @MainActor
    @Test("saveDraft는 요일이 없으면 검증 에러를 노출한다")
    func saveDraftValidation() async {
        let useCase = SpyRoutineUseCase()
        let viewModel = ProfileRoutineViewModel(routineUseCase: useCase)

        viewModel.presentCreateRoutine()
        viewModel.editorDraft.title = "오후 루틴"
        viewModel.editorDraft.selectedWeekdays = []

        await viewModel.saveDraft()

        #expect(viewModel.errorMessage == L10n.tr("profileRoutineValidationError"))
    }
}
