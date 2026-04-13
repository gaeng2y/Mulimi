import Foundation

public enum HydrationRoutineAdherenceStatus: String, Equatable, Sendable {
    case inactive
    case noDueOccurrences
    case noRecords
    case needsAttention
    case onTrack
}

public struct HydrationRoutineAdherenceEvent: Equatable, Sendable {
    public let id: String
    public let consumedAt: Date

    public init(id: String, consumedAt: Date) {
        self.id = id
        self.consumedAt = consumedAt
    }
}

public struct HydrationRoutineAdherenceRoutineSummary: Identifiable, Equatable, Sendable {
    public let id: String
    public let title: String
    public let hour: Int
    public let minute: Int
    public let isEnabled: Bool
    public let scheduledCount: Int
    public let completedCount: Int
    public let missedCount: Int
    public let adherenceRate: Double
    public let status: HydrationRoutineAdherenceStatus

    public init(
        id: String,
        title: String,
        hour: Int,
        minute: Int,
        isEnabled: Bool,
        scheduledCount: Int,
        completedCount: Int,
        missedCount: Int,
        adherenceRate: Double,
        status: HydrationRoutineAdherenceStatus
    ) {
        self.id = id
        self.title = title
        self.hour = hour
        self.minute = minute
        self.isEnabled = isEnabled
        self.scheduledCount = scheduledCount
        self.completedCount = completedCount
        self.missedCount = missedCount
        self.adherenceRate = adherenceRate
        self.status = status
    }
}

public struct HydrationRoutineAdherenceTimeSlot: Identifiable, Equatable, Sendable {
    public var id: String {
        "\(hour)-\(minute)"
    }

    public let hour: Int
    public let minute: Int
    public let scheduledCount: Int
    public let completedCount: Int
    public let missedCount: Int
    public let adherenceRate: Double

    public init(
        hour: Int,
        minute: Int,
        scheduledCount: Int,
        completedCount: Int,
        missedCount: Int,
        adherenceRate: Double
    ) {
        self.hour = hour
        self.minute = minute
        self.scheduledCount = scheduledCount
        self.completedCount = completedCount
        self.missedCount = missedCount
        self.adherenceRate = adherenceRate
    }
}

public struct HydrationRoutineAdherenceInsight: Equatable, Sendable {
    private struct ScheduledOccurrence: Sendable {
        let routineID: String
        let scheduledAt: Date
        let hour: Int
        let minute: Int
    }

    private struct CandidateMatch: Sendable {
        let occurrenceIndex: Int
        let eventIndex: Int
        let distance: TimeInterval
    }

    private struct TimeSlotAccumulator {
        let hour: Int
        let minute: Int
        var scheduledCount: Int
        var completedCount: Int
    }

    private enum Constants {
        static let onTrackRateThreshold = 0.75
    }

    public static let defaultMatchingWindowMinutes = 60

    public let interval: DateInterval
    public let matchingWindowMinutes: Int
    public let routineSummaries: [HydrationRoutineAdherenceRoutineSummary]
    public let timeSlots: [HydrationRoutineAdherenceTimeSlot]
    public let scheduledCount: Int
    public let completedCount: Int
    public let missedCount: Int
    public let activeRoutineCount: Int
    public let inactiveRoutineCount: Int

    public var hasDueOccurrences: Bool {
        scheduledCount > 0
    }

    public var adherenceRate: Double {
        Self.rate(completedCount: completedCount, scheduledCount: scheduledCount)
    }

    public var bestRoutine: HydrationRoutineAdherenceRoutineSummary? {
        routineSummaries
            .filter { $0.isEnabled && $0.scheduledCount > 0 && $0.completedCount > 0 }
            .max { lhs, rhs in
                if lhs.adherenceRate != rhs.adherenceRate {
                    return lhs.adherenceRate < rhs.adherenceRate
                }

                return lhs.completedCount < rhs.completedCount
            }
    }

    public var weakestRoutine: HydrationRoutineAdherenceRoutineSummary? {
        routineSummaries
            .filter { $0.isEnabled && $0.scheduledCount > 0 && $0.missedCount > 0 }
            .max { lhs, rhs in
                if lhs.missedCount != rhs.missedCount {
                    return lhs.missedCount < rhs.missedCount
                }

                return lhs.adherenceRate > rhs.adherenceRate
            }
    }

    public var mostMissedTimeSlot: HydrationRoutineAdherenceTimeSlot? {
        timeSlots
            .filter { $0.missedCount > 0 }
            .max { lhs, rhs in
                if lhs.missedCount != rhs.missedCount {
                    return lhs.missedCount < rhs.missedCount
                }

                if lhs.adherenceRate != rhs.adherenceRate {
                    return lhs.adherenceRate > rhs.adherenceRate
                }

                return lhs.scheduledCount < rhs.scheduledCount
            }
    }

    public var bestTimeSlot: HydrationRoutineAdherenceTimeSlot? {
        timeSlots
            .filter { $0.scheduledCount > 0 && $0.completedCount > 0 }
            .max { lhs, rhs in
                if lhs.adherenceRate != rhs.adherenceRate {
                    return lhs.adherenceRate < rhs.adherenceRate
                }

                return lhs.completedCount < rhs.completedCount
            }
    }

