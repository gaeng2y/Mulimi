import DomainLayer
import DomainLayerInterface
import Testing

@Suite("BodyProfileUseCase Tests")
struct BodyProfileUseCaseTests {
    @Test("HealthKit 값이 있으면 그대로 resolved profile로 노출한다")
    func resolvesHealthKitValues() async {
        let healthKitRepository = MockHealthKitRepository()
        healthKitRepository.setAuthorizationStatus(.sharingAuthorized)
        healthKitRepository.setBodyProfile(
            BodyProfile(
                heightCM: BodyProfileValue(value: 172, source: .healthKit),
                weightKG: BodyProfileValue(value: 64, source: .healthKit)
            )
        )

        let useCase = BodyProfileUseCaseImpl(
            healthKitRepository: healthKitRepository
        )

        let snapshot = await useCase.loadBodyProfile()

        #expect(snapshot.availability == .ready)
        #expect(snapshot.healthKitBodyProfile.heightCM?.value == 172)
        #expect(snapshot.healthKitBodyProfile.weightKG?.value == 64)
        #expect(snapshot.resolvedBodyProfile.heightCM?.source == .healthKit)
        #expect(snapshot.resolvedBodyProfile.weightKG?.source == .healthKit)
        #expect(snapshot.manualBodyProfile == .empty)
    }

    @Test("권한이 없고 값도 없으면 permission 상태를 노출한다")
    func returnsPermissionStateWhenDenied() async {
        let healthKitRepository = MockHealthKitRepository()
        healthKitRepository.setAuthorizationStatus(.sharingDenied)

        let useCase = BodyProfileUseCaseImpl(
            healthKitRepository: healthKitRepository
        )

        let snapshot = await useCase.loadBodyProfile()

        #expect(snapshot.availability == .permissionDenied)
        #expect(snapshot.resolvedBodyProfile == .empty)
    }

    @Test("권한은 있지만 건강 앱 값이 없으면 noData를 노출한다")
    func returnsNoDataWhenHealthKitProfileMissing() async {
        let healthKitRepository = MockHealthKitRepository()
        healthKitRepository.setAuthorizationStatus(.sharingAuthorized)
        healthKitRepository.setBodyProfile(.empty)

        let useCase = BodyProfileUseCaseImpl(
            healthKitRepository: healthKitRepository
        )

        let snapshot = await useCase.loadBodyProfile()

        #expect(snapshot.healthKitBodyProfile == .empty)
        #expect(snapshot.resolvedBodyProfile == .empty)
        #expect(snapshot.availability == .noData)
    }
}
