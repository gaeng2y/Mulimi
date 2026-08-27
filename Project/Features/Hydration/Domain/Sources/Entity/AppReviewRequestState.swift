import Foundation

public struct AppReviewRequestState: Codable, Equatable, Sendable {
    public let attemptedMarketingVersions: Set<String>
    public let attemptDates: [Date]

    public init(
        attemptedMarketingVersions: Set<String>,
        attemptDates: [Date]
    ) {
        self.attemptedMarketingVersions = attemptedMarketingVersions
        self.attemptDates = attemptDates
    }

    public static let empty = AppReviewRequestState(
        attemptedMarketingVersions: [],
        attemptDates: []
    )
}
