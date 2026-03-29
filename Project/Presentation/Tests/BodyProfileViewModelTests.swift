import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("BodyProfileViewModel Tests")
struct BodyProfileViewModelTests {
    @MainActor
    @Test("HealthKit 값이 있으면 직접 입력값보다 우선한다")
    func healthKitPreferredOverManualInput() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .sharingAuthorized
        healthKitUseCase.bodyProfileToReturn = BodyProfile(
            heightCM: BodyProfileValue(value: 172, source: .healthKit),
            weightKG: BodyProfileValue(value: 64, source: .healthKit)
        )

        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.manualBodyProfileValue = BodyProfile(
            heightCM: BodyProfileValue(value: 168, source: .manual),
            weightKG: BodyProfileValue(value: 60, source: .manual)
        )

        let viewModel = BodyProfileViewModel(
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )

        await viewModel.load()

        #expect(viewModel.availabilityState == .ready)
        #expect(viewModel.resolvedHeightText == L10n.tr("bodyProfileHeightValueFormat", 172))
        #expect(viewModel.resolvedWeightText == L10n.tr("bodyProfileWeightValueFormat", 64))
        #expect(viewModel.heightSourceText == L10n.tr("bodyProfileSourceHealthKit"))
        #expect(viewModel.weightSourceText == L10n.tr("bodyProfileSourceHealthKit"))
    }

    @MainActor
    @Test("HealthKit 값이 없으면 직접 입력값으로 fallback 한다")
    func manualFallbackWhenHealthKitMissing() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .sharingAuthorized
        healthKitUseCase.bodyProfileToReturn = .empty

        let userPreferencesUseCase = MockUserPreferencesUseCase()
        userPreferencesUseCase.manualBodyProfileValue = BodyProfile(
            heightCM: BodyProfileValue(value: 165, source: .manual),
            weightKG: BodyProfileValue(value: 55, source: .manual)
        )

        let viewModel = BodyProfileViewModel(
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: userPreferencesUseCase
        )

        await viewModel.load()

        #expect(viewModel.availabilityState == .ready)
        #expect(viewModel.heightSourceText == L10n.tr("bodyProfileSourceManual"))
        #expect(viewModel.weightSourceText == L10n.tr("bodyProfileSourceManual"))
        #expect(viewModel.summaryText == "\(L10n.tr("bodyProfileHeightValueFormat", 165)) · \(L10n.tr("bodyProfileWeightValueFormat", 55))")
    }

    @MainActor
    @Test("권한이 없고 값도 비어 있으면 permission 상태를 노출한다")
    func permissionStateWhenNoProfileExists() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .sharingDenied

        let viewModel = BodyProfileViewModel(
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: MockUserPreferencesUseCase()
        )

        await viewModel.load()

        #expect(viewModel.availabilityState == .permissionDenied)
        #expect(viewModel.summaryText == L10n.tr("bodyProfileSummaryNeedsInput"))
    }

    @MainActor
    @Test("권한은 있지만 건강 앱과 직접 입력 값이 모두 없으면 noData 상태를 노출한다")
    func noDataStateWhenAuthorizedButEmpty() async {
        let healthKitUseCase = MockHealthKitUseCase()
        healthKitUseCase.authorizationStatusValue = .sharingAuthorized
        healthKitUseCase.bodyProfileToReturn = .empty

        let viewModel = BodyProfileViewModel(
            healthKitUseCase: healthKitUseCase,
            userPreferencesUseCase: MockUserPreferencesUseCase()
        )

        await viewModel.load()

        #expect(viewModel.availabilityState == .noData)
        #expect(viewModel.helperText == L10n.tr("bodyProfileNoDataDescription"))
    }

    @MainActor
    @Test("직접 입력 저장 시 UseCase와 상태를 함께 갱신한다")
    func saveManualBodyProfile() {
        let userPreferencesUseCase = MockUserPreferencesUseCase()
        let viewModel = BodyProfileViewModel(
            healthKitUseCase: MockHealthKitUseCase(),
            userPreferencesUseCase: userPreferencesUseCase
        )

        viewModel.heightInput = "171"
        viewModel.weightInput = "59"
        viewModel.saveManualBodyProfile()

        #expect(userPreferencesUseCase.setManualBodyProfileCallCount == 1)
        #expect(userPreferencesUseCase.capturedManualBodyProfile?.heightCM?.value == 171)
        #expect(userPreferencesUseCase.capturedManualBodyProfile?.weightKG?.value == 59)
        #expect(viewModel.heightSourceText == L10n.tr("bodyProfileSourceManual"))
        #expect(viewModel.weightSourceText == L10n.tr("bodyProfileSourceManual"))
    }
}
