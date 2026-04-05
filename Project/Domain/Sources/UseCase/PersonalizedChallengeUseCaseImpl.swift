import DomainLayerInterface
import Foundation

public struct PersonalizedChallengeUseCaseImpl: PersonalizedChallengeUseCase {
    private enum Constants {
        static let morningWindowDays = 14
        static let morningCutoffHour = 12
        static let morningTargetDays = 5
        static let weeklyConsistencyTargetDays = 5
        static let intakeStepML = Int(HydrationServing.defaultGlassML)
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

    public func fetchPersonalizedChallenges(
        snapshot: HydrationProgressSnapshot,
        referenceDate: Date,
        calendar: Calendar
    ) async -> [PersonalizedHydrationChallenge] {
        guard snapshot.isEmpty == false else {
            return []
        }

        var challenges: [PersonalizedHydrationChallenge] = []

        if let anchorRoutine = selectAnchorRoutine(from: routineUseCase.fetchRoutines()) {
            challenges.append(
                makeRoutineAnchorChallenge(
                    routine: anchorRoutine,
                    snapshot: snapshot
                )
            )
        }

        if let recordBasedChallenge = await makeRecordBasedChallenge(
            snapshot: snapshot,
            referenceDate: referenceDate,
            calendar: calendar
        ) {
            challenges.append(recordBasedChallenge)
        }

        return challenges
    }

    private func selectAnchorRoutine(from routines: [HydrationRoutine]) -> HydrationRoutine? {
        routines
            .filter(\.isEnabled)
            .sorted { lhs, rhs in
                if lhs.weekdays.count != rhs.weekdays.count {
                    return lhs.weekdays.count > rhs.weekdays.count
                }
                if lhs.hour != rhs.hour {
                    return lhs.hour < rhs.hour
                }
                return lhs.minute < rhs.minute
            }
            .first
    }

    private func makeRoutineAnchorChallenge(
        routine: HydrationRoutine,
        snapshot: HydrationProgressSnapshot
    ) -> PersonalizedHydrationChallenge {
        PersonalizedHydrationChallenge(
            kind: .routineAnchor,
            tier: tierForRoutine(snapshot: snapshot),
            source: .routine,
            primaryCurrentValue: routine.weekdays.count,
            primaryTargetValue: max(routine.weekdays.count, 3),
            anchorRoutine: routine
        )
    }

    private func makeRecordBasedChallenge(
        snapshot: HydrationProgressSnapshot,
        referenceDate: Date,
        calendar: Calendar
    ) async -> PersonalizedHydrationChallenge? {
        let morningHydrationDays = await recentMorningHydrationDays(
            referenceDate: referenceDate,
            calendar: calendar
        )

        if morningHydrationDays < Constants.morningTargetDays {
            return PersonalizedHydrationChallenge(
                kind: .morningKickstart,
                tier: tierForMorningKickstart(
                    matchedDays: morningHydrationDays,
                    totalDays: Constants.morningWindowDays
                ),
                source: .recentRecords,
                primaryCurrentValue: morningHydrationDays,
                primaryTargetValue: Constants.morningTargetDays,
                secondaryCurrentValue: Constants.morningWindowDays
            )
        }

        let dailyGoalML = Int(snapshot.dailyGoalML.rounded())
        let monthlyAverageML = Int(snapshot.monthlyAverageML.rounded())

        if dailyGoalML > 0, monthlyAverageML < dailyGoalML {
            let stepAlignedTarget = nextStepTarget(
                currentValue: monthlyAverageML,
                step: Constants.intakeStepML
            )
            let recommendedTargetML = min(
                dailyGoalML,
                stepAlignedTarget
            )

            return PersonalizedHydrationChallenge(
                kind: .dailyGoalBooster,
                tier: tierForDailyGoalBooster(
                    averageML: monthlyAverageML,
                    dailyGoalML: dailyGoalML
                ),
                source: .recentRecords,
                primaryCurrentValue: monthlyAverageML,
                primaryTargetValue: recommendedTargetML,
                currentAverageML: monthlyAverageML,
                recommendedTargetML: recommendedTargetML,
                dailyGoalML: dailyGoalML
            )
        }

        return PersonalizedHydrationChallenge(
            kind: .consistencyDefender,
            tier: .stretch,
            source: .recentRecords,
            primaryCurrentValue: snapshot.weeklyAchievedDays,
            primaryTargetValue: min(
                max(Constants.weeklyConsistencyTargetDays, snapshot.weeklyAchievedDays + 1),
                7
            ),
            secondaryCurrentValue: snapshot.weeklyElapsedDays,
            secondaryTargetValue: 7
        )
    }

    private func recentMorningHydrationDays(
        referenceDate: Date,
        calendar: Calendar
    ) async -> Int {
        let startOfReferenceDay = calendar.startOfDay(for: referenceDate)
        let intervalStart = calendar.date(
            byAdding: .day,
            value: -(Constants.morningWindowDays - 1),
            to: startOfReferenceDay
        ) ?? startOfReferenceDay
        let intervalEnd = calendar.date(byAdding: .day, value: 1, to: startOfReferenceDay) ?? referenceDate
        let events = await drinkWaterRepository.hydrationEvents(
            in: DateInterval(start: intervalStart, end: intervalEnd)
        )

        let firstEventsByDay = events.reduce(into: [Date: Date]()) { partialResult, event in
            let day = calendar.startOfDay(for: event.consumedAt)
            let current = partialResult[day]
            if current == nil || event.consumedAt < current! {
                partialResult[day] = event.consumedAt
            }
        }

        return firstEventsByDay.values.reduce(into: 0) { result, firstEvent in
            let hour = calendar.component(.hour, from: firstEvent)
            if hour < Constants.morningCutoffHour {
                result += 1
            }
        }
    }

    private func tierForRoutine(snapshot: HydrationProgressSnapshot) -> HydrationChallengeTier {
        switch snapshot.weeklyAchievementRate {
        case ..<0.4:
            return .beginner
        case ..<0.8:
            return .steady
        default:
            return .stretch
        }
    }

    private func tierForMorningKickstart(matchedDays: Int, totalDays: Int) -> HydrationChallengeTier {
        let rate = totalDays > 0 ? Double(matchedDays) / Double(totalDays) : 0
        switch rate {
        case ..<0.3:
            return .beginner
        case ..<0.6:
            return .steady
        default:
            return .stretch
        }
    }

    private func tierForDailyGoalBooster(averageML: Int, dailyGoalML: Int) -> HydrationChallengeTier {
        guard dailyGoalML > 0 else {
            return .beginner
        }

        let rate = Double(averageML) / Double(dailyGoalML)
        switch rate {
        case ..<0.55:
            return .beginner
        case ..<0.85:
            return .steady
        default:
            return .stretch
        }
    }

    private func roundedUp(_ value: Int, step: Int) -> Int {
        guard step > 0 else {
            return value
        }

        return ((value + step - 1) / step) * step
    }

    private func nextStepTarget(currentValue: Int, step: Int) -> Int {
        let roundedValue = roundedUp(currentValue, step: step)
        if roundedValue == currentValue {
            return roundedValue + step
        }
        return roundedValue
    }
}
