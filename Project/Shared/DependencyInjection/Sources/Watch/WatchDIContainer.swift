import SwiftUI
import WatchDataLayer
import WatchDomainLayer
import WatchPresentationLayer

public struct WatchDIContainer {
    public init() {}

    @MainActor
    public func makeRootView() -> AnyView {
        let hydrationRepository = WatchHydrationRepositoryImpl()
        let dailyGoalRepository = WatchDailyGoalRepositoryImpl()
        let hydrationUseCase = WatchHydrationUseCaseImpl(
            hydrationRepository: hydrationRepository,
            dailyGoalRepository: dailyGoalRepository
        )
        let viewModel = WatchHydrationViewModel(useCase: hydrationUseCase)

        return AnyView(WatchRootView(viewModel: viewModel))
    }
}
