import DomainLayerInterface
import Foundation

public final class MockPersonalizedChallengeUseCase: PersonalizedChallengeUseCase, @unchecked Sendable {
    public var challenges: [PersonalizedHydrationChallenge]

    public init(
        challenges: [PersonalizedHydrationChallenge] = [
            PersonalizedHydrationChallenge(
                kind: .routineAnchor,
                tier: .steady,
                source: .routine,
                primaryCurrentValue: 5,
                primaryTargetValue: 5,
                anchorRoutine: HydrationRoutine(
                    title: "출근 전 물",
                    hour: 8,
                    minute: 30,
                    weekdays: [.monday, .tuesday, .wednesday, .thursday, .friday],
                    isEnabled: true
                )
            ),
            PersonalizedHydrationChallenge(
                kind: .dailyGoalBooster,
                tier: .beginner,
                source: .recentRecords,
                primaryCurrentValue: 1450,
                primaryTargetValue: 1750,
                currentAverageML: 1450,
                recommendedTargetML: 1750,
                dailyGoalML: 2000
            )
        ]
    ) {
        self.challenges = challenges
    }

    public func fetchPersonalizedChallenges(
        snapshot: HydrationProgressSnapshot,
        referenceDate: Date,
        calendar: Calendar
    ) async -> [PersonalizedHydrationChallenge] {
        challenges
    }
}
