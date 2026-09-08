import HydrationDomain
import Foundation

final class MockAppReviewRequestUseCase: AppReviewRequestUseCase, @unchecked Sendable {
    var shouldRequestValue = false
    private(set) var eligibilityCallCount = 0
    private(set) var recordAttemptCallCount = 0
    private(set) var previousIntakeML: Double?
    private(set) var currentIntakeML: Double?
    private(set) var eligibilityMarketingVersion: String?
    private(set) var eligibilityReferenceDate: Date?
    private(set) var attemptedMarketingVersion: String?
    private(set) var attemptReferenceDate: Date?

    func shouldRequestAfterSuccessfulHydrationRecord(
        previousIntakeML: Double,
        currentIntakeML: Double,
        marketingVersion: String,
        referenceDate: Date,
        calendar: Calendar
    ) async -> Bool {
        eligibilityCallCount += 1
        self.previousIntakeML = previousIntakeML
        self.currentIntakeML = currentIntakeML
        eligibilityMarketingVersion = marketingVersion
        eligibilityReferenceDate = referenceDate
        return shouldRequestValue
    }

    func recordRequestAttempt(
        marketingVersion: String,
        referenceDate: Date,
        calendar: Calendar
    ) {
        recordAttemptCallCount += 1
        attemptedMarketingVersion = marketingVersion
        attemptReferenceDate = referenceDate
    }
}
