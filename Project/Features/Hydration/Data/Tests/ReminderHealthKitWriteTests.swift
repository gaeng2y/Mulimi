import Foundation
import HydrationDomain
import Testing
@testable import HydrationData

struct ReminderHealthKitWriteTests {
    private final class HealthKitSource: HealthKitDataSource, @unchecked Sendable {
        var healthKitAuthorizationStatus: HealthKitAuthorizationStatus = .sharingAuthorized
        var readError: Error?
        var writeError: Error?
        var saved: [(Int, String?)] = []
        func requestAuthorization() async throws {}
        func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(date: Date, amount: Double)] { [] }
        func readWaterSamples(from startDate: Date, to endDate: Date) async throws -> [HydrationEvent] {
            if let readError { throw readError }
            return []
        }
        func readBodyProfile() async throws -> BodyProfile { BodyProfile(heightCM: nil, weightKG: nil) }
        func setAGlassOfWater() async throws {}
        func setWaterIntake(volumeML: Int, idempotencyKey: String?) async throws {
            if let writeError { throw writeError }
            saved.append((volumeML, idempotencyKey))
        }
        func deleteWaterSample(id: UUID) async throws -> Bool { false }
        func resetWaterInTakeInToday() async throws {}
    }

    @Test("실제 Repository와 DataSource를 거쳐 알림 식별자와 기본 용량을 HealthKit 쓰기에 전달한다")
    func writePipeline() async {
        let health = HealthKitSource()
        let source = DrinkWaterHealthKitDataSource(healthKitDataSource: health)
        let useCase = DrinkWaterUseCaseImpl(repository: DrinkWaterRepositoryImpl(dataSource: source))
        #expect(await useCase.drinkWaterFromReminder(idempotencyKey: "morning.100", dailyGoalML: 2_000) == .saved)
        #expect(health.saved.count == 1)
        #expect(health.saved.first?.0 == HydrationServing.defaultGlassVolumeML)
        #expect(health.saved.first?.1 == "morning.100")
    }

    @Test("HealthKit 조회 실패나 권한 철회를 성공으로 반환하지 않는다")
    func unavailableHealthKit() async {
        let health = HealthKitSource()
        let source = DrinkWaterHealthKitDataSource(healthKitDataSource: health)
        let useCase = DrinkWaterUseCaseImpl(repository: DrinkWaterRepositoryImpl(dataSource: source))
        health.readError = HealthKitError.healthKitInternalError
        #expect(await useCase.drinkWaterFromReminder(idempotencyKey: "1", dailyGoalML: 2_000) == .failed(.systemError))
        health.readError = nil
        health.writeError = HealthKitError.permissionDenied
        #expect(await useCase.drinkWaterFromReminder(idempotencyKey: "1", dailyGoalML: 2_000) == .failed(.permissionDenied))
        #expect(health.saved.isEmpty)
    }
}
