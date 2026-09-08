import Foundation

public struct HydrationChallengeBadgeHistory: Identifiable, Codable, Equatable, Sendable {
    public let id: String
    public let kind: HydrationChallengeKind
    public let achievedAt: Date
    public let cycleID: String?

    public init(
        kind: HydrationChallengeKind,
        achievedAt: Date,
        cycleID: String? = nil
    ) {
        self.kind = kind
        self.achievedAt = achievedAt
        self.cycleID = cycleID
        self.id = Self.makeID(kind: kind, cycleID: cycleID)
    }

    public static func makeID(kind: HydrationChallengeKind, cycleID: String?) -> String {
        guard kind.stateType == .recurring, let cycleID else {
            return kind.rawValue
        }

        return "\(kind.rawValue):\(cycleID)"
    }
}
