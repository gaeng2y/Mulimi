public protocol WatchDailyGoalRepository: Sendable {
    func currentGoalML() async -> Int
}
