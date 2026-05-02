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
        #expect(viewModel.daySummaries[0].events.count == 2)
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

    @MainActor
    @Test("앱이 생성한 개별 기록 삭제는 목록과 위젯을 갱신한다")
    func deleteOwnedHydrationEvent() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let widgetReloader = RecordSpyWidgetTimelineReloader()
        let viewModel = HydrationRecordListViewModel(
            useCase: mockUseCase,
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            widgetTimelineReloader: widgetReloader
        )
        let calendar = Calendar.current
        let targetDate = calendar.date(from: calendar.dateComponents([.year, .month, .day], from: .now))!
        let eventID = UUID()
        mockUseCase.setHydrationEvents(
            [
                HydrationEvent(id: eventID, consumedAt: targetDate, volumeML: 250),
                HydrationEvent(id: UUID(), consumedAt: targetDate.addingTimeInterval(60), volumeML: 500)
            ],
            on: targetDate
        )

        await viewModel.fetchHydrationRecord()
        let didDelete = await viewModel.deleteEvent(viewModel.daySummaries[0].events[0])

        #expect(didDelete)
        #expect(mockUseCase.deleteHydrationEventCallCount == 1)
        #expect(mockUseCase.deletedHydrationEventIDs == [eventID])
        #expect(viewModel.daySummaries[0].totalML == 500)
        #expect(viewModel.periodSummary.eventCount == 1)
        #expect(widgetReloader.reloadCallCount == 1)
    }

    @MainActor
    @Test("외부 개별 기록 삭제는 차단하고 오류를 노출한다")
    func deleteExternalHydrationEvent() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let widgetReloader = RecordSpyWidgetTimelineReloader()
        let viewModel = HydrationRecordListViewModel(
            useCase: mockUseCase,
            userPreferencesUseCase: MockUserPreferencesUseCase(),
            widgetTimelineReloader: widgetReloader
        )
        let targetDate = Date.now
        let externalEvent = HydrationEvent(
            id: UUID(),
            consumedAt: targetDate,
            volumeML: 250,
            isOwnedByCurrentApp: false
        )
        mockUseCase.setHydrationEvents([externalEvent], on: targetDate)

        await viewModel.fetchHydrationRecord()
        let didDelete = await viewModel.deleteEvent(externalEvent)

        #expect(didDelete == false)
        #expect(mockUseCase.deleteHydrationEventCallCount == 0)
        #expect(viewModel.errorMessage == L10n.tr("historyDeleteExternalRecordDescription"))
        #expect(widgetReloader.reloadCallCount == 0)
    }
}

private final class RecordSpyWidgetTimelineReloader: WidgetTimelineReloading, @unchecked Sendable {
    private(set) var reloadCallCount = 0

    func reloadAllTimelines() {
        reloadCallCount += 1
    }
}
