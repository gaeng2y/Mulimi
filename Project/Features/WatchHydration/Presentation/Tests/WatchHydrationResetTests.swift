import Foundation
import Synchronization
import Testing
import WatchHydrationDomain
@testable import WatchHydrationPresentation

@MainActor
struct WatchHydrationResetTests {
    @Test("삭제 진입·중복 진입·취소·닫기는 UseCase를 호출하지 않고 취소한 확인은 무효다")
    func confirmationAndCancellationDoNotDelete() async throws {
        let (model, useCase, _) = await makeModel()
        let snapshot = model.snapshot
        model.requestResetConfirmation()
        let confirmation = try #require(model.resetConfirmation)
        model.requestResetConfirmation()
        #expect(model.resetConfirmation == confirmation)
        #expect(await useCase.resetDates.isEmpty)
        await model.confirmReset(id: UUID())
        #expect(await useCase.resetDates.isEmpty)

        model.cancelResetConfirmation()
        await model.confirmReset(id: confirmation.id)
        #expect(model.resetConfirmation == nil)
        #expect(model.snapshot == snapshot)
        #expect(await useCase.resetDates.isEmpty)

        model.requestResetConfirmation()
        let retry = try #require(model.resetConfirmation)
        #expect(retry.id != confirmation.id)
        await model.confirmReset(id: retry.id)
        #expect(await useCase.resetDates == [retry.date])
        #expect(model.snapshot.events.isEmpty)
    }

    @Test("확인 중 날짜가 바뀌면 새 날짜를 다시 확인해야 삭제하며 이전 확인은 재사용하지 않는다")
    func midnightRequiresAnotherConfirmation() async throws {
        let (model, useCase, clock) = await makeModel()
        model.requestResetConfirmation()
        let yesterday = try #require(model.resetConfirmation)
        clock.date = Calendar.current.startOfDay(for: clock.date).addingTimeInterval(86_400)

        await model.confirmReset(id: yesterday.id)
        let today = try #require(model.resetConfirmation)
        #expect(today.id != yesterday.id)
        #expect(today.date == clock.date)
        #expect(today.dateChanged)
        #expect(model.hasCurrentSnapshot)
        #expect(await useCase.loadCount == 2)
        #expect(await useCase.resetDates.isEmpty)
        await model.confirmReset(id: yesterday.id)
        #expect(await useCase.resetDates.isEmpty)

        await model.confirmReset(id: today.id)
        #expect(await useCase.resetDates == [today.date])
        #expect(model.resetConfirmation == nil)
    }

    @Test("확인 후 실행 중 날짜가 바뀌어도 확인한 날짜만 삭제한다", .timeLimit(.minutes(1)))
    func confirmedDateDoesNotMoveDuringDeletion() async throws {
        let (model, useCase, clock) = await makeModel()
        model.requestResetConfirmation()
        let confirmation = try #require(model.resetConfirmation)
        await useCase.holdNext(.reset)
        let deletion = Task { await model.confirmReset(id: confirmation.id) }
        while !(await useCase.isWaiting) { await Task.yield() }
        clock.date = clock.date.addingTimeInterval(86_400)
        await useCase.resume()
        await deletion.value

        #expect(await useCase.resetDates == [confirmation.date])
        #expect(!model.hasCurrentSnapshot)
        #expect(model.hasReadError)
        await model.load()
        #expect(model.hasCurrentSnapshot)
        #expect(!model.hasReadError)
        #expect(await useCase.resetDates.count == 1)
    }

    @Test("삭제 실패는 기존 스냅샷·취소 영수증을 유지하며 새 확인으로 재시도한다",
          arguments: [HydrationWriteFailureReason.permissionDenied, .invalidObjectType, .systemError])
    func deletionFailurePreservesState(reason: HydrationWriteFailureReason) async throws {
        let (model, useCase, _) = await makeModel()
        await model.drinkWater()
        let receipt = try #require(model.undoableEvent)
        let snapshot = model.snapshot
        await useCase.failReset(with: reason)
        model.requestResetConfirmation()
        let failed = try #require(model.resetConfirmation)
        await model.confirmReset(id: failed.id)

        #expect(model.snapshot == snapshot)
        #expect(model.undoableEvent == receipt)
        #expect(model.mutationErrorMessage != nil)
        #expect(!model.didUndoLastDrink)
        #expect(!model.isMutating)
        await model.confirmReset(id: failed.id)
        #expect(await useCase.resetDates.count == 1)

        model.clearMutationError()
        await useCase.failReset(with: nil)
        model.requestResetConfirmation()
        let retry = try #require(model.resetConfirmation)
        await model.confirmReset(id: retry.id)
        #expect(await useCase.resetDates.count == 2)
        #expect(model.snapshot.events.isEmpty)
        #expect(model.undoableEvent == nil)
        #expect(model.mutationErrorMessage == nil)
    }

    @Test("삭제 대기 중 중복 확인·기록·되돌리기·조회는 실행하지 않는다", .timeLimit(.minutes(1)))
    func deletionBlocksOverlappingActions() async throws {
        let (model, useCase, _) = await makeModel()
        await model.drinkWater()
        let receipt = try #require(model.undoableEvent)
        model.requestResetConfirmation()
        let confirmation = try #require(model.resetConfirmation)
        await useCase.holdNext(.reset)
        let deletion = Task { await model.confirmReset(id: confirmation.id) }
        while !(await useCase.isWaiting) { await Task.yield() }

        #expect(model.isMutating)
        await model.confirmReset(id: confirmation.id)
        model.requestResetConfirmation()
        await model.drinkWater()
        await model.undoLastDrink(id: receipt.id)
        await model.load()
        #expect(model.resetConfirmation == nil)
        #expect(await useCase.resetDates.count == 1)
        #expect(await useCase.drinkCount == 1)
        #expect(await useCase.undoCount == 0)
        #expect(await useCase.loadCount == 1)
        await useCase.resume()
        await deletion.value
        #expect(!model.isMutating)
    }

