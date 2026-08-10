import DomainLayer
import DomainLayerInterface
import Foundation
import Testing

@Suite("AppReviewRequestUseCase Tests")
struct AppReviewRequestUseCaseTests {
    @Test("정확히 3일 기록하고 첫 기록 후 7일이면 리뷰를 요청한다")
    func eligibleAtUsageBoundaries() async {
        let (useCase, _) = makeUseCase(ownedRecordDayOffsets: [-7, -2, 0])

        let shouldRequest = await shouldRequest(useCase)

        #expect(shouldRequest)
    }

    @Test("첫 기록 후 7일에서 1분이 부족하면 리뷰를 요청하지 않는다")
    func rejectsUsageShorterThanSevenFullDays() async {
        let almostSevenDaysAgo = date(dayOffset: -7).addingTimeInterval(60)
        let (useCase, _) = makeUseCase(
            ownedRecordDayOffsets: [-2, 0],
            additionalOwnedRecordDates: [almostSevenDaysAgo]
        )

        #expect(await shouldRequest(useCase) == false)
    }

    @Test("앱 소유 기록일이나 사용 기간이 부족하면 요청하지 않는다")
    func rejectsInsufficientUsage() async {
        let (twoRecordDaysUseCase, _) = makeUseCase(ownedRecordDayOffsets: [-7, 0])
        let (sixUsageDaysUseCase, _) = makeUseCase(ownedRecordDayOffsets: [-6, -2, 0])

        #expect(await shouldRequest(twoRecordDaysUseCase) == false)
        #expect(await shouldRequest(sixUsageDaysUseCase) == false)
    }

    @Test("다른 앱의 HealthKit 기록은 사용일 계산에서 제외한다")
    func ignoresExternallyOwnedRecords() async {
        let (useCase, _) = makeUseCase(
            ownedRecordDayOffsets: [-7],
            externalRecordDayOffsets: [-2, 0]
        )

        #expect(await shouldRequest(useCase) == false)
    }

    @Test("이번 기록으로 목표를 처음 달성한 경우에만 요청한다")
    func requiresFirstGoalAchievementTransition() async {
        let (useCase, _) = makeUseCase(ownedRecordDayOffsets: [-7, -2, 0])

        let belowGoal = await shouldRequest(
            useCase,
            previousIntakeML: 500,
            currentIntakeML: 750
        )
        let alreadyReached = await shouldRequest(
            useCase,
            previousIntakeML: 1_000,
            currentIntakeML: 1_250
        )

        #expect(belowGoal == false)
        #expect(alreadyReached == false)
    }

    @Test("이미 시도한 marketing version에서는 요청하지 않는다")
    func rejectsAttemptedMarketingVersion() async {
        let state = AppReviewRequestState(
            attemptedMarketingVersions: ["2.0.0"],
            attemptDates: []
        )
        let (useCase, _) = makeUseCase(
            state: state,
            ownedRecordDayOffsets: [-7, -2, 0]
        )

        #expect(await shouldRequest(useCase) == false)
    }

    @Test("마지막 시도 후 정확히 120일이면 허용하고 119일이면 차단한다")
    func enforcesRequestCooldownBoundary() async {
        let blockedState = AppReviewRequestState(
            attemptedMarketingVersions: ["1.0.0"],
            attemptDates: [date(dayOffset: -119)]
        )
        let allowedState = AppReviewRequestState(
            attemptedMarketingVersions: ["1.0.0"],
            attemptDates: [date(dayOffset: -120)]
        )
        let (blockedUseCase, _) = makeUseCase(
            state: blockedState,
            ownedRecordDayOffsets: [-7, -2, 0]
        )
        let (allowedUseCase, _) = makeUseCase(
            state: allowedState,
            ownedRecordDayOffsets: [-7, -2, 0]
        )

        #expect(await shouldRequest(blockedUseCase) == false)
        #expect(await shouldRequest(allowedUseCase))
    }

