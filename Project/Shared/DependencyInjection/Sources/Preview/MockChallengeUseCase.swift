import DomainLayerInterface
import Foundation

public final class MockChallengeUseCase: ChallengeUseCase, @unchecked Sendable {
    public var challenges: [HydrationChallenge]
    public var badgeHistories: [HydrationChallengeBadgeHistory]

    public init(
        challenges: [HydrationChallenge] = [
            HydrationChallenge(
                kind: .streak7,
                progress: 4.0 / 7.0,
                currentValue: 4,
                targetValue: 7,
                primaryCurrentValue: 4,
                primaryTargetValue: 7,
                isCompleted: false,
                achievedAt: nil
            ),
            HydrationChallenge(
                kind: .weeklyAchievement80,
                progress: 1,
                currentValue: 0.8,
                targetValue: 0.8,
                primaryCurrentValue: 80,
                primaryTargetValue: 80,
                secondaryCurrentValue: 4,
                secondaryTargetValue: 5,
                isCompleted: true,
                achievedAt: Date()
            ),
            HydrationChallenge(
                kind: .goalAchievement30,
                progress: 12.0 / 30.0,
                currentValue: 12,
                targetValue: 30,
                primaryCurrentValue: 12,
                primaryTargetValue: 30,
                isCompleted: false,
                achievedAt: nil
            )
        ],
        badgeHistories: [HydrationChallengeBadgeHistory] = [
            HydrationChallengeBadgeHistory(
                kind: .weeklyAchievement80,
                achievedAt: Date()
            ),
            HydrationChallengeBadgeHistory(
                kind: .streak7,
                achievedAt: Date().addingTimeInterval(-86_400),
                cycleID: "streak:preview"
            )
        ]
    ) {
        self.challenges = challenges
        self.badgeHistories = badgeHistories
    }

    public func fetchChallenges(referenceDate: Date, calendar: Calendar) async -> [HydrationChallenge] {
        challenges
    }

    public func fetchBadgeHistories() async -> [HydrationChallengeBadgeHistory] {
        badgeHistories
    }
}
