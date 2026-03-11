import DomainLayerInterface
import Foundation
import Testing

@testable import PresentationLayer

@Suite("HydrationRecordListViewModel Tests")
struct HydrationRecordListViewModelTests {
    @MainActor
    @Test("fetchHydrationRecord는 날짜별 합계를 계산해 정렬된 기록을 만든다")
    func fetchHydrationRecord() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let viewModel = HydrationRecordListViewModel(useCase: mockUseCase)
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
    @Test("updateDisplayedMonth는 잘못된 월 입력 시 에러를 설정한다")
    func updateDisplayedMonthWithInvalidMonth() async {
        let viewModel = HydrationRecordListViewModel(useCase: MockDrinkWaterUseCase())

        await viewModel.updateDisplayedMonth(year: 2026, month: 13)

        #expect(viewModel.errorMessage == "Invalid date selection")
    }

    @MainActor
    @Test("updateDisplayedMonth는 유효한 입력 시 월을 전환하고 기록을 다시 조회한다")
    func updateDisplayedMonth() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let viewModel = HydrationRecordListViewModel(useCase: mockUseCase)
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
