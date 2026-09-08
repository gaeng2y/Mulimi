import Foundation

public struct WatchHydrationMutationResult: Equatable, Sendable {
    public let snapshot: WatchHydrationSnapshot
    public let writeResult: HydrationWriteResult

    public init(
        snapshot: WatchHydrationSnapshot,
        writeResult: HydrationWriteResult
    ) {
        self.snapshot = snapshot
        self.writeResult = writeResult
    }
}
