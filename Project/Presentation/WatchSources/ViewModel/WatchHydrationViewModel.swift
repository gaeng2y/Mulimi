import Foundation
import Observation
import WatchDomainLayerInterface

@MainActor
@Observable
public final class WatchHydrationViewModel {
    private let useCase: WatchHydrationUseCase
    private let now: @Sendable () -> Date

    var snapshot: WatchHydrationSnapshot
    var isMutating = false
    var mutationErrorMessage: String?

    var canDrinkWater: Bool {
        snapshot.dailyGoalML <= 0 ||
        snapshot.todayIntakeML + HydrationServing.defaultGlassVolumeML <= snapshot.dailyGoalML
    }

    public init(
        useCase: WatchHydrationUseCase,
        initialSnapshot: WatchHydrationSnapshot = .empty(dailyGoalML: 0),
        now: @escaping @Sendable () -> Date = { .now }
    ) {
        self.useCase = useCase
        self.now = now
        self.snapshot = initialSnapshot
    }

    func load() async {
        snapshot = await useCase.loadSnapshot(referenceDate: now())
    }

    func drinkWater() async {
        guard !isMutating, canDrinkWater else {
            return
        }

        isMutating = true
        defer { isMutating = false }
        let result = await useCase.drinkWater(referenceDate: now())
        snapshot = result.snapshot
        mutationErrorMessage = errorMessage(for: result.writeResult, action: .record)
    }

    func resetToday() async {
        guard !isMutating else {
            return
        }

        isMutating = true
        defer { isMutating = false }
        let result = await useCase.reset(referenceDate: now())
        snapshot = result.snapshot
        mutationErrorMessage = errorMessage(for: result.writeResult, action: .reset)
    }

    func clearMutationError() {
        mutationErrorMessage = nil
    }

    private func errorMessage(
        for writeResult: HydrationWriteResult,
        action: MutationAction
    ) -> String? {
        guard let failureReason = writeResult.failureReason else {
            return nil
        }

        switch (action, failureReason) {
        case (.record, .permissionDenied):
            return WatchL10n.tr("watchHydrationRecordPermissionFailure")
        case (.record, .invalidObjectType), (.record, .systemError):
            return WatchL10n.tr("watchHydrationRecordFailure")
        case (.reset, .permissionDenied):
            return WatchL10n.tr("watchHydrationResetPermissionFailure")
        case (.reset, .invalidObjectType), (.reset, .systemError):
            return WatchL10n.tr("watchHydrationResetFailure")
        }
    }

    private enum MutationAction {
        case record
        case reset
    }
}
