import DomainLayerInterface
import Foundation

public struct RoutineRecommendationUseCaseImpl: RoutineRecommendationUseCase {
    private struct DaySummary {
        let date: Date
        let events: [HydrationEvent]
    }

    private enum Constants {
        static let analysisDays = 14
        static let minimumEventDays = 5
        static let morningCutoffHour = 12
        static let morningRecommendedHour = 9
        static let afternoonRecommendedHour = 15
        static let frequentBucketMinutes = 30
        static let minimumFrequentDayCount = 3
        static let minimumAfternoonGapDays = 3
        static let recommendationProximityMinutes = 60
        static let problemDayRateThreshold = 0.5
        static let defaultWeekdays: [RoutineWeekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    }

    private let routineUseCase: RoutineUseCase
    private let drinkWaterRepository: DrinkWaterRepository

    public init(
        routineUseCase: RoutineUseCase,
        drinkWaterRepository: DrinkWaterRepository
    ) {
        self.routineUseCase = routineUseCase
        self.drinkWaterRepository = drinkWaterRepository
    }

    public func fetchRecommendations(
        referenceDate: Date,
        calendar: Calendar
    ) async -> [HydrationRoutineRecommendation] {
        let enabledRoutines = routineUseCase.fetchRoutines().filter(\.isEnabled)
        let interval = analysisInterval(referenceDate: referenceDate, calendar: calendar)
        let events = await drinkWaterRepository.hydrationEvents(in: interval)
            .sorted { $0.consumedAt < $1.consumedAt }

        let daySummaries = makeDaySummaries(events: events, calendar: calendar)
        guard !daySummaries.isEmpty else {
            return []
        }

        let fallbackWeekdays = fallbackWeekdays(
            existingRoutines: enabledRoutines,
            daySummaries: daySummaries,
            calendar: calendar
        )

        var recommendations: [HydrationRoutineRecommendation] = []

        if let frequentRecommendation = frequentHydrationRecommendation(
            from: daySummaries,
            existingRoutines: enabledRoutines,
            fallbackWeekdays: fallbackWeekdays,
            calendar: calendar
        ) {
            recommendations.append(frequentRecommendation)
        }

        if let morningRecommendation = morningStartRecommendation(
            from: daySummaries,
            fallbackWeekdays: fallbackWeekdays,
            calendar: calendar
        ), isDistinct(
            morningRecommendation,
            existingRoutines: enabledRoutines,
            currentRecommendations: recommendations
        ) {
            recommendations.append(morningRecommendation)
        }

        if let afternoonRecommendation = afternoonGapRecommendation(
            from: daySummaries,
            fallbackWeekdays: fallbackWeekdays,
            calendar: calendar
        ), isDistinct(
            afternoonRecommendation,
            existingRoutines: enabledRoutines,
            currentRecommendations: recommendations
        ) {
            recommendations.append(afternoonRecommendation)
        }

        return recommendations
    }

    private func analysisInterval(
        referenceDate: Date,
        calendar: Calendar
    ) -> DateInterval {
        let startOfReferenceDay = calendar.startOfDay(for: referenceDate)
        let start = calendar.date(
            byAdding: .day,
            value: -(Constants.analysisDays - 1),
            to: startOfReferenceDay
        ) ?? startOfReferenceDay
        let end = calendar.date(byAdding: .day, value: 1, to: startOfReferenceDay) ?? referenceDate
        return DateInterval(start: start, end: end)
    }

    private func makeDaySummaries(
        events: [HydrationEvent],
        calendar: Calendar
    ) -> [DaySummary] {
        let grouped = Dictionary(grouping: events) {
            calendar.startOfDay(for: $0.consumedAt)
        }

        return grouped.keys.sorted().compactMap { day in
            guard let dayEvents = grouped[day]?.sorted(by: { $0.consumedAt < $1.consumedAt }),
                  !dayEvents.isEmpty else {
                return nil
            }

            return DaySummary(date: day, events: dayEvents)
        }
    }

