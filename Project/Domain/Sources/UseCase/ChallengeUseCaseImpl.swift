import DomainLayerInterface
import Foundation

public struct ChallengeUseCaseImpl: ChallengeUseCase {
    private struct ChallengeEvaluation {
        let challenge: HydrationChallenge
        let cycleID: String?
    }

    private struct ChallengeMergeResult {
        let challenge: HydrationChallenge
        let state: HydrationChallengeState
    }

    private let progressUseCase: HydrationProgressUseCase
    private let challengeRepository: ChallengeRepository
    private let drinkWaterRepository: DrinkWaterRepository

    public init(
        progressUseCase: HydrationProgressUseCase,
        challengeRepository: ChallengeRepository,
        drinkWaterRepository: DrinkWaterRepository
    ) {
        self.progressUseCase = progressUseCase
        self.challengeRepository = challengeRepository
        self.drinkWaterRepository = drinkWaterRepository
    }

    public func fetchChallenges(referenceDate: Date, calendar: Calendar) async -> [HydrationChallenge] {
        let snapshot = await progressUseCase.progressSnapshot(
            referenceDate: referenceDate,
            calendar: calendar
        )
        let persistedStatesByKind = Dictionary(
            uniqueKeysWithValues: challengeRepository.fetchChallengeStates().map { ($0.kind, $0) }
        )
        let totalAchievedDays = await totalAchievedDayCount(
            upTo: referenceDate,
            calendar: calendar,
            dailyGoalML: snapshot.dailyGoalML
        )

        let results = [
            makeStreakChallenge(from: snapshot, referenceDate: referenceDate, calendar: calendar),
            makeWeeklyAchievementChallenge(from: snapshot, referenceDate: referenceDate, calendar: calendar),
            makeGoalAchievementChallenge(totalAchievedDays: totalAchievedDays)
        ].map { evaluation in
            mergeChallenge(
                evaluation: evaluation,
                persistedState: persistedStatesByKind[evaluation.challenge.kind],
                referenceDate: referenceDate
            )
        }

        challengeRepository.saveChallengeStates(results.map(\.state))

        return results.map(\.challenge)
    }

    private func mergeChallenge(
        evaluation: ChallengeEvaluation,
        persistedState: HydrationChallengeState?,
        referenceDate: Date
    ) -> ChallengeMergeResult {
        switch evaluation.challenge.kind.stateType {
        case .recurring:
            return mergeRecurringChallenge(
                evaluation: evaluation,
                persistedState: persistedState?.recurringState,
                referenceDate: referenceDate
            )
        case .cumulative:
            return mergeCumulativeChallenge(
                challenge: evaluation.challenge,
                persistedState: persistedState?.cumulativeState,
                referenceDate: referenceDate
            )
        }
    }

    private func makeStreakChallenge(
        from snapshot: HydrationProgressSnapshot,
        referenceDate: Date,
        calendar: Calendar
    ) -> ChallengeEvaluation {
        let target = 7
        return ChallengeEvaluation(
            challenge: HydrationChallenge(
                kind: .streak7,
                progress: progress(current: Double(snapshot.currentStreak), target: Double(target)),
                currentValue: Double(snapshot.currentStreak),
                targetValue: Double(target),
                primaryCurrentValue: snapshot.currentStreak,
                primaryTargetValue: target,
                isCompleted: false,
                achievedAt: nil
            ),
            cycleID: HydrationChallengeKind.streak7.recurringCycleID(
                referenceDate: referenceDate,
                calendar: calendar,
                streakStartDate: snapshot.currentStreakStartDate
            )
        )
    }

    private func makeWeeklyAchievementChallenge(
        from snapshot: HydrationProgressSnapshot,
        referenceDate: Date,
        calendar: Calendar
    ) -> ChallengeEvaluation {
        let targetRate = 0.8
        return ChallengeEvaluation(
            challenge: HydrationChallenge(
                kind: .weeklyAchievement80,
                progress: progress(current: snapshot.weeklyAchievementRate, target: targetRate),
                currentValue: snapshot.weeklyAchievementRate,
                targetValue: targetRate,
                primaryCurrentValue: Int((snapshot.weeklyAchievementRate * 100).rounded()),
                primaryTargetValue: 80,
                secondaryCurrentValue: snapshot.weeklyAchievedDays,
                secondaryTargetValue: max(snapshot.weeklyElapsedDays, 1),
                isCompleted: false,
                achievedAt: nil
            ),
            cycleID: HydrationChallengeKind.weeklyAchievement80.recurringCycleID(
                referenceDate: referenceDate,
                calendar: calendar
            )
        )
    }

