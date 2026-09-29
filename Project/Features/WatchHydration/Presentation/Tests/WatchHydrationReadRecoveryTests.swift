import Foundation
import HealthKit
import MulimiHealthKit
import Testing
import WatchHydrationDomain
@testable import WatchHydrationData
@testable import WatchHydrationPresentation

@MainActor
struct WatchHydrationReadRecoveryTests {
    @Test("실제 Watch Data 조회 오류는 빈 스냅샷으로 변환되지 않는다")
    func dataFailurePropagates() async {
        let source = WatchHydrationHealthKitDataSource(store: UnavailableHealthStore())
        let repository = WatchHydrationRepositoryImpl(localDataSource: source)
        await #expect(throws: CocoaError.self) {
            try await repository.hydrationEvents(on: .now)
        }
    }

    @Test("첫 조회 실패를 정상 0과 구분하고 재시도로 복구한다")
    func firstReadFailureRecovers() async {
        let repository = ReadRecoveryRepository()
        repository.readError = CocoaError(.fileReadUnknown)
        let model = makeModel(repository)
        await model.load()
        #expect(model.hasReadError)
        #expect(!model.hasCurrentSnapshot)
        #expect(!model.canDrinkWater)
        repository.readError = nil
        await model.load()
        #expect(!model.hasReadError)
        #expect(model.hasCurrentSnapshot)
        #expect(model.snapshot.todayIntakeML == 0)
        #expect(model.canDrinkWater)
    }

    @Test("기록 직전 조회 실패는 쓰기를 차단하고 이전 정상 값을 유지한다")
    func preflightFailureBlocksWrite() async {
        let repository = ReadRecoveryRepository()
        repository.events = [WatchHydrationEvent(id: UUID(), consumedAt: .now, volumeML: 500)]
        let model = makeModel(repository)
        await model.load()
        repository.readError = CocoaError(.fileReadUnknown)
        await model.drinkWater()
        #expect(model.hasReadError)
        #expect(model.snapshot.todayIntakeML == 500)
        #expect(repository.writeCount == 0)
    }

    @Test("저장 성공 후 조회 실패는 쓰기 오류가 아니며 재시도는 조회만 한다")
    func successfulWriteFailedRefresh() async {
        let repository = ReadRecoveryRepository()
        repository.failAfterWrite = true
        let model = makeModel(repository)
        await model.load()
        await model.drinkWater()
        #expect(model.hasReadError)
        #expect(model.mutationErrorMessage == nil)
        #expect(model.undoableEvent == repository.events.first)
        #expect(repository.writeCount == 1)
        await model.drinkWater()
        await model.load()
        #expect(repository.writeCount == 1)
        repository.readError = nil
        await model.load()
        #expect(!model.hasReadError)
        #expect(model.snapshot.todayIntakeML == HydrationServing.defaultGlassVolumeML)
        #expect(repository.writeCount == 1)
    }

    @Test("취소 성공 후 조회 실패도 같은 기록을 다시 삭제하지 않는다")
    func successfulUndoFailedRefresh() async throws {
        let repository = ReadRecoveryRepository()
        repository.failAfterWrite = true
        let model = makeModel(repository)
        await model.load()
        await model.drinkWater()
        let event = try #require(model.undoableEvent)

        await model.undoLastDrink(id: event.id)
        #expect(model.hasReadError)
        #expect(model.mutationErrorMessage == nil)
        #expect(model.didUndoLastDrink)
        #expect(model.undoableEvent == nil)
        #expect(repository.deleteCount == 1)

        await model.undoLastDrink(id: event.id)
        repository.readError = nil
        await model.load()
        #expect(!model.hasReadError)
        #expect(model.snapshot.events.isEmpty)
        #expect(repository.deleteCount == 1)
        #expect(repository.writeCount == 1)
        #expect(repository.resetCount == 0)
    }

    @Test("취소와 조회가 함께 실패하면 취소 대상을 유지하고 두 실패를 구분한다")
    func failedUndoAndRefreshPreserveReceipt() async throws {
        let repository = ReadRecoveryRepository()
        let model = makeModel(repository)
        await model.load()
        await model.drinkWater()
        let event = try #require(model.undoableEvent)
        repository.deleteResult = .failure(.permissionDenied)
        repository.readError = CocoaError(.fileReadUnknown)

        await model.undoLastDrink(id: event.id)
        #expect(model.hasReadError)
        #expect(model.mutationErrorMessage != nil)
        #expect(!model.didUndoLastDrink)
        #expect(model.undoableEvent == event)
        #expect(repository.events == [event])
        #expect(repository.resetCount == 0)
    }

    @Test("초기화 성공 후 조회 실패도 초기화를 다시 실행하지 않는다")
    func successfulResetFailedRefresh() async {
        let repository = ReadRecoveryRepository()
        repository.events = [WatchHydrationEvent(id: UUID(), consumedAt: .now, volumeML: 500)]
        repository.failAfterWrite = true
        let model = makeModel(repository)
        await model.load()
        await model.resetToday()
        #expect(model.hasReadError)
        #expect(model.mutationErrorMessage == nil)
        repository.readError = nil
        await model.load()
        #expect(model.snapshot.todayIntakeML == 0)
        #expect(repository.resetCount == 1)
    }

    @Test("다음 날 조회 실패는 전날 스냅샷을 오늘 기록으로 노출하지 않는다")
    func dayChangeInvalidatesSnapshot() async {
        let repository = ReadRecoveryRepository()
        let clock = WatchReadRecoveryClock()
        let model = WatchHydrationViewModel(
            useCase: WatchHydrationUseCaseImpl(hydrationRepository: repository, dailyGoalRepository: ReadRecoveryGoal()),
            now: { clock.date }
        )
        await model.load()
        #expect(model.hasCurrentSnapshot)
        clock.date = clock.date.addingTimeInterval(86_400)
        repository.readError = CocoaError(.fileReadUnknown)
        await model.load()
        #expect(!model.hasCurrentSnapshot)
        #expect(model.hasReadError)
    }

    private func makeModel(_ repository: ReadRecoveryRepository) -> WatchHydrationViewModel {
        WatchHydrationViewModel(
            useCase: WatchHydrationUseCaseImpl(hydrationRepository: repository, dailyGoalRepository: ReadRecoveryGoal())
        )
    }
}

