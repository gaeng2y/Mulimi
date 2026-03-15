import Localization
import Testing

@testable import PresentationLayer

@Suite("ProfileRoutineViewModel Tests")
struct ProfileRoutineViewModelTests {
    @Test("루틴이 없으면 empty 상태 요약을 노출한다")
    func emptyStateSummary() {
        let viewModel = ProfileRoutineViewModel()

        #expect(viewModel.hasConfiguredRoutine == false)
        #expect(viewModel.summaryBadgeText == L10n.tr("profileRoutineStatusEmptyBadge"))
        #expect(viewModel.summaryHeadline == L10n.tr("profileRoutineEmptyHeadline"))
        #expect(viewModel.summaryDescription == L10n.tr("profileRoutineEmptyDescription"))
        #expect(viewModel.detailRows[0].value == L10n.tr("profileRoutineNotificationPendingValue"))
        #expect(viewModel.detailRows[1].value == L10n.tr("profileRoutineActiveCountNoneValue"))
        #expect(viewModel.detailRows[2].value == L10n.tr("profileRoutineDetailEmptyValue"))
        #expect(viewModel.detailRows[3].value == L10n.tr("profileRoutineDetailEmptyValue"))
    }

    @Test("루틴이 있으면 요약과 상세 상태를 함께 계산한다")
    func configuredStateSummary() {
        let routine = RoutineScheduleSummary(
            title: "출근 전 알림",
            timeDescription: "오전 9:00",
            repeatDescription: "월, 화, 수, 목, 금",
            isEnabled: true
        )
        let viewModel = ProfileRoutineViewModel(
            notificationStatus: .authorized,
            routines: [routine]
        )

        #expect(viewModel.hasConfiguredRoutine)
        #expect(viewModel.summaryBadgeText == L10n.tr("profileRoutineStatusActiveCountFormat", 1))
        #expect(viewModel.summaryHeadline == L10n.tr("profileRoutineConfiguredHeadline"))
        #expect(viewModel.summaryDescription == "오전 9:00 · 월, 화, 수, 목, 금")
        #expect(viewModel.detailRows[0].value == L10n.tr("profileRoutineNotificationAuthorizedValue"))
        #expect(viewModel.detailRows[1].value == L10n.tr("profileRoutineCountFormat", 1))
        #expect(viewModel.detailRows[2].value == "오전 9:00")
        #expect(viewModel.detailRows[3].value == "월, 화, 수, 목, 금")
        #expect(viewModel.displayedRoutines == [routine])
    }
}