    private func makeGoalAchievementChallenge(totalAchievedDays: Int) -> ChallengeEvaluation {
        let target = 30
        return ChallengeEvaluation(
            challenge: HydrationChallenge(
                kind: .goalAchievement30,
                progress: progress(current: Double(totalAchievedDays), target: Double(target)),
                currentValue: Double(totalAchievedDays),
                targetValue: Double(target),
                primaryCurrentValue: totalAchievedDays,
                primaryTargetValue: target,
                isCompleted: false,
                achievedAt: nil
            ),
            cycleID: nil
        )
    }

    private func mergeRecurringChallenge(
        evaluation: ChallengeEvaluation,
        persistedState: HydrationRecurringChallengeState?,
        referenceDate: Date
    ) -> ChallengeMergeResult {
        let challenge = evaluation.challenge
        let isSameCycle = evaluation.cycleID != nil && persistedState?.cycleID == evaluation.cycleID
        let completedInCurrentCycle = challenge.progress >= 1
        let isCompleted = (isSameCycle && persistedState?.isCompleted == true) || completedInCurrentCycle
        let achievedAt = isSameCycle
            ? persistedState?.achievedAt ?? (completedInCurrentCycle ? referenceDate : nil)
            : (completedInCurrentCycle ? referenceDate : nil)

        let mergedChallenge = HydrationChallenge(
            kind: challenge.kind,
            progress: isCompleted ? 1 : challenge.progress,
            currentValue: challenge.currentValue,
            targetValue: challenge.targetValue,
            primaryCurrentValue: challenge.primaryCurrentValue,
            primaryTargetValue: challenge.primaryTargetValue,
            secondaryCurrentValue: challenge.secondaryCurrentValue,
            secondaryTargetValue: challenge.secondaryTargetValue,
            isCompleted: isCompleted,
            achievedAt: achievedAt
        )
        let state = HydrationChallengeState.recurring(
            HydrationRecurringChallengeState(
                kind: challenge.kind,
                cycleID: evaluation.cycleID,
                progress: mergedChallenge.progress,
                isCompleted: isCompleted,
                achievedAt: achievedAt,
                updatedAt: referenceDate
            )
        )

        return ChallengeMergeResult(challenge: mergedChallenge, state: state)
    }

    private func mergeCumulativeChallenge(
        challenge: HydrationChallenge,
        persistedState: HydrationCumulativeChallengeState?,
        referenceDate: Date
    ) -> ChallengeMergeResult {
        let achievedAt = persistedState?.achievedAt ?? (challenge.progress >= 1 ? referenceDate : nil)
        let isCompleted = persistedState?.isCompleted == true || challenge.progress >= 1
        let mergedChallenge = HydrationChallenge(
            kind: challenge.kind,
            progress: isCompleted ? 1 : challenge.progress,
            currentValue: challenge.currentValue,
            targetValue: challenge.targetValue,
            primaryCurrentValue: challenge.primaryCurrentValue,
            primaryTargetValue: challenge.primaryTargetValue,
            secondaryCurrentValue: challenge.secondaryCurrentValue,
            secondaryTargetValue: challenge.secondaryTargetValue,
            isCompleted: isCompleted,
            achievedAt: achievedAt
        )
        let state = HydrationChallengeState.cumulative(
            HydrationCumulativeChallengeState(
                kind: challenge.kind,
                progress: mergedChallenge.progress,
                isCompleted: isCompleted,
                achievedAt: achievedAt,
                updatedAt: referenceDate
            )
        )

        return ChallengeMergeResult(challenge: mergedChallenge, state: state)
    }

    private func progress(current: Double, target: Double) -> Double {
        guard target > 0 else {
            return 0
        }

        return min(max(current / target, 0), 1)
    }

    private func totalAchievedDayCount(
        upTo referenceDate: Date,
        calendar: Calendar,
        dailyGoalML: Double
    ) async -> Int {
        guard dailyGoalML > 0 else {
            return 0
        }

        let intervalEnd = calendar.date(
            byAdding: .day,
            value: 1,
            to: calendar.startOfDay(for: referenceDate)
        ) ?? referenceDate

        let events = await drinkWaterRepository.hydrationEvents(
            in: DateInterval(start: .distantPast, end: intervalEnd)
        )
        let totals = events.reduce(into: [Date: Double]()) { partialResult, event in
            let day = calendar.startOfDay(for: event.consumedAt)
            partialResult[day, default: 0] += Double(event.volumeML)
        }

        return totals.values.filter { $0 >= dailyGoalML }.count
    }
}
