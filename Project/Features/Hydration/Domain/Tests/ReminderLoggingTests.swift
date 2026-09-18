import Foundation
import Testing
@testable import HydrationDomain

struct ReminderLoggingTests {
    @Test("알림은 기본 한 잔과 중복 방지 식별자를 기존 저장소로 전달한다")
    func defaultServingAndIdentity() async {
        let repository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: repository)
        let result = await useCase.drinkWaterFromReminder(idempotencyKey: "morning.1", dailyGoalML: 2_000)
        #expect(result == .saved)
        #expect(repository.recordedVolumesML == [HydrationServing.defaultGlassVolumeML])
        #expect(repository.recordedIdempotencyKeys == ["morning.1"])
    }

    @Test("목표를 넘거나 조회가 실패하면 쓰기를 시도하지 않는다")
    func failedPreflightDoesNotWrite() async {
        let repository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: repository)
        repository.setCurrentWaterIntakeML(2_000)
        #expect(await useCase.drinkWaterFromReminder(idempotencyKey: "1", dailyGoalML: 2_000) == .goalExceeded)
        repository.loggingReadError = HealthKitError.healthKitInternalError
        #expect(await useCase.drinkWaterFromReminder(idempotencyKey: "2", dailyGoalML: 2_000) == .failed(.systemError))
        #expect(repository.drinkWaterCallCount == 0)
    }

    @Test("권한 철회와 저장 실패를 성공으로 바꾸지 않는다", arguments: [
        HydrationWriteFailureReason.permissionDenied, .invalidObjectType, .systemError
    ])
    func writeFailure(reason: HydrationWriteFailureReason) async {
        let repository = MockDrinkWaterRepository()
        repository.drinkWaterResult = .failure(reason)
        let useCase = DrinkWaterUseCaseImpl(repository: repository)
        #expect(await useCase.drinkWaterFromReminder(idempotencyKey: "1", dailyGoalML: 2_000) == .failed(reason))
    }
}
