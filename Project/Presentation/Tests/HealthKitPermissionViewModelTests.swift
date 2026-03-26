import DomainLayerInterface
import Foundation
import Testing

@testable import PresentationLayer

@Suite("HealthKitPermissionViewModel Tests")
struct HealthKitPermissionViewModelTests {
    private enum MockError: LocalizedError {
        case failed

        var errorDescription: String? {
            switch self {
            case .failed:
                return "failed"
            }
        }
    }

    @MainActor
    @Test("초기 상태는 UseCase 권한 상태를 반영한다")
    func initializeState() {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .sharingDenied

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        #expect(viewModel.authorizationStatus == .sharingDenied)
        #expect(viewModel.isAuthorized == false)
    }

    @MainActor
    @Test("prepareIfNeeded는 최초 notDetermined 상태에서 권한을 요청한다")
    func prepareIfNeededRequestsAuthorization() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .notDetermined

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        await viewModel.prepareIfNeeded()

        #expect(healthKitUseCase.requestAuthorizationCallCount == 1)
        #expect(viewModel.authorizationStatus == .sharingAuthorized)
        #expect(viewModel.isAuthorized == true)
    }

    @MainActor
    @Test("requestAuthorization 실패 시 에러 메시지를 유지한다")
    func requestAuthorizationFailure() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .notDetermined
        healthKitUseCase.requestAuthorizationError = MockError.failed

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        await viewModel.requestAuthorization()

        #expect(healthKitUseCase.requestAuthorizationCallCount == 1)
        #expect(viewModel.isAuthorized == false)
        #expect(viewModel.errorMessage == MockError.failed.localizedDescription)
    }

    @MainActor
    @Test("markSignedOut는 자동 요청 상태를 초기화한다")
    func markSignedOutResetsLaunchState() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .notDetermined

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        await viewModel.prepareIfNeeded()
        healthKitUseCase.authorizationStatusValue = .notDetermined
        viewModel.markSignedOut()
        await viewModel.prepareIfNeeded()

        #expect(healthKitUseCase.requestAuthorizationCallCount == 2)
    }
}
