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
        guard !isMutating else {
            return
        }

        isMutating = true
        defer { isMutating = false }
        snapshot = await useCase.drinkWater(referenceDate: now())
    }

    func resetToday() async {
        guard !isMutating else {
            return
        }

        isMutating = true
        defer { isMutating = false }
        snapshot = await useCase.reset(referenceDate: now())
    }
}
