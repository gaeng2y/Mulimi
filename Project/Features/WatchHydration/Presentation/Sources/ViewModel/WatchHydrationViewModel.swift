import Foundation
import Observation
import WatchHydrationDomain

@MainActor
@Observable
public final class WatchHydrationViewModel {
    private let useCase: WatchHydrationUseCase
    private let now: @Sendable () -> Date

    var snapshot: WatchHydrationSnapshot
    var isMutating = false
    var isLoading = false
    var hasReadError = false
    private var lastLoadedDate: Date?

    var hasCurrentSnapshot: Bool {
        lastLoadedDate.map { Calendar.current.isDate($0, inSameDayAs: now()) } ?? false
    }
    var mutationErrorMessage: String?

    var canDrinkWater: Bool {
        hasCurrentSnapshot && !hasReadError && !isLoading && (
            snapshot.dailyGoalML <= 0 ||
            snapshot.todayIntakeML + HydrationServing.defaultGlassVolumeML <= snapshot.dailyGoalML
        )
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
        guard !isMutating, !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        let referenceDate = now()
        do {
            let loaded = try await useCase.loadSnapshot(referenceDate: referenceDate)
            guard !Task.isCancelled else { return }
            guard Calendar.current.isDate(referenceDate, inSameDayAs: now()) else {
                hasReadError = true
                return
            }
            snapshot = loaded
            lastLoadedDate = referenceDate
            hasReadError = false
        } catch {
            hasReadError = true
        }
    }

    func drinkWater() async {
        guard !isMutating, canDrinkWater else {
            return
        }

        isMutating = true
        defer { isMutating = false }
        let referenceDate = now()
        do {
            let result = try await useCase.drinkWater(referenceDate: referenceDate)
            apply(result, referenceDate: referenceDate)
            mutationErrorMessage = errorMessage(for: result.writeResult, action: .record)
        } catch {
            hasReadError = true
        }
    }

    func resetToday() async {
        guard !isMutating, !isLoading else {
            return
        }

        isMutating = true
        defer { isMutating = false }
        let referenceDate = now()
        do {
            let result = try await useCase.reset(referenceDate: referenceDate)
            apply(result, referenceDate: referenceDate)
            mutationErrorMessage = errorMessage(for: result.writeResult, action: .reset)
        } catch {
            hasReadError = true
        }
    }

    private func apply(_ result: WatchHydrationMutationResult, referenceDate: Date) {
        if let loaded = result.snapshot, Calendar.current.isDate(referenceDate, inSameDayAs: now()) {
            snapshot = loaded
            lastLoadedDate = referenceDate
            hasReadError = false
        } else {
            hasReadError = true
        }
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
