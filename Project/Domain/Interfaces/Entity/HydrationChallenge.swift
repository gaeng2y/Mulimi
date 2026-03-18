import Foundation

public enum HydrationChallengeKind: String, CaseIterable, Codable, Identifiable, Sendable {
    case streak7
    case weeklyAchievement80
    case goalAchievement30

    public var id: String { rawValue }
}

public struct HydrationChallenge: Identifiable, Equatable, Sendable {
    public let kind: HydrationChallengeKind
    public let progress: Double
    public let currentValue: Double
    public let targetValue: Double
    public let primaryCurrentValue: Int
    public let primaryTargetValue: Int
    public let secondaryCurrentValue: Int?
    public let secondaryTargetValue: Int?
    public let isCompleted: Bool
    public let achievedAt: Date?

    public init(
        kind: HydrationChallengeKind,
        progress: Double,
        currentValue: Double,
        targetValue: Double,
        primaryCurrentValue: Int,
        primaryTargetValue: Int,
        secondaryCurrentValue: Int? = nil,
        secondaryTargetValue: Int? = nil,
        isCompleted: Bool,
        achievedAt: Date?
    ) {
        self.kind = kind
        self.progress = progress
        self.currentValue = currentValue
        self.targetValue = targetValue
        self.primaryCurrentValue = primaryCurrentValue
        self.primaryTargetValue = primaryTargetValue
        self.secondaryCurrentValue = secondaryCurrentValue
        self.secondaryTargetValue = secondaryTargetValue
        self.isCompleted = isCompleted
        self.achievedAt = achievedAt
    }

    public var id: HydrationChallengeKind { kind }
}

public struct HydrationChallengeState: Identifiable, Codable, Equatable, Sendable {
    public let kind: HydrationChallengeKind
    public var progress: Double
    public var isCompleted: Bool
    public var achievedAt: Date?
    public var updatedAt: Date

    public init(
        kind: HydrationChallengeKind,
        progress: Double,
        isCompleted: Bool,
        achievedAt: Date?,
        updatedAt: Date
    ) {
        self.kind = kind
        self.progress = progress
        self.isCompleted = isCompleted
        self.achievedAt = achievedAt
        self.updatedAt = updatedAt
    }

    public var id: HydrationChallengeKind { kind }
}