private final class WatchReadRecoveryClock: @unchecked Sendable {
    var date = Date.now
}

private struct ReadRecoveryGoal: WatchDailyGoalRepository {
    func currentGoalML() async -> Int { 2_000 }
}

private final class ReadRecoveryRepository: WatchHydrationRepository, @unchecked Sendable {
    var events: [WatchHydrationEvent] = []
    var readError: Error?
    var failAfterWrite = false
    var writeCount = 0
    var resetCount = 0
    var deleteCount = 0
    var deleteResult: HydrationWriteResult = .success

    func hydrationEvents(on date: Date) async throws -> [WatchHydrationEvent] {
        if let readError { throw readError }
        return events
    }

    func addDrink(volumeML: Int, consumedAt: Date) async -> Result<WatchHydrationEvent, HydrationWriteFailureReason> {
        writeCount += 1
        let event = WatchHydrationEvent(id: UUID(), consumedAt: consumedAt, volumeML: volumeML)
        events.append(event)
        if failAfterWrite { readError = CocoaError(.fileReadUnknown) }
        return .success(event)
    }

    func deleteDrink(id: UUID) async -> HydrationWriteResult {
        deleteCount += 1
        guard deleteResult.isSuccess else { return deleteResult }
        guard let index = events.firstIndex(where: { $0.id == id }) else { return .failure(.systemError) }
        events.remove(at: index)
        if failAfterWrite { readError = CocoaError(.fileReadUnknown) }
        return .success
    }

    func resetEvents(on date: Date) async -> HydrationWriteResult {
        resetCount += 1
        events = []
        if failAfterWrite { readError = CocoaError(.fileReadUnknown) }
        return .success
    }
}

private struct UnavailableHealthStore: HealthQuantityStoring {
    var isHealthDataAvailable: Bool { true }
    func authorizationStatus(for identifier: HKQuantityTypeIdentifier) -> HKAuthorizationStatus { .sharingAuthorized }
    func requestAuthorization(share: [HKQuantityTypeIdentifier], read: [HKQuantityTypeIdentifier]) async throws {}
    func dailyCumulativeSums(
        of identifier: HKQuantityTypeIdentifier, unit: HKUnit, from startDate: Date, to endDate: Date
    ) async throws -> [(date: Date, value: Double)] { throw CocoaError(.fileReadUnknown) }
    func samples(
        of identifier: HKQuantityTypeIdentifier, unit: HKUnit, from startDate: Date, to endDate: Date
    ) async throws -> [HealthQuantitySample] { throw CocoaError(.fileReadUnknown) }
    func latestValue(of identifier: HKQuantityTypeIdentifier, unit: HKUnit) async throws -> Double? { nil }
    func save(
        _ value: Double, unit: HKUnit, of identifier: HKQuantityTypeIdentifier, at date: Date, syncIdentifier: String?
    ) async throws -> UUID { throw CocoaError(.fileWriteUnknown) }
    func deleteOwnedSample(id: UUID, of identifier: HKQuantityTypeIdentifier) async throws -> Bool { false }
    func deleteOwnedSamples(of identifier: HKQuantityTypeIdentifier, from startDate: Date, to endDate: Date) async throws {}
}