    @Test("조회 중 확인은 보류하고 조회가 끝난 뒤 같은 확인으로 삭제한다", .timeLimit(.minutes(1)))
    func loadingBlocksConfirmation() async throws {
        let (model, useCase, _) = await makeModel()
        model.requestResetConfirmation()
        let confirmation = try #require(model.resetConfirmation)
        await useCase.holdNext(.load)
        let loading = Task { await model.load() }
        while !(await useCase.isWaiting) { await Task.yield() }
        await model.confirmReset(id: confirmation.id)
        #expect(await useCase.resetDates.isEmpty)
        #expect(model.resetConfirmation == confirmation)
        await useCase.resume()
        await loading.value
        await model.confirmReset(id: confirmation.id)
        #expect(await useCase.resetDates.count == 1)
    }

    @Test("기록 중에는 전체 삭제 확인을 열지 않는다", .timeLimit(.minutes(1)))
    func recordingBlocksResetRequest() async {
        let (model, useCase, _) = await makeModel()
        await useCase.holdNext(.drink)
        let recording = Task { await model.drinkWater() }
        while !(await useCase.isWaiting) { await Task.yield() }
        model.requestResetConfirmation()
        #expect(model.resetConfirmation == nil)
        #expect(await useCase.resetDates.isEmpty)
        await useCase.resume()
        await recording.value
        #expect(model.canRequestReset)
    }

    @Test("전체 삭제 확인이 열려 있는 동안 기록과 한 건 되돌리기를 실행하지 않는다")
    func pendingConfirmationBlocksOtherMutations() async throws {
        let (model, useCase, _) = await makeModel()
        await model.drinkWater()
        let receipt = try #require(model.undoableEvent)
        model.requestResetConfirmation()
        await model.drinkWater()
        await model.undoLastDrink(id: receipt.id)
        #expect(await useCase.drinkCount == 1)
        #expect(await useCase.undoCount == 0)
        #expect(model.undoableEvent == receipt)
        model.cancelResetConfirmation()
        await model.undoLastDrink(id: receipt.id)
        #expect(await useCase.undoCount == 1)
    }

    private func makeModel() async -> (WatchHydrationViewModel, ResetUseCase, ResetClock) {
        let clock = ResetClock()
        let useCase = ResetUseCase(date: clock.date)
        let model = WatchHydrationViewModel(useCase: useCase, now: { clock.date })
        await model.load()
        return (model, useCase, clock)
    }
}

private final class ResetClock: Sendable {
    private let value = Mutex(Date(timeIntervalSince1970: 1_790_640_000))
    var date: Date {
        get { value.withLock { $0 } }
        set { value.withLock { $0 = newValue } }
    }
}

private actor ResetUseCase: WatchHydrationUseCase {
    enum Action { case load, drink, reset }

    private var snapshot: WatchHydrationSnapshot
    private var failure: HydrationWriteFailureReason?
    private var heldAction: Action?
    private var continuation: CheckedContinuation<Void, Never>?
    var isWaiting: Bool { continuation != nil }
    private(set) var resetDates: [Date] = []
    private(set) var loadCount = 0
    private(set) var drinkCount = 0
    private(set) var undoCount = 0

    init(date: Date) {
        let event = WatchHydrationEvent(id: UUID(), consumedAt: date, volumeML: HydrationServing.defaultGlassVolumeML)
        snapshot = WatchHydrationSnapshot(dailyGoalML: 2_000, todayIntakeML: event.volumeML, events: [event])
    }

    func holdNext(_ action: Action) { heldAction = action }
    func resume() { continuation?.resume(); continuation = nil }
    func failReset(with reason: HydrationWriteFailureReason?) { failure = reason }

    func loadSnapshot(referenceDate: Date) async throws -> WatchHydrationSnapshot {
        loadCount += 1
        await waitIfNeeded(.load)
        return snapshot
    }

    func drinkWater(referenceDate: Date) async throws -> WatchHydrationMutationResult {
        drinkCount += 1
        await waitIfNeeded(.drink)
        let event = WatchHydrationEvent(id: UUID(), consumedAt: referenceDate, volumeML: HydrationServing.defaultGlassVolumeML)
        snapshot = WatchHydrationSnapshot(
            dailyGoalML: snapshot.dailyGoalML,
            todayIntakeML: snapshot.todayIntakeML + event.volumeML,
            events: snapshot.events + [event]
        )
        return WatchHydrationMutationResult(snapshot: snapshot, writeResult: .success, recordedEvent: event)
    }

    func undoDrink(id: UUID, referenceDate: Date) async -> WatchHydrationMutationResult {
        undoCount += 1
        return WatchHydrationMutationResult(snapshot: snapshot, writeResult: .success)
    }

    func reset(referenceDate: Date) async throws -> WatchHydrationMutationResult {
        resetDates.append(referenceDate)
        await waitIfNeeded(.reset)
        if let failure { return WatchHydrationMutationResult(snapshot: snapshot, writeResult: .failure(failure)) }
        snapshot = .empty(dailyGoalML: snapshot.dailyGoalML)
        return WatchHydrationMutationResult(snapshot: snapshot, writeResult: .success)
    }

    private func waitIfNeeded(_ action: Action) async {
        guard heldAction == action else { return }
        heldAction = nil
        await withCheckedContinuation { continuation = $0 }
    }
}
