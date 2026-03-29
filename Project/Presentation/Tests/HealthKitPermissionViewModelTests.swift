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
    @Test("prepareIfNeeded는 최초 notDetermined 상태에서도 자동 권한 요청을 하지 않는다")
    func prepareIfNeededDoesNotRequestAuthorizationAutomatically() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .notDetermined

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        await viewModel.prepareIfNeeded()

        #expect(healthKitUseCase.requestAuthorizationCallCount == 0)
        #expect(viewModel.authorizationStatus == .notDetermined)
        #expect(viewModel.isAuthorized == false)
    }

    @Test("requestAuthorization 성공 시 권한 상태를 갱신한다")
    func requestAuthorizationSuccess() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .notDetermined

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        await viewModel.requestAuthorization()

        #expect(healthKitUseCase.requestAuthorizationCallCount == 1)
        #expect(viewModel.authorizationStatus == .sharingAuthorized)
        #expect(viewModel.isAuthorized == true)
        #expect(viewModel.errorMessage == nil)
    }

    @MainActor
    @Test("requestAuthorization 실패 시 사용자용 에러 메시지를 유지한다")
    func requestAuthorizationFailure() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .notDetermined
        healthKitUseCase.requestAuthorizationError = MockError.failed

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        await viewModel.requestAuthorization()

        #expect(healthKitUseCase.requestAuthorizationCallCount == 1)
        #expect(viewModel.isAuthorized == false)
        #expect(viewModel.errorMessage == "건강 권한을 확인하는 중 문제가 발생했어요. 잠시 후 다시 시도해 주세요.")
    }

    @MainActor
    @Test("requestAuthorization 이후 거부 상태면 설정 안내 메시지를 노출한다")
    func requestAuthorizationShowsDeniedMessage() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .notDetermined
        healthKitUseCase.authorizationStatusAfterRequest = .sharingDenied

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        await viewModel.requestAuthorization()

        #expect(viewModel.isAuthorized == false)
        #expect(viewModel.errorMessage == "한 번 거부한 건강 권한은 앱에서 다시 요청할 수 없어요. 설정에서 다시 허용해 주세요.")
    }

    @MainActor
    @Test("markSignedOut는 에러 메시지를 초기화한다")
    func markSignedOutClearsErrorMessage() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .notDetermined
        healthKitUseCase.authorizationStatusAfterRequest = .sharingDenied

        let viewModel = HealthKitPermissionViewModel(healthKitUseCase: healthKitUseCase)

        await viewModel.requestAuthorization()
        viewModel.markSignedOut()

        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.authorizationStatus == .sharingDenied)
    }
}
