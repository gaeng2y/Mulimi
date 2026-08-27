import Foundation

public protocol AppReviewRequestUseCase: Sendable {
    func shouldRequestAfterSuccessfulHydrationRecord(
        previousIntakeML: Double,
        currentIntakeML: Double,
        marketingVersion: String,
        referenceDate: Date,
        calendar: Calendar
    ) async -> Bool

    func recordRequestAttempt(
        marketingVersion: String,
        referenceDate: Date,
        calendar: Calendar
    )
}

public struct NoOpAppReviewRequestUseCase: AppReviewRequestUseCase {
    public init() {}

    public func shouldRequestAfterSuccessfulHydrationRecord(
        previousIntakeML: Double,
        currentIntakeML: Double,
        marketingVersion: String,
        referenceDate: Date,
        calendar: Calendar
    ) async -> Bool {
        false
    }

    public func recordRequestAttempt(
        marketingVersion: String,
        referenceDate: Date,
        calendar: Calendar
    ) {}
}