    private func frequentHydrationRecommendation(
        from daySummaries: [DaySummary],
        existingRoutines: [HydrationRoutine],
        fallbackWeekdays: [RoutineWeekday],
        calendar: Calendar
    ) -> HydrationRoutineRecommendation? {
        var datesByBucket: [Int: Set<Date>] = [:]

        for daySummary in daySummaries {
            let bucketMinutes = Set(
                daySummary.events.map { event in
                    roundedBucket(minuteOfDay(for: event.consumedAt, calendar: calendar))
                }
            )

            for bucketMinute in bucketMinutes {
                datesByBucket[bucketMinute, default: []].insert(daySummary.date)
            }
        }

        let sortedBuckets = datesByBucket.sorted { lhs, rhs in
            if lhs.value.count != rhs.value.count {
                return lhs.value.count > rhs.value.count
            }

            return lhs.key < rhs.key
        }

        for (bucketMinute, dates) in sortedBuckets {
            guard dates.count >= Constants.minimumFrequentDayCount else {
                break
            }

            let weekdays = preferredWeekdays(
                from: Array(dates),
                calendar: calendar,
                minimumCount: 1
            )
            let recommendation = HydrationRoutineRecommendation(
                kind: .frequentHydrationWindow,
                hour: bucketMinute / 60,
                minute: bucketMinute % 60,
                weekdays: weekdays.isEmpty ? fallbackWeekdays : weekdays
            )

            if !overlapsExistingRoutine(recommendation, routines: existingRoutines) {
                return recommendation
            }
        }

        return nil
    }

    private func morningStartRecommendation(
        from daySummaries: [DaySummary],
        fallbackWeekdays: [RoutineWeekday],
        calendar: Calendar
    ) -> HydrationRoutineRecommendation? {
        guard daySummaries.count >= Constants.minimumEventDays else {
            return nil
        }

        let lateMorningDates = daySummaries.compactMap { summary -> Date? in
            guard let firstEvent = summary.events.first else {
                return nil
            }

            let firstHour = calendar.component(.hour, from: firstEvent.consumedAt)
            return firstHour >= Constants.morningCutoffHour ? summary.date : nil
        }

        guard problemDayRate(problemDays: lateMorningDates.count, totalDays: daySummaries.count) >= Constants.problemDayRateThreshold else {
            return nil
        }

        let weekdays = preferredWeekdays(
            from: lateMorningDates,
            calendar: calendar,
            minimumCount: 2
        )

        return HydrationRoutineRecommendation(
            kind: .morningStart,
            hour: Constants.morningRecommendedHour,
            minute: 0,
            weekdays: weekdays.isEmpty ? fallbackWeekdays : weekdays
        )
    }

    private func afternoonGapRecommendation(
        from daySummaries: [DaySummary],
        fallbackWeekdays: [RoutineWeekday],
        calendar: Calendar
    ) -> HydrationRoutineRecommendation? {
        let gapDates = daySummaries.compactMap { summary -> Date? in
            let eventMinutes = summary.events.map { minuteOfDay(for: $0.consumedAt, calendar: calendar) }
            let hasPreAfternoon = eventMinutes.contains { $0 < 13 * 60 }
            let hasEvening = eventMinutes.contains { $0 >= 17 * 60 }
            let hasAfternoon = eventMinutes.contains { $0 >= 13 * 60 && $0 < 17 * 60 }

            guard hasPreAfternoon, hasEvening, !hasAfternoon else {
                return nil
            }

            return summary.date
        }

        guard gapDates.count >= Constants.minimumAfternoonGapDays else {
            return nil
        }

        let weekdays = preferredWeekdays(
            from: gapDates,
            calendar: calendar,
            minimumCount: 2
        )

        return HydrationRoutineRecommendation(
            kind: .afternoonGap,
            hour: Constants.afternoonRecommendedHour,
            minute: 0,
            weekdays: weekdays.isEmpty ? fallbackWeekdays : weekdays
        )
    }

