import DomainLayerInterface
import Foundation

public struct ChallengeUseCaseImpl: ChallengeUseCase {
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

        let challenges = [
            makeStreakChallenge(from: snapshot),
            makeWeeklyAchievementChallenge(from: snapshot),
            makeGoalAchievementChallenge(totalAchievedDays: totalAchievedDays)
        ].map { challenge in
            mergedChallenge(
                challenge,
                persistedState: persistedStatesByKind[challenge.kind],
                referenceDate: referenceDate
            )
        }

        challengeRepository.saveChallengeStates(
            challenges.map {
                HydrationChallengeState(
                    kind: $0.kind,
                    progress: $0.progress,
                    isCompleted: $0.isCompleted,
                    achievedAt: $0.achievedAt,
                    updatedAt: referenceDate
                )
            }
        )

        return challenges
    }

    private func mergedChallenge(
        _ challenge: HydrationChallenge,
        persistedState: HydrationChallengeState?,
        referenceDate: Date
    ) -> HydrationChallenge {
        let completedAt = persistedState?.achievedAt ?? (challenge.progress >= 1 ? referenceDate : nil)
        let isCompleted = persistedState?.isCompleted == true || challenge.progress >= 1

        return HydrationChallenge(
            kind: challenge.kind,
            progress: isCompleted ? 1 : challenge.progress,
            currentValue: challenge.currentValue,
            targetValue: challenge.targetValue,
            primaryCurrentValue: challenge.primaryCurrentValue,
            primaryTargetValue: challenge.primaryTargetValue,
            secondaryCurrentValue: challenge.secondaryCurrentValue,
            secondaryTargetValue: challenge.secondaryTargetValue,
            isCompleted: isCompleted,
            achievedAt: completedAt
        )
    }

    private func makeStreakChallenge(from snapshot: HydrationProgressSnapshot) -> HydrationChallenge {
        let target = 7
        return HydrationChallenge(
            kind: .streak7,
            progress: progress(current: Double(snapshot.currentStreak), target: Double(target)),
            currentValue: Double(snapshot.currentStreak),
            targetValue: Double(target),
            primaryCurrentValue: snapshot.currentStreak,
            primaryTargetValue: target,
            isCompleted: false,
            achievedAt: nil
        )
    }

    private func makeWeeklyAchievementChallenge(from snapshot: HydrationProgressSnapshot) -> HydrationChallenge {
        let targetRate = 0.8
        return HydrationChallenge(
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
        )
    }

    private func makeGoalAchievementChallenge(totalAchievedDays: Int) -> HydrationChallenge {
        let target = 30
        return HydrationChallenge(
            kind: .goalAchievement30,
            progress: progress(current: Double(totalAchievedDays), target: Double(target)),
            currentValue: Double(totalAchievedDays),
            targetValue: Double(target),
            primaryCurrentValue: totalAchievedDays,
            primaryTargetValue: target,
            isCompleted: false,
            achievedAt: nil
        )
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
