import DomainLayer
import DomainLayerInterface
import Foundation
import Testing

@Suite("HydrationGoalRecommendationUseCase Tests")
struct HydrationGoalRecommendationUseCaseTests {
    @Test("신체 정보가 비어 있으면 bodyProfileRequired를 반환한다")
    func returnsBodyProfileRequiredWhenProfileMissing() async {
        let bodyProfileUseCase = MockBodyProfileUseCaseForDomain(
            snapshot: BodyProfileSnapshot(
                authorizationStatus: .sharingAuthorized,
                healthKitBodyProfile: .empty,
                manualBodyProfile: .empty,
                resolvedBodyProfile: .empty,
                availability: .noData,
                didFailHealthKitSync: false
            )
        )

        let useCase = HydrationGoalRecommendationUseCaseImpl(
            bodyProfileUseCase: bodyProfileUseCase,
            drinkWaterRepository: MockDrinkWaterRepository(),
            userPreferencesRepository: MockUserPreferencesRepository(),
            recommendationRepository: MockHydrationGoalRecommendationRepository()
        )

        let availability = await useCase.availability(referenceDate: .now)

        #expect(availability == .bodyProfileRequired(.noData))
    }

    @Test("모델이 준비되지 않으면 unavailable 상태를 반환한다")
    func returnsModelUnavailableWhenModelUnavailable() async {
        let recommendationRepository = MockHydrationGoalRecommendationRepository()
        recommendationRepository.unavailableReason = .modelNotReady

        let useCase = HydrationGoalRecommendationUseCaseImpl(
            bodyProfileUseCase: MockBodyProfileUseCaseForDomain.ready,
            drinkWaterRepository: MockDrinkWaterRepository(),
            userPreferencesRepository: MockUserPreferencesRepository(),
            recommendationRepository: recommendationRepository
        )

        let availability = await useCase.availability(referenceDate: .now)

        #expect(availability == .modelUnavailable(.modelNotReady))
    }

    @Test("추천 생성 시 최근 7일 기록과 현재 목표를 입력으로 조합한다")
    func buildsRecommendationInputFromRecentHistory() async throws {
        let calendar = Calendar(identifier: .gregorian)
        let referenceDate = calendar.date(from: DateComponents(year: 2026, month: 3, day: 30))!

        let drinkWaterRepository = MockDrinkWaterRepository()
        drinkWaterRepository.setHydrationEvents([
            HydrationEvent(id: UUID(), consumedAt: calendar.date(byAdding: .day, value: -6, to: referenceDate)!, volumeML: 500),
            HydrationEvent(id: UUID(), consumedAt: calendar.date(byAdding: .day, value: -5, to: referenceDate)!, volumeML: 1500),
            HydrationEvent(id: UUID(), consumedAt: calendar.date(byAdding: .day, value: -1, to: referenceDate)!, volumeML: 2500),
            HydrationEvent(id: UUID(), consumedAt: referenceDate, volumeML: 1000)
        ])

        let userPreferencesRepository = MockUserPreferencesRepository()
        userPreferencesRepository.setDailyWaterLimit(2_000)

        let recommendationRepository = MockHydrationGoalRecommendationRepository()

        let useCase = HydrationGoalRecommendationUseCaseImpl(
            bodyProfileUseCase: MockBodyProfileUseCaseForDomain.ready,
            drinkWaterRepository: drinkWaterRepository,
            userPreferencesRepository: userPreferencesRepository,
            recommendationRepository: recommendationRepository,
            calendar: calendar
        )

        _ = try await useCase.generateRecommendation(referenceDate: referenceDate)

        #expect(recommendationRepository.capturedInput?.heightCM == 172)
        #expect(recommendationRepository.capturedInput?.weightKG == 64)
        #expect(recommendationRepository.capturedInput?.currentGoalML == 2_000)
        #expect(recommendationRepository.capturedInput?.recentAverageIntakeML == 785)
        #expect(recommendationRepository.capturedInput?.recentRecordedDays == 4)
        #expect(recommendationRepository.capturedInput?.recentGoalAchievementDays == 1)
        #expect(recommendationRepository.capturedInput?.analysisDays == 7)
    }
}

private struct MockBodyProfileUseCaseForDomain: BodyProfileUseCase {
    let snapshot: BodyProfileSnapshot

    static let ready = MockBodyProfileUseCaseForDomain(
        snapshot: BodyProfileSnapshot(
            authorizationStatus: .sharingAuthorized,
            healthKitBodyProfile: BodyProfile(
                heightCM: BodyProfileValue(value: 172, source: .healthKit),
                weightKG: BodyProfileValue(value: 64, source: .healthKit)
            ),
            manualBodyProfile: .empty,
            resolvedBodyProfile: BodyProfile(
                heightCM: BodyProfileValue(value: 172, source: .healthKit),
                weightKG: BodyProfileValue(value: 64, source: .healthKit)
            ),
            availability: .ready,
            didFailHealthKitSync: false
        )
    )

    func loadBodyProfile() async -> BodyProfileSnapshot {
        snapshot
    }

    func requestHealthKitSync() async throws -> BodyProfileSnapshot {
        snapshot
    }
}
