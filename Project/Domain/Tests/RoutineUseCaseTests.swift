import DomainLayer
import DomainLayerInterface
import Testing

@testable import DomainLayer

@Suite("RoutineUseCase Tests")
struct RoutineUseCaseTests {
    @Test("fetchRoutines는 Repository 값을 반환한다")
    func fetchRoutines() {
        let repository = MockRoutineRepository()
        repository.routines = [
            HydrationRoutine(
                title: "오전 루틴",
                hour: 9,
                minute: 0,
                weekdays: [.monday, .wednesday],
                isEnabled: true
            )
        ]
        let useCase = RoutineUseCaseImpl(repository: repository)

        let routines = useCase.fetchRoutines()

        #expect(routines == repository.routines)
    }

    @Test("saveRoutine는 Repository에 저장을 위임한다")
    func saveRoutine() async throws {
        let repository = MockRoutineRepository()
        let useCase = RoutineUseCaseImpl(repository: repository)
        let routine = HydrationRoutine(
            title: "점심 루틴",
            hour: 12,
            minute: 30,
            weekdays: [.monday, .tuesday, .wednesday],
            isEnabled: true
        )

        try await useCase.saveRoutine(routine)

        #expect(repository.saveRoutineCallCount == 1)
        #expect(repository.capturedRoutine == routine)
    }

    @Test("requestNotificationAuthorization는 Repository 상태를 전달한다")
    func requestAuthorization() async throws {
        let repository = MockRoutineRepository()
        repository.requestAuthorizationResult = .success(.authorized)
        let useCase = RoutineUseCaseImpl(repository: repository)

        let status = try await useCase.requestNotificationAuthorization()

        #expect(status == .authorized)
        #expect(await repository.notificationAuthorizationStatus() == .authorized)
    }
}
