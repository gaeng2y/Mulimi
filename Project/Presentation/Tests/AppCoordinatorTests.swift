import Foundation
import Testing

@testable import PresentationLayer

@Suite("AppCoordinator Tests")
struct AppCoordinatorTests {
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
