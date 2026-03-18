import Foundation

public enum HydrationChallengeKind: String, CaseIterable, Codable, Identifiable, Sendable {
    case streak7
    case weeklyAchievement80
    case goalAchievement30

    public var id: String { rawValue }

    public var stateType: HydrationChallengeStateType {
        switch self {
        case .streak7, .weeklyAchievement80:
            return .recurring
        case .goalAchievement30:
            return .cumulative
        }
    }

    public var resetPolicy: HydrationChallengeResetPolicy {
        switch self {
        case .streak7:
            return .streakBreak
        case .weeklyAchievement80:
            return .weekly
        case .goalAchievement30:
            return .never
        }
    }

    public func recurringCycleID(
        referenceDate: Date,
        calendar: Calendar,
        streakStartDate: Date? = nil
    ) -> String? {
        switch self {
        case .streak7:
            guard let streakStartDate else {
                return nil
            }
            return Self.cycleID(prefix: "streak", date: streakStartDate, calendar: calendar)
        case .weeklyAchievement80:
            guard let weekInterval = calendar.dateInterval(of: .weekOfYear, for: referenceDate) else {
                return nil
            }
            return Self.cycleID(prefix: "week", date: weekInterval.start, calendar: calendar)
        case .goalAchievement30:
            return nil
        }
    }

    private static func cycleID(prefix: String, date: Date, calendar: Calendar) -> String {
        "\(prefix):\(Int(calendar.startOfDay(for: date).timeIntervalSince1970))"
    }
}

public enum HydrationChallengeStateType: String, Codable, Sendable {
    case recurring
    case cumulative
}

public enum HydrationChallengeResetPolicy: String, Codable, Sendable {
    case streakBreak
    case weekly
    case never
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

public enum HydrationChallengeState: Identifiable, Codable, Equatable, Sendable {
    case recurring(HydrationRecurringChallengeState)
    case cumulative(HydrationCumulativeChallengeState)

    public var kind: HydrationChallengeKind {
        switch self {
        case let .recurring(state):
            return state.kind
        case let .cumulative(state):
            return state.kind
        }
    }

    public var progress: Double {
        switch self {
        case let .recurring(state):
            return state.progress
        case let .cumulative(state):
            return state.progress
        }
    }

    public var isCompleted: Bool {
        switch self {
        case let .recurring(state):
            return state.isCompleted
        case let .cumulative(state):
            return state.isCompleted
        }
    }

    public var achievedAt: Date? {
        switch self {
        case let .recurring(state):
            return state.achievedAt
        case let .cumulative(state):
            return state.achievedAt
        }
    }

    public var updatedAt: Date {
        switch self {
        case let .recurring(state):
            return state.updatedAt
        case let .cumulative(state):
            return state.updatedAt
        }
    }

    public var recurringState: HydrationRecurringChallengeState? {
        guard case let .recurring(state) = self else {
            return nil
        }
        return state
    }

    public var cumulativeState: HydrationCumulativeChallengeState? {
        guard case let .cumulative(state) = self else {
            return nil
        }
        return state
    }

    public var id: HydrationChallengeKind { kind }
}

public struct HydrationRecurringChallengeState: Identifiable, Codable, Equatable, Sendable {
    public let kind: HydrationChallengeKind
    public let cycleID: String?
    public var progress: Double
    public var isCompleted: Bool
    public var achievedAt: Date?
    public var updatedAt: Date

    public init(
        kind: HydrationChallengeKind,
        cycleID: String?,
        progress: Double,
        isCompleted: Bool,
        achievedAt: Date?,
        updatedAt: Date
    ) {
        self.kind = kind
        self.cycleID = cycleID
        self.progress = progress
        self.isCompleted = isCompleted
        self.achievedAt = achievedAt
        self.updatedAt = updatedAt
    }

    public var id: HydrationChallengeKind { kind }
}

public struct HydrationCumulativeChallengeState: Identifiable, Codable, Equatable, Sendable {
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
