import Foundation
import Testing

@testable import MulimiNavigation

@Suite("AppCoordinator Tests")
struct AppCoordinatorTests {
    @Test("스타터 플랜 시트는 루트 스택을 유지하고 닫은 뒤 루틴 화면으로 이동한다")
    func starterPlanRoute() {
        let coordinator = AppCoordinator()
        coordinator.push(.hydrationLogging)
        coordinator.presentSheet(.hydrationStarterPlan)
        #expect(AppRoute.hydrationStarterPlan.id == "hydration_starter_plan")
        #expect(AppRoute.hydrationStarterPlan.presentationStyle == .sheet)
        #expect(coordinator.presentedRoute == .hydrationStarterPlan)
        #expect(coordinator.path.count == 1)
        coordinator.dismissSheet()
        #expect(coordinator.presentedRoute == nil)
        #expect(coordinator.path.count == 1)
        coordinator.push(.profileRoutineAction(.create))
        #expect(AppRoute.profileRoutineAction(.create).presentationStyle == .push)
        #expect(coordinator.path.count == 2)
        coordinator.resetPath()
        #expect(coordinator.path.isEmpty)
    }

    @Test("수분 기록 딥링크를 기록 화면으로 연결한다")
    func hydrationLoggingDeepLink() throws {
        let coordinator = AppCoordinator()
        let url = try #require(URL(string: "mulimi://hydration/record"))

        coordinator.handleDeepLink(url)

        #expect(coordinator.path.count == 1)
    }

    @Test("지원하지 않는 딥링크는 무시한다")
    func unsupportedDeepLink() throws {
        let coordinator = AppCoordinator()
        let url = try #require(URL(string: "mulimi://hydration/unknown"))

        coordinator.handleDeepLink(url)

        #expect(coordinator.path.isEmpty)
    }
}
