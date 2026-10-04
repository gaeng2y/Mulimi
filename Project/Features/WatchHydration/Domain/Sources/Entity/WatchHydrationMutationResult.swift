import Foundation

public struct WatchHydrationMutationResult: Equatable, Sendable {
    /// Nil means the refresh failed; writeResult still describes the completed mutation.
    public let snapshot: WatchHydrationSnapshot?
    public let writeResult: HydrationWriteResult

    public init(
        snapshot: WatchHydrationSnapshot?,
        writeResult: HydrationWriteResult
    ) {
        self.snapshot = snapshot
        self.writeResult = writeResult
    }
}
