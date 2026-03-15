import DomainLayerInterface
import Foundation
import Localization
import SwiftUI
import Testing

@testable import PresentationLayer

@Suite("HydrationRecordListViewModel Tests")
struct HydrationRecordListViewModelTests {
    private final class SpyRecordRouting: RecordRouting {
        var path = NavigationPath()
        var presentedRoute: RecordRoute?
        var hasPath: Bool { !path.isEmpty }
        private(set) var pushedRoutes: [RecordRoute] = []
        private(set) var presentCallCount = 0
        private(set) var dismissCallCount = 0

        func push(_ route: RecordRoute) {
            pushedRoutes.append(route)
            path.append(route)
        }

        func pop() {
            if !path.isEmpty {
                path.removeLast()
            }
        }

        func reset() {
            path = NavigationPath()
        }

        func present(_ route: RecordRoute) {
            presentCallCount += 1
            presentedRoute = route
        }

        func dismissPresentedRoute() {
            dismissCallCount += 1
            presentedRoute = nil
        }

        func handleDeepLink(_ url: URL) {}
    }

    @MainActor
    @Test("fetchHydrationRecord는 날짜별 합계를 계산해 정렬된 기록을 만든다")
    func fetchHydrationRecord() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let viewModel = HydrationRecordListViewModel(
            useCase: mockUseCase,
            recordRouting: SpyRecordRouting()
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
    @Test("updateDisplayedMonth는 잘못된 월 입력 시 에러를 설정한다")
    func updateDisplayedMonthWithInvalidMonth() async {
        let viewModel = HydrationRecordListViewModel(
            useCase: MockDrinkWaterUseCase(),
            recordRouting: SpyRecordRouting()
        )

        await viewModel.updateDisplayedMonth(year: 2026, month: 13)

        #expect(viewModel.errorMessage == L10n.tr("historyInvalidDateSelectionError"))
    }

    @MainActor
    @Test("showMonthPicker와 dismissPresentedRoute는 record route 시트를 제어한다")
    func monthPickerRoutingActions() {
        let routing = SpyRecordRouting()
        let viewModel = HydrationRecordListViewModel(
            useCase: MockDrinkWaterUseCase(),
            recordRouting: routing
        )

        viewModel.showMonthPicker()

        #expect(viewModel.presentedRoute == .monthPicker)
        #expect(routing.presentedRoute == .monthPicker)
        #expect(routing.presentCallCount == 1)

        viewModel.dismissPresentedRoute()

        #expect(viewModel.presentedRoute == nil)
        #expect(routing.presentedRoute == nil)
        #expect(routing.dismissCallCount == 1)
    }

    @MainActor
    @Test("updateDisplayedMonth는 유효한 입력 시 월을 전환하고 기록을 다시 조회한다")
    func updateDisplayedMonth() async {
        let mockUseCase = MockDrinkWaterUseCase()
        let viewModel = HydrationRecordListViewModel(
            useCase: mockUseCase,
            recordRouting: SpyRecordRouting()
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
