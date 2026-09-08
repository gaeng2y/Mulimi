import Foundation

public struct WatchHydrationSnapshot: Equatable, Sendable {
    public let dailyGoalML: Int
    public let todayIntakeML: Int
    public let events: [WatchHydrationEvent]
    public let nextActionGuide: HydrationNextActionGuide

    public var isGoalReached: Bool {
        dailyGoalML > 0 && todayIntakeML >= dailyGoalML
    }

    public var remainingML: Int {
        max(0, dailyGoalML - todayIntakeML)
    }

    public var progress: Double {
        guard dailyGoalML > 0 else {
            return 0
        }

        return min(Double(todayIntakeML) / Double(dailyGoalML), 1)
    }

    public var eventCount: Int {
        events.count
    }

    public var lastDrinkDate: Date? {
        events.last?.consumedAt
    }

    public init(
        dailyGoalML: Int,
        todayIntakeML: Int,
        events: [WatchHydrationEvent],
        nextActionGuide: HydrationNextActionGuide? = nil
    ) {
        self.dailyGoalML = dailyGoalML
        self.todayIntakeML = todayIntakeML
        self.events = events
        self.nextActionGuide = nextActionGuide ?? HydrationNextActionGuide.make(
            currentIntakeML: Double(todayIntakeML),
            dailyGoalML: Double(dailyGoalML)
        )
    }

    public static func empty(dailyGoalML: Int) -> Self {
        Self(
            dailyGoalML: dailyGoalML,
            todayIntakeML: 0,
            events: []
        )
    }
}
