import Foundation

public enum PersonalizedHydrationChallengeKind: String, CaseIterable, Codable, Identifiable, Sendable {
    case routineAnchor
    case morningKickstart
    case dailyGoalBooster
    case consistencyDefender

    public var id: String { rawValue }
}

public enum HydrationChallengeRecommendationSource: String, Codable, Sendable {
    case routine
    case recentRecords
}

public enum HydrationChallengeTier: String, Codable, Sendable {
    case beginner
    case steady
    case stretch
}

public struct PersonalizedHydrationChallenge: Identifiable, Equatable, Sendable {
    public let kind: PersonalizedHydrationChallengeKind
    public let tier: HydrationChallengeTier
    public let source: HydrationChallengeRecommendationSource
    public let primaryCurrentValue: Int
    public let primaryTargetValue: Int
    public let secondaryCurrentValue: Int?
    public let secondaryTargetValue: Int?
    public let anchorRoutine: HydrationRoutine?
    public let currentAverageML: Int?
    public let recommendedTargetML: Int?
    public let dailyGoalML: Int?

    public init(
        kind: PersonalizedHydrationChallengeKind,
        tier: HydrationChallengeTier,
        source: HydrationChallengeRecommendationSource,
        primaryCurrentValue: Int,
        primaryTargetValue: Int,
        secondaryCurrentValue: Int? = nil,
        secondaryTargetValue: Int? = nil,
        anchorRoutine: HydrationRoutine? = nil,
        currentAverageML: Int? = nil,
        recommendedTargetML: Int? = nil,
        dailyGoalML: Int? = nil
    ) {
        self.kind = kind
        self.tier = tier
        self.source = source
        self.primaryCurrentValue = primaryCurrentValue
        self.primaryTargetValue = primaryTargetValue
        self.secondaryCurrentValue = secondaryCurrentValue
        self.secondaryTargetValue = secondaryTargetValue
        self.anchorRoutine = anchorRoutine
        self.currentAverageML = currentAverageML
        self.recommendedTargetML = recommendedTargetML
        self.dailyGoalML = dailyGoalML
    }

    public var id: PersonalizedHydrationChallengeKind { kind }
}
