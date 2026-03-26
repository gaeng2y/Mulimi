import DomainLayerInterface
import Foundation

public struct ChallengeUseCaseImpl: ChallengeUseCase {
    private struct ChallengeEvaluation {
        let challenge: HydrationChallenge
        let cycleID: String?
    }

    private struct ChallengeMergeResult {
        let challenge: HydrationChallenge
        let cycleID: String?
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
        let persistedHistories = challengeRepository.fetchBadgeHistories()
        let persistedHistoriesByID = Dictionary(
            uniqueKeysWithValues: persistedHistories.map { ($0.id, $0) }
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
                persistedHistory: persistedHistory(
                    for: evaluation,
                    persistedHistoriesByID: persistedHistoriesByID
                ),
                referenceDate: referenceDate
            )
        }

        let mergedHistories = mergeBadgeHistories(
            persistedHistories: persistedHistories,
            results: results
        )

        if mergedHistories != persistedHistories {
            challengeRepository.saveBadgeHistories(mergedHistories)
        }

        return results.map(\.challenge)
    }

    public func fetchBadgeHistories() async -> [HydrationChallengeBadgeHistory] {
        challengeRepository.fetchBadgeHistories()
    }

    private func mergeChallenge(
        evaluation: ChallengeEvaluation,
        persistedHistory: HydrationChallengeBadgeHistory?,
        referenceDate: Date
    ) -> ChallengeMergeResult {
        switch evaluation.challenge.kind.stateType {
        case .recurring:
            return mergeRecurringChallenge(
                evaluation: evaluation,
                persistedHistory: persistedHistory,
                referenceDate: referenceDate
            )
        case .cumulative:
            return mergeCumulativeChallenge(
                challenge: evaluation.challenge,
                persistedHistory: persistedHistory,
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
        persistedHistory: HydrationChallengeBadgeHistory?,
        referenceDate: Date
    ) -> ChallengeMergeResult {
        let challenge = evaluation.challenge
        let completedInCurrentCycle = challenge.progress >= 1
        let isCompleted = persistedHistory != nil || completedInCurrentCycle
        let achievedAt = persistedHistory?.achievedAt ?? (completedInCurrentCycle ? referenceDate : nil)

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

        return ChallengeMergeResult(
            challenge: mergedChallenge,
            cycleID: evaluation.cycleID
        )
    }

    private func mergeCumulativeChallenge(
        challenge: HydrationChallenge,
        persistedHistory: HydrationChallengeBadgeHistory?,
        referenceDate: Date
    ) -> ChallengeMergeResult {
        let achievedAt = persistedHistory?.achievedAt ?? (challenge.progress >= 1 ? referenceDate : nil)
        let isCompleted = persistedHistory != nil || challenge.progress >= 1
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

        return ChallengeMergeResult(challenge: mergedChallenge, cycleID: nil)
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

    private func mergeBadgeHistories(
        persistedHistories: [HydrationChallengeBadgeHistory],
        results: [ChallengeMergeResult]
    ) -> [HydrationChallengeBadgeHistory] {
        var mergedHistories = persistedHistories
        var knownIDs = Set(persistedHistories.map(\.id))

        for history in results.compactMap(makeBadgeHistory(from:)) {
            guard knownIDs.insert(history.id).inserted else {
                continue
            }

            mergedHistories.append(history)
        }

        return mergedHistories.sorted(by: badgeHistorySort)
    }

    private func makeBadgeHistory(from result: ChallengeMergeResult) -> HydrationChallengeBadgeHistory? {
        guard result.challenge.isCompleted, let achievedAt = result.challenge.achievedAt else {
            return nil
        }

        return HydrationChallengeBadgeHistory(
            kind: result.challenge.kind,
            achievedAt: achievedAt,
            cycleID: result.cycleID
        )
    }

    private func persistedHistory(
        for evaluation: ChallengeEvaluation,
        persistedHistoriesByID: [String: HydrationChallengeBadgeHistory]
    ) -> HydrationChallengeBadgeHistory? {
        let historyID = HydrationChallengeBadgeHistory.makeID(
            kind: evaluation.challenge.kind,
            cycleID: evaluation.cycleID
        )

        return persistedHistoriesByID[historyID]
    }

    private func badgeHistorySort(
        lhs: HydrationChallengeBadgeHistory,
        rhs: HydrationChallengeBadgeHistory
    ) -> Bool {
        if lhs.achievedAt != rhs.achievedAt {
            return lhs.achievedAt > rhs.achievedAt
        }

        return lhs.id < rhs.id
    }
}