    public init(
        interval: DateInterval,
        matchingWindowMinutes: Int,
        routineSummaries: [HydrationRoutineAdherenceRoutineSummary],
        timeSlots: [HydrationRoutineAdherenceTimeSlot],
        scheduledCount: Int,
        completedCount: Int,
        missedCount: Int,
        activeRoutineCount: Int,
        inactiveRoutineCount: Int
    ) {
        self.interval = interval
        self.matchingWindowMinutes = matchingWindowMinutes
        self.routineSummaries = routineSummaries
        self.timeSlots = timeSlots
        self.scheduledCount = scheduledCount
        self.completedCount = completedCount
        self.missedCount = missedCount
        self.activeRoutineCount = activeRoutineCount
        self.inactiveRoutineCount = inactiveRoutineCount
    }

    public static func make(
        routines: [HydrationRoutineSchedule],
        events: [HydrationRoutineAdherenceEvent],
        referenceDate: Date = .now,
        calendar: Calendar = .current,
        matchingWindowMinutes: Int = defaultMatchingWindowMinutes
    ) -> HydrationRoutineAdherenceInsight {
        let interval = analysisInterval(referenceDate: referenceDate, calendar: calendar)
        let occurrences = scheduledOccurrences(
            from: routines,
            in: interval,
            upTo: referenceDate,
            calendar: calendar
        )
        let sortedEvents = events
            .filter { $0.consumedAt >= interval.start && $0.consumedAt <= referenceDate }
            .sorted { lhs, rhs in lhs.consumedAt < rhs.consumedAt }
        let matchedOccurrenceIndices = matchedOccurrenceIndices(
            occurrences: occurrences,
            events: sortedEvents,
            matchingWindowMinutes: matchingWindowMinutes
        )
        let summaries = routineSummaries(
            for: routines,
            occurrences: occurrences,
            matchedOccurrenceIndices: matchedOccurrenceIndices
        )
        let scheduledCount = occurrences.count
        let completedCount = matchedOccurrenceIndices.count

        return HydrationRoutineAdherenceInsight(
            interval: interval,
            matchingWindowMinutes: max(matchingWindowMinutes, 0),
            routineSummaries: summaries,
            timeSlots: timeSlots(
                from: occurrences,
                matchedOccurrenceIndices: matchedOccurrenceIndices
            ),
            scheduledCount: scheduledCount,
            completedCount: completedCount,
            missedCount: max(0, scheduledCount - completedCount),
            activeRoutineCount: routines.filter(\.isEnabled).count,
            inactiveRoutineCount: routines.filter { !$0.isEnabled }.count
        )
    }

    private static func analysisInterval(
        referenceDate: Date,
        calendar: Calendar
    ) -> DateInterval {
        let start = calendar.dateInterval(of: .weekOfYear, for: referenceDate)?.start
            ?? calendar.startOfDay(for: referenceDate)
        let end = max(referenceDate, start.addingTimeInterval(1))
        return DateInterval(start: start, end: end)
    }

    private static func scheduledOccurrences(
        from routines: [HydrationRoutineSchedule],
        in interval: DateInterval,
        upTo referenceDate: Date,
        calendar: Calendar
    ) -> [ScheduledOccurrence] {
        let enabledRoutines = routines.filter { $0.isEnabled && !$0.weekdayRawValues.isEmpty }
        var occurrences: [ScheduledOccurrence] = []
        var currentDay = calendar.startOfDay(for: interval.start)
        let finalDay = calendar.startOfDay(for: referenceDate)

        while currentDay <= finalDay {
            appendOccurrences(
                to: &occurrences,
                from: enabledRoutines,
                on: currentDay,
                interval: interval,
                referenceDate: referenceDate,
                calendar: calendar
            )

            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDay) else {
                break
            }
            currentDay = nextDay
        }

