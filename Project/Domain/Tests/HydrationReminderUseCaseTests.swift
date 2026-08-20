import DomainLayerInterface
import Foundation
import Testing

@testable import DomainLayer

@Suite("HydrationReminderUseCase Tests")
struct HydrationReminderUseCaseTests {
    @Test("authorizationStatus는 Repository 상태를 반환한다")
    func authorizationStatus() async {
        let repository = MockHydrationReminderRepository()
        repository.authorizationStatusValue = .denied
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        let status = await useCase.authorizationStatus()

        #expect(status == .denied)
    }

    @Test("권한이 허용되면 모든 슬롯의 리마인더를 스케줄한다")
    func requestAuthorizationSchedulesWhenAuthorized() async throws {
        let repository = MockHydrationReminderRepository()
        repository.requestAuthorizationResult = .success(.authorized)
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        let status = try await useCase.requestAuthorizationAndSyncReminders()

        #expect(status == .authorized)
        #expect(repository.scheduleDailyRemindersCallCount == 1)
        #expect(repository.capturedSlots == HydrationReminderSlot.allCases)
        #expect(repository.cancelDailyRemindersCallCount == 0)
    }

    @Test("권한이 거부되면 리마인더를 취소한다")
    func requestAuthorizationCancelsWhenDenied() async throws {
        let repository = MockHydrationReminderRepository()
        repository.requestAuthorizationResult = .success(.denied)
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        let status = try await useCase.requestAuthorizationAndSyncReminders()

        #expect(status == .denied)
        #expect(repository.scheduleDailyRemindersCallCount == 0)
        #expect(repository.cancelDailyRemindersCallCount == 1)
    }

    @Test("권한 요청 실패는 그대로 전파한다")
    func requestAuthorizationPropagatesError() async {
        struct RequestError: Error {}
        let repository = MockHydrationReminderRepository()
        repository.requestAuthorizationResult = .failure(RequestError())
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        await #expect(throws: RequestError.self) {
            try await useCase.requestAuthorizationAndSyncReminders()
        }
        #expect(repository.scheduleDailyRemindersCallCount == 0)
    }

    @Test("권한 허용 후 스케줄 실패는 에러를 전파한다")
    func requestAuthorizationPropagatesScheduleError() async {
        struct ScheduleError: Error {}
        let repository = MockHydrationReminderRepository()
        repository.requestAuthorizationResult = .success(.authorized)
        repository.scheduleDailyRemindersError = ScheduleError()
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        await #expect(throws: ScheduleError.self) {
            try await useCase.requestAuthorizationAndSyncReminders()
        }
    }

    @Test("syncReminders는 스케줄 실패를 삼키고 조용히 종료한다")
    func syncRemindersSwallowsScheduleError() async {
        struct ScheduleError: Error {}
        let repository = MockHydrationReminderRepository()
        repository.authorizationStatusValue = .authorized
        repository.scheduleDailyRemindersError = ScheduleError()
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        await useCase.syncReminders()

        #expect(repository.scheduleDailyRemindersCallCount == 0)
        #expect(repository.cancelDailyRemindersCallCount == 0)
    }

    @Test("syncReminders는 허용 상태에서 다시 스케줄한다")
    func syncRemindersSchedulesWhenAuthorized() async {
        let repository = MockHydrationReminderRepository()
        repository.authorizationStatusValue = .authorized
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        await useCase.syncReminders()

        #expect(repository.scheduleDailyRemindersCallCount == 1)
        #expect(repository.capturedSlots == HydrationReminderSlot.allCases)
    }

    @Test("syncReminders는 미허용 상태에서 리마인더를 취소한다")
    func syncRemindersCancelsWhenNotAuthorized() async {
        let repository = MockHydrationReminderRepository()
        repository.authorizationStatusValue = .denied
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        await useCase.syncReminders()

        #expect(repository.scheduleDailyRemindersCallCount == 0)
        #expect(repository.cancelDailyRemindersCallCount == 1)
    }

    @Test("cancelReminders는 Repository에 취소를 위임한다")
    func cancelReminders() async {
        let repository = MockHydrationReminderRepository()
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        await useCase.cancelReminders()

        #expect(repository.cancelDailyRemindersCallCount == 1)
    }

    @Test("프라이밍 노출 여부를 Repository에 위임한다")
    func primingFlagDelegatesToRepository() {
        let repository = MockHydrationReminderRepository()
        let useCase = HydrationReminderUseCaseImpl(repository: repository)

        #expect(useCase.hasSeenPermissionPriming() == false)

        useCase.markPermissionPrimingSeen()

        #expect(repository.hasSeenPermissionPrimingValue)
        #expect(useCase.hasSeenPermissionPriming())
    }
}
