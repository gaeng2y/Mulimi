import Foundation

public struct WatchHydrationEvent: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let consumedAt: Date
    public let volumeML: Int

    public init(id: UUID, consumedAt: Date, volumeML: Int) {
        self.id = id
        self.consumedAt = consumedAt
        self.volumeML = volumeML
    }
}
