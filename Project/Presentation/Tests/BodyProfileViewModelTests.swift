import DomainLayerInterface
import Foundation
import Localization
import Testing

@testable import PresentationLayer

@Suite("BodyProfileViewModel Tests")
struct BodyProfileViewModelTests {
    @MainActor
    @Test("HealthKit 값이 있으면 건강 앱 값을 그대로 노출한다")
    func loadHealthKitProfile() async {
        let bodyProfileUseCase = MockBodyProfileUseCase()
        bodyProfileUseCase.snapshot = BodyProfileSnapshot(
            authorizationStatus: .sharingAuthorized,
            healthKitBodyProfile: BodyProfile(
                heightCM: BodyProfileValue(value: 172, source: .healthKit),
                weightKG: BodyProfileValue(value: 64, source: .healthKit)
            ),
            manualBodyProfile: BodyProfile(
                heightCM: BodyProfileValue(value: 168, source: .manual),
                weightKG: BodyProfileValue(value: 60, source: .manual)
            ),
            resolvedBodyProfile: BodyProfile(
                heightCM: BodyProfileValue(value: 172, source: .healthKit),
                weightKG: BodyProfileValue(value: 64, source: .healthKit)
            ),
            availability: .ready,
            didFailHealthKitSync: false
        )

        let viewModel = BodyProfileViewModel(
            bodyProfileUseCase: bodyProfileUseCase
        )

        await viewModel.load()

        #expect(viewModel.availabilityState == .ready)
        #expect(viewModel.resolvedHeightText == L10n.tr("bodyProfileHeightValueFormat", 172))
        #expect(viewModel.resolvedWeightText == L10n.tr("bodyProfileWeightValueFormat", 64))
        #expect(viewModel.heightSourceText == L10n.tr("bodyProfileSourceHealthKit"))
        #expect(viewModel.weightSourceText == L10n.tr("bodyProfileSourceHealthKit"))
    }

    @MainActor
    @Test("HealthKit 값이 없으면 noData 상태를 노출한다")
    func noDataStateWhenHealthKitMissing() async {
        let bodyProfileUseCase = MockBodyProfileUseCase()
        bodyProfileUseCase.snapshot = BodyProfileSnapshot(
            authorizationStatus: .sharingAuthorized,
            healthKitBodyProfile: .empty,
            manualBodyProfile: .empty,
            resolvedBodyProfile: .empty,
            availability: .noData,
            didFailHealthKitSync: false
        )

        let viewModel = BodyProfileViewModel(
            bodyProfileUseCase: bodyProfileUseCase
        )

        await viewModel.load()

        #expect(viewModel.availabilityState == .noData)
        #expect(viewModel.heightSourceText == nil)
        #expect(viewModel.weightSourceText == nil)
        #expect(viewModel.summaryText == L10n.tr("bodyProfileSummaryNeedsInput"))
    }

    @MainActor
    @Test("권한이 없고 값도 비어 있으면 permission 상태를 노출한다")
    func permissionStateWhenNoProfileExists() async {
        let bodyProfileUseCase = MockBodyProfileUseCase()
        bodyProfileUseCase.snapshot = BodyProfileSnapshot(
            authorizationStatus: .sharingDenied,
            healthKitBodyProfile: .empty,
            manualBodyProfile: .empty,
            resolvedBodyProfile: .empty,
            availability: .permissionDenied,
            didFailHealthKitSync: false
        )

        let viewModel = BodyProfileViewModel(
            bodyProfileUseCase: bodyProfileUseCase
        )

        await viewModel.load()

        #expect(viewModel.availabilityState == .permissionDenied)
        #expect(viewModel.summaryText == L10n.tr("bodyProfileSummaryNeedsInput"))
    }

    @MainActor
    @Test("권한은 있지만 건강 앱 값이 없으면 noData 상태를 노출한다")
    func noDataStateWhenAuthorizedButEmpty() async {
        let bodyProfileUseCase = MockBodyProfileUseCase()
        bodyProfileUseCase.snapshot = BodyProfileSnapshot(
            authorizationStatus: .sharingAuthorized,
            healthKitBodyProfile: .empty,
            manualBodyProfile: .empty,
            resolvedBodyProfile: .empty,
            availability: .noData,
            didFailHealthKitSync: false
        )

        let viewModel = BodyProfileViewModel(
            bodyProfileUseCase: bodyProfileUseCase
        )

        await viewModel.load()

        #expect(viewModel.availabilityState == .noData)
        #expect(viewModel.helperText == L10n.tr("bodyProfileNoDataDescription"))
    }
}