        return occurrences.sorted { lhs, rhs in
            if lhs.scheduledAt == rhs.scheduledAt {
                return lhs.routineID < rhs.routineID
            }

            return lhs.scheduledAt < rhs.scheduledAt
        }
    }

    private static func appendOccurrences(
        to occurrences: inout [ScheduledOccurrence],
        from routines: [HydrationRoutineSchedule],
        on day: Date,
        interval: DateInterval,
        referenceDate: Date,
        calendar: Calendar
    ) {
        let weekday = calendar.component(.weekday, from: day)

        for routine in routines where routine.weekdayRawValues.contains(weekday) {
            guard let scheduledAt = calendar.date(
                bySettingHour: routine.hour,
                minute: routine.minute,
                second: 0,
                of: day
            ), scheduledAt >= interval.start, scheduledAt <= referenceDate else {
                continue
            }

            occurrences.append(
                ScheduledOccurrence(
                    routineID: routine.id,
                    scheduledAt: scheduledAt,
                    hour: routine.hour,
                    minute: routine.minute
                )
            )
        }
    }

    private static func matchedOccurrenceIndices(
        occurrences: [ScheduledOccurrence],
        events: [HydrationRoutineAdherenceEvent],
        matchingWindowMinutes: Int
    ) -> Set<Int> {
        let matchingWindow = TimeInterval(max(matchingWindowMinutes, 0) * 60)
        let candidates = occurrences.enumerated().flatMap { occurrenceIndex, occurrence in
            events.enumerated().compactMap { eventIndex, event -> CandidateMatch? in
                let distance = abs(event.consumedAt.timeIntervalSince(occurrence.scheduledAt))
                guard distance <= matchingWindow else {
                    return nil
                }

                return CandidateMatch(
                    occurrenceIndex: occurrenceIndex,
                    eventIndex: eventIndex,
                    distance: distance
                )
            }
        }
        .sorted { lhs, rhs in
            if lhs.distance != rhs.distance {
                return lhs.distance < rhs.distance
            }

            if occurrences[lhs.occurrenceIndex].scheduledAt != occurrences[rhs.occurrenceIndex].scheduledAt {
                return occurrences[lhs.occurrenceIndex].scheduledAt < occurrences[rhs.occurrenceIndex].scheduledAt
            }

            return lhs.eventIndex < rhs.eventIndex
        }

        var matchedOccurrences: Set<Int> = []
        var usedEvents: Set<Int> = []

        for candidate in candidates {
            guard !matchedOccurrences.contains(candidate.occurrenceIndex),
                  !usedEvents.contains(candidate.eventIndex) else {
                continue
            }

            matchedOccurrences.insert(candidate.occurrenceIndex)
            usedEvents.insert(candidate.eventIndex)
        }

        return matchedOccurrences
    }

    private static func routineSummaries(
        for routines: [HydrationRoutineSchedule],
        occurrences: [ScheduledOccurrence],
        matchedOccurrenceIndices: Set<Int>
    ) -> [HydrationRoutineAdherenceRoutineSummary] {
        routines.map { routine in
            let occurrenceIndices = occurrences.indices.filter {
                occurrences[$0].routineID == routine.id
            }
            let scheduledCount = occurrenceIndices.count
            let completedCount = occurrenceIndices.filter(matchedOccurrenceIndices.contains).count
            let missedCount = max(0, scheduledCount - completedCount)
            let adherenceRate = rate(
                completedCount: completedCount,
                scheduledCount: scheduledCount
            )

            return HydrationRoutineAdherenceRoutineSummary(
                id: routine.id,
                title: routine.title,
                hour: routine.hour,
                minute: routine.minute,
                isEnabled: routine.isEnabled,
                scheduledCount: scheduledCount,
                completedCount: completedCount,
                missedCount: missedCount,
                adherenceRate: adherenceRate,
                status: status(
                    isEnabled: routine.isEnabled,
                    scheduledCount: scheduledCount,
                    completedCount: completedCount,
                    adherenceRate: adherenceRate
                )
            )
        }
    }

    private static func status(
        isEnabled: Bool,
        scheduledCount: Int,
        completedCount: Int,
        adherenceRate: Double
    ) -> HydrationRoutineAdherenceStatus {
        guard isEnabled else {
            return .inactive
        }

        guard scheduledCount > 0 else {
            return .noDueOccurrences
        }

        guard completedCount > 0 else {
            return .noRecords
        }

        return adherenceRate >= Constants.onTrackRateThreshold ? .onTrack : .needsAttention
    }

    private static func timeSlots(
        from occurrences: [ScheduledOccurrence],
        matchedOccurrenceIndices: Set<Int>
    ) -> [HydrationRoutineAdherenceTimeSlot] {
        var accumulators: [String: TimeSlotAccumulator] = [:]

        for index in occurrences.indices {
            let occurrence = occurrences[index]
            let key = "\(occurrence.hour)-\(occurrence.minute)"
            var accumulator = accumulators[key] ?? TimeSlotAccumulator(
                hour: occurrence.hour,
                minute: occurrence.minute,
                scheduledCount: 0,
                completedCount: 0
            )
            accumulator.scheduledCount += 1
            if matchedOccurrenceIndices.contains(index) {
                accumulator.completedCount += 1
            }
            accumulators[key] = accumulator
        }

        return accumulators.values
            .map { accumulator in
                let missedCount = max(0, accumulator.scheduledCount - accumulator.completedCount)

                return HydrationRoutineAdherenceTimeSlot(
                    hour: accumulator.hour,
                    minute: accumulator.minute,
                    scheduledCount: accumulator.scheduledCount,
                    completedCount: accumulator.completedCount,
                    missedCount: missedCount,
                    adherenceRate: rate(
                        completedCount: accumulator.completedCount,
                        scheduledCount: accumulator.scheduledCount
                    )
                )
            }
            .sorted { lhs, rhs in
                if lhs.hour == rhs.hour {
                    return lhs.minute < rhs.minute
                }

                return lhs.hour < rhs.hour
            }
    }

    private static func rate(completedCount: Int, scheduledCount: Int) -> Double {
        guard scheduledCount > 0 else {
            return 0
        }

        return Double(completedCount) / Double(scheduledCount)
    }
}
