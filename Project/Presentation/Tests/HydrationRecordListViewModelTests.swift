import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("HydrationRecordListViewModel Tests")
struct HydrationRecordListViewModelTests {
    @MainActor
    @Test("fetchHydrationRecord는 날짜별 합계를 계산해 정렬된 기록을 만든다")
    func fetchHydrationRecord() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let viewModel = HydrationRecordListViewModel(
            useCase: mockUseCase,
            userPreferencesUseCase: MockUserPreferencesUseCase()
        )
        let calendar = Calendar.current
        let monthStart = calendar.date(
            from: calendar.dateComponents([.year, .month], from: .now)
        )!
        let secondDay = calendar.date(byAdding: .day, value: 1, to: monthStart)!

        mockUseCase.setHydrationEvents(
            [
                HydrationEvent(id: UUID(), consumedAt: monthStart, volumeML: 250),
                HydrationEvent(id: UUID(), consumedAt: monthStart.addingTimeInterval(60), volumeML: 500)
            ],
            on: monthStart
        )
        mockUseCase.setHydrationEvents(
            [HydrationEvent(id: UUID(), consumedAt: secondDay, volumeML: 300)],
            on: secondDay
        )

        await viewModel.fetchHydrationRecord()

        #expect(viewModel.records.count == 2)
        #expect(viewModel.records[0].mililiter == 750)
        #expect(viewModel.records[1].mililiter == 300)
        #expect(calendar.isDate(viewModel.records[0].date, inSameDayAs: monthStart))
        #expect(calendar.isDate(viewModel.records[1].date, inSameDayAs: secondDay))
    }

    @MainActor
    @Test("fetchHydrationRecord는 기간 요약을 계산한다")
    func fetchHydrationRecordSummary() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.dailyWaterLimitValue = 500
        let viewModel = HydrationRecordListViewModel(
            useCase: mockUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )
        let calendar = Calendar.current
        let monthStart = calendar.date(
            from: calendar.dateComponents([.year, .month], from: .now)
        )!
        let secondDay = calendar.date(byAdding: .day, value: 1, to: monthStart)!
        let daysInMonth = calendar.range(of: .day, in: .month, for: monthStart)!.count

        mockUseCase.setHydrationEvents(
            [
                HydrationEvent(id: UUID(), consumedAt: monthStart, volumeML: 250),
                HydrationEvent(id: UUID(), consumedAt: monthStart.addingTimeInterval(60), volumeML: 250)
            ],
            on: monthStart
        )
        mockUseCase.setHydrationEvents(
            [HydrationEvent(id: UUID(), consumedAt: secondDay, volumeML: 300)],
            on: secondDay
        )

        await viewModel.fetchHydrationRecord()

        #expect(viewModel.periodSummary.totalML == 800)
        #expect(viewModel.periodSummary.averageML == Int((800.0 / Double(daysInMonth)).rounded()))
        #expect(viewModel.periodSummary.eventCount == 3)
        #expect(viewModel.periodSummary.recordedDays == 2)
        #expect(viewModel.periodSummary.achievedDays == 1)
        #expect(viewModel.periodSummary.glassCount == HydrationServing.glassCount(for: 800))
    }

    @MainActor
    @Test("updateSelectedPeriod는 선택 기간에 맞게 기록을 필터링한다")
    func updateSelectedPeriodFiltersRecords() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let calendar = Calendar.current
        let fixedNow = calendar.date(from: DateComponents(year: 2026, month: 4, day: 15))!
        let monday = calendar.date(from: DateComponents(year: 2026, month: 4, day: 13))!
        let monthStart = calendar.date(from: DateComponents(year: 2026, month: 4, day: 1))!
        let viewModel = HydrationRecordListViewModel(
            useCase: mockUseCase,
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            calendar: calendar,
            nowProvider: { fixedNow }
        )

        mockUseCase.setHydrationEvents(
            [HydrationEvent(id: UUID(), consumedAt: monthStart, volumeML: 500)],
            on: monthStart
        )
        mockUseCase.setHydrationEvents(
            [HydrationEvent(id: UUID(), consumedAt: monday, volumeML: 250)],
            on: monday
        )
        mockUseCase.setHydrationEvents(
            [HydrationEvent(id: UUID(), consumedAt: fixedNow, volumeML: 300)],
            on: fixedNow
        )

        await viewModel.updateSelectedPeriod(.today)

        #expect(viewModel.records.count == 1)
        #expect(viewModel.periodSummary.totalML == 300)

        await viewModel.updateSelectedPeriod(.week)

        #expect(viewModel.records.count == 2)
        #expect(viewModel.periodSummary.totalML == 550)

        await viewModel.updateDisplayedMonth(year: 2026, month: 4)

        #expect(viewModel.selectedPeriod == .month)
        #expect(viewModel.records.count == 3)
        #expect(viewModel.periodSummary.totalML == 1_050)
    }

    @MainActor
    @Test("updateDisplayedMonth는 잘못된 월 입력 시 에러를 설정한다")
    func updateDisplayedMonthWithInvalidMonth() async {
        let viewModel = HydrationRecordListViewModel(
            useCase: MockDrinkWaterUseCase(),
            userPreferencesUseCase: MockUserPreferencesUseCase()
        )

        await viewModel.updateDisplayedMonth(year: 2026, month: 13)

        #expect(viewModel.errorMessage == L10n.tr("historyInvalidDateSelectionError"))
    }

    @MainActor
    @Test("showMonthPicker와 dismissMonthPicker는 시트 상태를 제어한다")
    func monthPickerRoutingActions() {
        let viewModel = HydrationRecordListViewModel(
            useCase: MockDrinkWaterUseCase(),
            userPreferencesUseCase: MockUserPreferencesUseCase()
        )

        viewModel.showMonthPicker()

        #expect(viewModel.isMonthPickerPresented == true)

        viewModel.dismissMonthPicker()

        #expect(viewModel.isMonthPickerPresented == false)
    }

    @MainActor
    @Test("updateDisplayedMonth는 유효한 입력 시 월을 전환하고 기록을 다시 조회한다")
    func updateDisplayedMonth() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let viewModel = HydrationRecordListViewModel(
            useCase: mockUseCase,
            userPreferencesUseCase: MockUserPreferencesUseCase()
        )
        let calendar = Calendar.current
        let targetDate = calendar.date(from: DateComponents(year: 2025, month: 8, day: 1))!

        mockUseCase.setHydrationEvents(
            [HydrationEvent(id: UUID(), consumedAt: targetDate, volumeML: 250)],
            on: targetDate
        )

        await viewModel.updateDisplayedMonth(year: 2025, month: 8)

        #expect(calendar.isDate(viewModel.date, equalTo: targetDate, toGranularity: .month))
        #expect(viewModel.records.count == 1)
        #expect(viewModel.records.first?.mililiter == 250)
    }
}