    private func fallbackWeekdays(
        existingRoutines: [HydrationRoutine],
        daySummaries: [DaySummary],
        calendar: Calendar
    ) -> [RoutineWeekday] {
        let existingWeekdays = RoutineWeekday.displayOrder.filter { weekday in
            existingRoutines.contains { $0.weekdays.contains(weekday) }
        }

        if !existingWeekdays.isEmpty {
            return existingWeekdays
        }

        let eventWeekdays = preferredWeekdays(
            from: daySummaries.map(\.date),
            calendar: calendar,
            minimumCount: 1
        )

        return eventWeekdays.isEmpty ? Constants.defaultWeekdays : eventWeekdays
    }

    private func preferredWeekdays(
        from dates: [Date],
        calendar: Calendar,
        minimumCount: Int
    ) -> [RoutineWeekday] {
        let counts = dates.reduce(into: [RoutineWeekday: Int]()) { partialResult, date in
            guard let weekday = RoutineWeekday(rawValue: calendar.component(.weekday, from: date)) else {
                return
            }

            partialResult[weekday, default: 0] += 1
        }

        let preferred = RoutineWeekday.displayOrder.filter {
            counts[$0, default: 0] >= minimumCount
        }

        if !preferred.isEmpty {
            return preferred
        }

        return RoutineWeekday.displayOrder.filter {
            counts[$0, default: 0] > 0
        }
    }

    private func isDistinct(
        _ recommendation: HydrationRoutineRecommendation,
        existingRoutines: [HydrationRoutine],
        currentRecommendations: [HydrationRoutineRecommendation]
    ) -> Bool {
        if overlapsExistingRoutine(recommendation, routines: existingRoutines) {
            return false
        }

        return !currentRecommendations.contains { existing in
            overlaps(recommendation, with: existing)
        }
    }

    private func overlapsExistingRoutine(
        _ recommendation: HydrationRoutineRecommendation,
        routines: [HydrationRoutine]
    ) -> Bool {
        routines.contains { routine in
            let weekdayOverlap = !Set(routine.weekdays).isDisjoint(with: recommendation.weekdays)
            let minuteDifference = abs(
                minuteOfDay(hour: routine.hour, minute: routine.minute) -
                minuteOfDay(hour: recommendation.hour, minute: recommendation.minute)
            )

            return weekdayOverlap && minuteDifference <= Constants.recommendationProximityMinutes
        }
    }

    private func overlaps(
        _ lhs: HydrationRoutineRecommendation,
        with rhs: HydrationRoutineRecommendation
    ) -> Bool {
        let weekdayOverlap = !Set(lhs.weekdays).isDisjoint(with: rhs.weekdays)
        let minuteDifference = abs(
            minuteOfDay(hour: lhs.hour, minute: lhs.minute) -
            minuteOfDay(hour: rhs.hour, minute: rhs.minute)
        )

        return weekdayOverlap && minuteDifference <= Constants.recommendationProximityMinutes
    }

    private func problemDayRate(problemDays: Int, totalDays: Int) -> Double {
        guard totalDays > 0 else {
            return 0
        }

        return Double(problemDays) / Double(totalDays)
    }

    private func roundedBucket(_ minuteOfDay: Int) -> Int {
        let rounded = ((minuteOfDay + (Constants.frequentBucketMinutes / 2)) / Constants.frequentBucketMinutes)
            * Constants.frequentBucketMinutes
        return min(rounded, (23 * 60) + 30)
    }

    private func minuteOfDay(
        for date: Date,
        calendar: Calendar
    ) -> Int {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        return minuteOfDay(hour: components.hour ?? 0, minute: components.minute ?? 0)
    }

    private func minuteOfDay(hour: Int, minute: Int) -> Int {
        hour * 60 + minute
    }
}
