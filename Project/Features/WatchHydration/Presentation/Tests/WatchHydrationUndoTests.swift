import Foundation
import HealthKit
import MulimiHealthKit
import Synchronization
import Testing
import WatchHydrationDomain

@testable import WatchHydrationData
@testable import WatchHydrationPresentation

@MainActor
struct WatchHydrationUndoTests {
    private let date = Date(timeIntervalSince1970: 1_790_640_000)
    private let volume = HydrationServing.defaultGlassVolumeML

    @Test("동일 시각·용량 및 iPhone 동시 기록이 있어도 저장 영수증의 UUID 한 건만 취소한다")
    func exactSavedRecord() async throws {
        let store = UndoQuantityStore()
        let external = sample(owned: false)
        let phone = sample(owned: true)
        let concurrent = sample(owned: true, offset: 1)
        store.state.withLock {
            $0.samples = [external, phone]
            $0.concurrentSample = concurrent
        }
        let model = await makeModel(store: store)
        await model.drinkWater()

        let receipt = try #require(model.undoableEvent)
        #expect(receipt.id == store.state.withLock { $0.savedIDs.last })
        #expect(receipt.consumedAt == date)
        #expect(receipt.volumeML == volume)
        #expect(model.snapshot.events.last?.id == concurrent.id)
        await model.load()
        #expect(model.undoableEvent == receipt)

        await model.undoLastDrink(id: phone.id)
        await model.undoLastDrink(id: external.id)
        #expect(store.state.withLock { $0.deletedIDs.isEmpty })
        await model.undoLastDrink(id: receipt.id)

        #expect(model.didUndoLastDrink)
        #expect(model.undoableEvent == nil)
        #expect(model.mutationErrorMessage == nil)
        #expect(Set(model.snapshot.events.map(\.id)) == Set([external.id, phone.id, concurrent.id]))
        #expect(model.snapshot.todayIntakeML == volume * 3)
        #expect(store.state.withLock { $0.deletedIDs } == [receipt.id])
        #expect(store.state.withLock { $0.resetCount } == 0)
    }

    @Test("권한 철회·이미 삭제됨·시스템 실패를 성공이나 전체 초기화로 처리하지 않는다",
          arguments: ["denied", "revokedDuringDelete", "missing", "systemError"])
    func undoFailures(mode: String) async throws {
        let store = UndoQuantityStore()
        let model = await makeModel(store: store)
        await model.drinkWater()
        let receipt = try #require(model.undoableEvent)
        store.state.withLock {
            switch mode {
            case "denied": $0.authorization = .sharingDenied
            case "revokedDuringDelete": $0.deleteError = HKError(.errorAuthorizationDenied)
            case "missing": $0.samples = []
            default: $0.deleteError = HealthQuantityStoreError.internalError
            }
        }

        await model.undoLastDrink(id: receipt.id)

        #expect(!model.didUndoLastDrink)
        #expect(model.undoableEvent == receipt)
        #expect(model.mutationErrorMessage != nil)
        #expect(store.state.withLock { $0.resetCount } == 0)
        #expect(store.state.withLock { $0.samples.count } == (mode == "missing" ? 0 : 1))
        if mode == "denied" {
            #expect(store.state.withLock { $0.deletedIDs.isEmpty })
        }
    }

    @Test("저장 실패·권한 거부·목표 초과는 되돌릴 기록을 만들지 않는다",
          arguments: ["saveFailure", "denied", "goalReached"])
    func unsuccessfulRecording(mode: String) async {
        let store = UndoQuantityStore()
        store.state.withLock {
            if mode == "denied" { $0.authorization = .sharingDenied }
            if mode == "saveFailure" { $0.saveError = HealthQuantityStoreError.internalError }
            if mode == "goalReached" { $0.samples = [sample(owned: true)] }
        }
        let model = await makeModel(store: store, goal: mode == "goalReached" ? volume : 2000)
        await model.drinkWater()
        #expect(model.undoableEvent == nil)
        #expect(store.state.withLock { $0.savedIDs.isEmpty })
        #expect((model.mutationErrorMessage != nil) == (mode != "goalReached"))
    }

