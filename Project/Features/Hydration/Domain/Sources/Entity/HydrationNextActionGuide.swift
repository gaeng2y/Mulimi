import Foundation

public enum HydrationNextActionGuideState: String, Equatable, Sendable {
    case readyToDrink
    case approachingRoutine
    case goalReached
    case needsGoal
}

public struct HydrationRoutineSchedule: Equatable, Sendable {
    public let id: String
    public let title: String
    public let hour: Int
    public let minute: Int
    public let weekdayRawValues: Set<Int>
    public let isEnabled: Bool

    public init(
        id: String,
        title: String,
        hour: Int,
        minute: Int,
        weekdayRawValues: Set<Int>,
        isEnabled: Bool
    ) {
        self.id = id
        self.title = title
        self.hour = hour
        self.minute = minute
        self.weekdayRawValues = weekdayRawValues
        self.isEnabled = isEnabled
    }
}

public struct HydrationNextRoutineContext: Equatable, Sendable {
    public let id: String
    public let title: String
    public let hour: Int
    public let minute: Int
    public let minutesUntil: Int

    public init(
        id: String,
        title: String,
        hour: Int,
        minute: Int,
        minutesUntil: Int
    ) {
        self.id = id
        self.title = title
        self.hour = hour
        self.minute = minute
        self.minutesUntil = minutesUntil
    }
}

public struct HydrationNextActionGuide: Equatable, Sendable {
    private enum Constants {
        static let approachingRoutineMinutes = 60
    }

    public let state: HydrationNextActionGuideState
    public let currentIntakeML: Int
    public let dailyGoalML: Int
    public let remainingML: Int
    public let remainingGlassCount: Int
    public let nextRoutine: HydrationNextRoutineContext?

    public var progress: Double {
        guard dailyGoalML > 0 else {
            return 0
        }

        return min(max(Double(currentIntakeML) / Double(dailyGoalML), 0), 1)
    }

    public init(
        state: HydrationNextActionGuideState,
        currentIntakeML: Int,
        dailyGoalML: Int,
        remainingML: Int,
        remainingGlassCount: Int,
        nextRoutine: HydrationNextRoutineContext?
    ) {
        self.state = state
        self.currentIntakeML = currentIntakeML
        self.dailyGoalML = dailyGoalML
        self.remainingML = remainingML
        self.remainingGlassCount = remainingGlassCount
        self.nextRoutine = nextRoutine
    }

    public static func make(
        currentIntakeML: Double,
        dailyGoalML: Double,
        routines: [HydrationRoutineSchedule] = [],
        referenceDate: Date = .now,
        calendar: Calendar = .current
    ) -> HydrationNextActionGuide {
        let roundedIntakeML = Int(max(0, currentIntakeML).rounded())
        let roundedGoalML = Int(max(0, dailyGoalML).rounded())
        let remainingML = max(0, roundedGoalML - roundedIntakeML)
        let nextRoutine = nextRoutine(
            from: routines,
            referenceDate: referenceDate,
            calendar: calendar
        )

        return HydrationNextActionGuide(
            state: state(
                dailyGoalML: roundedGoalML,
                remainingML: remainingML,
                nextRoutine: nextRoutine
            ),
            currentIntakeML: roundedIntakeML,
            dailyGoalML: roundedGoalML,
            remainingML: remainingML,
            remainingGlassCount: HydrationServing.remainingGlassCount(for: Double(remainingML)),
            nextRoutine: nextRoutine
        )
    }

    public static func nextRoutine(
        from routines: [HydrationRoutineSchedule],
        referenceDate: Date,
        calendar: Calendar
    ) -> HydrationNextRoutineContext? {
        let enabledRoutines = routines.filter { $0.isEnabled && !$0.weekdayRawValues.isEmpty }

        return (0...7)
            .compactMap { dayOffset -> (Date, HydrationNextRoutineContext)? in
                nextRoutineCandidate(
                    from: enabledRoutines,
                    dayOffset: dayOffset,
                    referenceDate: referenceDate,
                    calendar: calendar
                )
            }
            .min { lhs, rhs in lhs.0 < rhs.0 }?
            .1
    }

    private static func state(
        dailyGoalML: Int,
        remainingML: Int,
        nextRoutine: HydrationNextRoutineContext?
    ) -> HydrationNextActionGuideState {
        guard dailyGoalML > 0 else {
            return .needsGoal
        }

        guard remainingML > 0 else {
            return .goalReached
        }

        if let nextRoutine,
           nextRoutine.minutesUntil <= Constants.approachingRoutineMinutes {
            return .approachingRoutine
        }

        return .readyToDrink
    }

    private static func nextRoutineCandidate(
        from routines: [HydrationRoutineSchedule],
        dayOffset: Int,
        referenceDate: Date,
        calendar: Calendar
    ) -> (Date, HydrationNextRoutineContext)? {
        let startOfReferenceDay = calendar.startOfDay(for: referenceDate)
        guard let day = calendar.date(byAdding: .day, value: dayOffset, to: startOfReferenceDay) else {
            return nil
        }

        let weekday = calendar.component(.weekday, from: day)

        return routines
            .filter { $0.weekdayRawValues.contains(weekday) }
            .compactMap { routine -> (Date, HydrationNextRoutineContext)? in
                guard let targetDate = calendar.date(
                    bySettingHour: routine.hour,
                    minute: routine.minute,
                    second: 0,
                    of: day
                ) else {
                    return nil
                }

                let minutesUntil = Int((targetDate.timeIntervalSince(referenceDate) / 60).rounded(.up))
                guard minutesUntil >= 0 else {
                    return nil
                }

                return (
                    targetDate,
                    HydrationNextRoutineContext(
                        id: routine.id,
                        title: routine.title,
                        hour: routine.hour,
                        minute: routine.minute,
                        minutesUntil: minutesUntil
                    )
                )
            }
            .min { lhs, rhs in lhs.0 < rhs.0 }
    }
}
