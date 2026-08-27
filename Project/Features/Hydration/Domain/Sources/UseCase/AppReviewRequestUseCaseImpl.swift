import AccountDomain
import Foundation

public struct AppReviewRequestUseCaseImpl: AppReviewRequestUseCase {
    private enum Policy {
        static let historyDayCount = 30
        static let minimumOwnedRecordDayCount = 3
        static let minimumUsageDayCount = 7
        static let requestCooldownDayCount = 120
        static let annualWindowDayCount = 365
        static let annualRequestLimit = 3
    }

    private let drinkWaterRepository: DrinkWaterRepository
    private let userPreferencesRepository: UserPreferencesRepository
    private let appReviewRequestRepository: AppReviewRequestRepository

    public init(
        drinkWaterRepository: DrinkWaterRepository,
        userPreferencesRepository: UserPreferencesRepository,
        appReviewRequestRepository: AppReviewRequestRepository
    ) {
        self.drinkWaterRepository = drinkWaterRepository
        self.userPreferencesRepository = userPreferencesRepository
        self.appReviewRequestRepository = appReviewRequestRepository
    }

    public func shouldRequestAfterSuccessfulHydrationRecord(
        previousIntakeML: Double,
        currentIntakeML: Double,
        marketingVersion: String,
        referenceDate: Date,
        calendar: Calendar
    ) async -> Bool {
        let normalizedVersion = marketingVersion.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedVersion.isEmpty, normalizedVersion != "-" else {
            return false
        }

        let dailyGoalML = userPreferencesRepository.getDailyWaterLimit()
        guard dailyGoalML > 0,
              previousIntakeML.rounded() < dailyGoalML.rounded(),
              currentIntakeML.rounded() >= dailyGoalML.rounded() else {
            return false
        }

        let state = appReviewRequestRepository.fetchState()
        let annualAttemptCount = recentAttemptCount(
            state.attemptDates,
            referenceDate: referenceDate,
            calendar: calendar
        )
        guard !state.attemptedMarketingVersions.contains(normalizedVersion),
              isOutsideCooldown(state.attemptDates, referenceDate: referenceDate, calendar: calendar),
              annualAttemptCount < Policy.annualRequestLimit,
              let historyInterval = historyInterval(referenceDate: referenceDate, calendar: calendar),
              let minimumUsageDate = calendar.date(
                  byAdding: .day,
                  value: -Policy.minimumUsageDayCount,
                  to: referenceDate
              ) else {
            return false
        }

        let ownedEvents = await drinkWaterRepository.hydrationEvents(in: historyInterval)
            .filter(\.isOwnedByCurrentApp)
        let distinctOwnedRecordDays = Set(
            ownedEvents.map { calendar.startOfDay(for: $0.consumedAt) }
        )
        guard distinctOwnedRecordDays.count >= Policy.minimumOwnedRecordDayCount,
              let earliestOwnedRecordDate = ownedEvents.map(\.consumedAt).min() else {
            return false
        }

        return earliestOwnedRecordDate <= minimumUsageDate
    }

    public func recordRequestAttempt(
        marketingVersion: String,
        referenceDate: Date,
        calendar: Calendar
    ) {
        let normalizedVersion = marketingVersion.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedVersion.isEmpty, normalizedVersion != "-",
              let annualCutoffDate = calendar.date(
                  byAdding: .day,
                  value: -Policy.annualWindowDayCount,
                  to: referenceDate
              ) else {
            return
        }

        let currentState = appReviewRequestRepository.fetchState()
        var attemptedVersions = currentState.attemptedMarketingVersions
        attemptedVersions.insert(normalizedVersion)

        let recentAttemptDates = currentState.attemptDates
            .filter { $0 >= annualCutoffDate }
            + [referenceDate]

        appReviewRequestRepository.saveState(
            AppReviewRequestState(
                attemptedMarketingVersions: attemptedVersions,
                attemptDates: recentAttemptDates.sorted()
            )
        )
    }

    private func isOutsideCooldown(
        _ attemptDates: [Date],
        referenceDate: Date,
        calendar: Calendar
    ) -> Bool {
        guard let latestAttemptDate = attemptDates.max(),
              let cooldownCutoffDate = calendar.date(
                  byAdding: .day,
                  value: -Policy.requestCooldownDayCount,
                  to: referenceDate
              ) else {
            return true
        }

        return latestAttemptDate <= cooldownCutoffDate
    }

    private func recentAttemptCount(
        _ attemptDates: [Date],
        referenceDate: Date,
        calendar: Calendar
    ) -> Int {
        guard let annualCutoffDate = calendar.date(
            byAdding: .day,
            value: -Policy.annualWindowDayCount,
            to: referenceDate
        ) else {
            return attemptDates.count
        }

        return attemptDates.count { $0 >= annualCutoffDate }
    }

    private func historyInterval(
        referenceDate: Date,
        calendar: Calendar
    ) -> DateInterval? {
        let referenceDay = calendar.startOfDay(for: referenceDate)
        guard let start = calendar.date(
            byAdding: .day,
            value: -(Policy.historyDayCount - 1),
            to: referenceDay
        ),
        let end = calendar.date(byAdding: .day, value: 1, to: referenceDay) else {
            return nil
        }

        return DateInterval(start: start, end: end)
    }
}