    @Test("최근 365일 요청 시도가 3회면 차단하고 만료된 시도는 제외한다")
    func enforcesAnnualAttemptLimit() async {
        let blockedState = AppReviewRequestState(
            attemptedMarketingVersions: ["1.0.0"],
            attemptDates: [-130, -200, -365].map { date(dayOffset: $0) }
        )
        let allowedState = AppReviewRequestState(
            attemptedMarketingVersions: ["1.0.0"],
            attemptDates: [-366, -500].map { date(dayOffset: $0) }
        )
        let (blockedUseCase, _) = makeUseCase(
            state: blockedState,
            ownedRecordDayOffsets: [-7, -2, 0]
        )
        let (allowedUseCase, _) = makeUseCase(
            state: allowedState,
            ownedRecordDayOffsets: [-7, -2, 0]
        )

        #expect(await shouldRequest(blockedUseCase) == false)
        #expect(await shouldRequest(allowedUseCase))
    }

    @Test("요청 시도는 버전을 유지하고 365일이 지난 날짜만 정리한다")
    func recordsAttemptAndPrunesExpiredDates() {
        let initialState = AppReviewRequestState(
            attemptedMarketingVersions: ["1.0.0"],
            attemptDates: [date(dayOffset: -366), date(dayOffset: -120)]
        )
        let (useCase, repository) = makeUseCase(
            state: initialState,
            ownedRecordDayOffsets: []
        )

        useCase.recordRequestAttempt(
            marketingVersion: "2.0.0",
            referenceDate: referenceDate,
            calendar: calendar
        )

        #expect(repository.state.attemptedMarketingVersions == ["1.0.0", "2.0.0"])
        #expect(repository.state.attemptDates == [date(dayOffset: -120), referenceDate])
        #expect(repository.saveCallCount == 1)
    }

    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private var referenceDate: Date {
        calendar.date(
            from: DateComponents(
                year: 2026,
                month: 8,
                day: 9,
                hour: 12
            )
        )!
    }

    private func date(dayOffset: Int) -> Date {
        calendar.date(byAdding: .day, value: dayOffset, to: referenceDate)!
    }

    private func makeUseCase(
        state: AppReviewRequestState = .empty,
        ownedRecordDayOffsets: [Int],
        additionalOwnedRecordDates: [Date] = [],
        externalRecordDayOffsets: [Int] = []
    ) -> (AppReviewRequestUseCaseImpl, MockAppReviewRequestRepository) {
        let drinkWaterRepository = MockDrinkWaterRepository()
        let ownedRecordDates = ownedRecordDayOffsets.map { date(dayOffset: $0) }
            + additionalOwnedRecordDates
        let ownedEvents = ownedRecordDates.map { consumedAt in
            HydrationEvent(
                id: UUID(),
                consumedAt: consumedAt,
                volumeML: HydrationServing.defaultGlassVolumeML
            )
        }
        let externalEvents = externalRecordDayOffsets.map { dayOffset in
            HydrationEvent(
                id: UUID(),
                consumedAt: date(dayOffset: dayOffset),
                volumeML: HydrationServing.defaultGlassVolumeML,
                isOwnedByCurrentApp: false
            )
        }
        drinkWaterRepository.setHydrationEvents(ownedEvents + externalEvents)

        let userPreferencesRepository = MockUserPreferencesRepository()
        userPreferencesRepository.setDailyWaterLimit(1_000)
        let appReviewRequestRepository = MockAppReviewRequestRepository(state: state)

        return (
            AppReviewRequestUseCaseImpl(
                drinkWaterRepository: drinkWaterRepository,
                userPreferencesRepository: userPreferencesRepository,
                appReviewRequestRepository: appReviewRequestRepository
            ),
            appReviewRequestRepository
        )
    }

    private func shouldRequest(
        _ useCase: AppReviewRequestUseCaseImpl,
        previousIntakeML: Double = 750,
        currentIntakeML: Double = 1_000
    ) async -> Bool {
        await useCase.shouldRequestAfterSuccessfulHydrationRecord(
            previousIntakeML: previousIntakeML,
            currentIntakeML: currentIntakeML,
            marketingVersion: "2.0.0",
            referenceDate: referenceDate,
            calendar: calendar
        )
    }
}

private final class MockAppReviewRequestRepository: AppReviewRequestRepository,
                                                    @unchecked Sendable {
    private(set) var state: AppReviewRequestState
    private(set) var saveCallCount = 0

    init(state: AppReviewRequestState) {
        self.state = state
    }

    func fetchState() -> AppReviewRequestState {
        state
    }

    func saveState(_ state: AppReviewRequestState) {
        saveCallCount += 1
        self.state = state
    }
}