    @Test("새 저장만 취소 대상을 교체하고 초기화 성공 후에는 영수증을 지운다")
    func candidateLifetime() async throws {
        let store = UndoQuantityStore()
        let model = await makeModel(store: store)
        await model.drinkWater()
        let first = try #require(model.undoableEvent)
        await model.drinkWater()
        let second = try #require(model.undoableEvent)
        #expect(first.id != second.id)
        await model.undoLastDrink(id: first.id)
        #expect(store.state.withLock { $0.deletedIDs.isEmpty })

        let relaunchedModel = await makeModel(store: store)
        await relaunchedModel.load()
        #expect(relaunchedModel.undoableEvent == nil)
        store.state.withLock { $0.authorization = .sharingDenied }
        await model.resetToday()
        #expect(model.undoableEvent == second)
        store.state.withLock { $0.authorization = .sharingAuthorized }
        await model.resetToday()
        #expect(model.undoableEvent == nil)
    }

    @Test("취소 대기 중 중복 취소·기록·초기화·새로고침은 겹쳐 실행하지 않는다", .timeLimit(.minutes(1)))
    func overlappingActions() async throws {
        let store = UndoQuantityStore()
        let model = await makeModel(store: store)
        await model.drinkWater()
        let receipt = try #require(model.undoableEvent)
        let gate = UndoGate()
        store.state.withLock { $0.deleteGate = gate }
        let firstUndo = Task { await model.undoLastDrink(id: receipt.id) }
        while !(await gate.isWaiting) { await Task.yield() }

        await model.undoLastDrink(id: receipt.id)
        await model.drinkWater()
        await model.resetToday()
        await model.load()
        await gate.resume()
        await firstUndo.value

        #expect(model.didUndoLastDrink)
        #expect(!model.isMutating)
        #expect(store.state.withLock { $0.deletedIDs } == [receipt.id])
        #expect(store.state.withLock { $0.savedIDs.count } == 1)
        #expect(store.state.withLock { $0.resetCount } == 0)
    }

    @Test("Core는 저장한 샘플 UUID를 반환하고 삭제 건수가 1일 때만 성공한다", arguments: [0, 1])
    func coreReceiptAndDeleteCount(deletedCount: Int) async throws {
        let healthStore = UndoHealthStore()
        healthStore.state.withLock { $0.deletedCount = deletedCount }
        let store = HealthKitQuantityStore(healthStore: healthStore)
        let identifier = try await store.save(Double(volume), unit: .literUnit(with: .milli), of: .dietaryWater, at: date)
        #expect(identifier == healthStore.state.withLock { $0.savedID })
        let deleted = try await store.deleteOwnedSample(id: identifier, of: .dietaryWater)
        #expect(deleted == (deletedCount == 1))
        let deletion = healthStore.state.withLock { ($0.predicateFormat, $0.typeIdentifier) }
        #expect(deletion.0 == HKQuery.predicateForObject(with: identifier).predicateFormat)
        #expect(deletion.1 == HKQuantityTypeIdentifier.dietaryWater.rawValue)
    }

    private func makeModel(store: UndoQuantityStore, goal: Int = 2000) async -> WatchHydrationViewModel {
        let useCase = WatchHydrationUseCaseImpl(
            hydrationRepository: WatchHydrationRepositoryImpl(
                localDataSource: WatchHydrationHealthKitDataSource(store: store)
            ),
            dailyGoalRepository: UndoDailyGoalRepository(goal: goal)
        )
        let referenceDate = date
        let model = WatchHydrationViewModel(useCase: useCase, now: { referenceDate })
        await model.load()
        return model
    }

    private func sample(owned: Bool, offset: TimeInterval = 0) -> HealthQuantitySample {
        HealthQuantitySample(
            id: UUID(), startDate: date.addingTimeInterval(offset), value: Double(volume), isOwnedByCurrentApp: owned
        )
    }
}

private struct UndoDailyGoalRepository: WatchDailyGoalRepository {
    let goal: Int
    func currentGoalML() async -> Int { goal }
}

private actor UndoGate {
    private var continuation: CheckedContinuation<Void, Never>?
    var isWaiting: Bool { continuation != nil }
    func wait() async { await withCheckedContinuation { continuation = $0 } }
    func resume() { continuation?.resume(); continuation = nil }
}

private final class UndoQuantityStore: HealthQuantityStoring {
    struct State {
        var samples: [HealthQuantitySample] = []
        var concurrentSample: HealthQuantitySample?
        var authorization: HKAuthorizationStatus = .sharingAuthorized
        var saveError: (any Error)?
        var deleteError: (any Error)?
        var deleteGate: UndoGate?
        var savedIDs: [UUID] = []
        var deletedIDs: [UUID] = []
        var resetCount = 0
    }

    let state = Mutex(State())
    let isHealthDataAvailable = true

    func authorizationStatus(for identifier: HKQuantityTypeIdentifier) -> HKAuthorizationStatus {
        state.withLock { $0.authorization }
    }

    func requestAuthorization(share: [HKQuantityTypeIdentifier], read: [HKQuantityTypeIdentifier]) async throws {}

    func samples(
        of identifier: HKQuantityTypeIdentifier, unit: HKUnit, from startDate: Date, to endDate: Date
    ) async throws -> [HealthQuantitySample] {
        state.withLock { $0.samples.filter { $0.startDate >= startDate && $0.startDate < endDate } }
    }

    func dailyCumulativeSums(
        of identifier: HKQuantityTypeIdentifier, unit: HKUnit, from startDate: Date, to endDate: Date
    ) async throws -> [(date: Date, value: Double)] { [] }

    func latestValue(of identifier: HKQuantityTypeIdentifier, unit: HKUnit) async throws -> Double? { nil }

    func save(
        _ value: Double, unit: HKUnit, of identifier: HKQuantityTypeIdentifier, at date: Date, syncIdentifier: String?
    ) async throws -> UUID {
        try state.withLock {
            if let error = $0.saveError { throw error }
            let sample = HealthQuantitySample(id: UUID(), startDate: date, value: value, isOwnedByCurrentApp: true)
            $0.samples.append(sample)
            $0.savedIDs.append(sample.id)
            if let concurrent = $0.concurrentSample { $0.samples.append(concurrent) }
            return sample.id
        }
    }

    func deleteOwnedSample(id: UUID, of identifier: HKQuantityTypeIdentifier) async throws -> Bool {
        let gate = state.withLock { $0.deletedIDs.append(id); return $0.deleteGate }
        await gate?.wait()
        return try state.withLock {
            if let error = $0.deleteError { throw error }
            guard let index = $0.samples.firstIndex(where: { $0.id == id && $0.isOwnedByCurrentApp }) else { return false }
            $0.samples.remove(at: index)
            return true
        }
    }

    func deleteOwnedSamples(of identifier: HKQuantityTypeIdentifier, from startDate: Date, to endDate: Date) async throws {
        state.withLock {
            $0.resetCount += 1
            $0.samples.removeAll { $0.isOwnedByCurrentApp && $0.startDate >= startDate && $0.startDate < endDate }
        }
    }
}

private final class UndoHealthStore: HKHealthStore, @unchecked Sendable {
    struct State {
        var savedID: UUID?
        var deletedCount = 0
        var predicateFormat: String?
        var typeIdentifier: String?
    }
    let state = Mutex(State())

    override func save(_ object: HKObject, withCompletion completion: @escaping @Sendable (Bool, (any Error)?) -> Void) {
        state.withLock { $0.savedID = object.uuid }
        completion(true, nil)
    }

    override func deleteObjects(
        of objectType: HKObjectType, predicate: NSPredicate,
        withCompletion completion: @escaping @Sendable (Bool, Int, (any Error)?) -> Void
    ) {
        let count = state.withLock {
            $0.typeIdentifier = objectType.identifier
            $0.predicateFormat = predicate.predicateFormat
            return $0.deletedCount
        }
        completion(true, count, nil)
    }
}
