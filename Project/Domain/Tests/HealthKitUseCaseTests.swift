//
//  HealthKitUseCaseTests.swift
//  DomainLayerTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Testing
import DomainLayer
import DomainLayerInterface

@testable import DomainLayer

@Suite("HealthKitUseCase Tests")
struct HealthKitUseCaseTests {
    
    // MARK: - Authorization Status Tests
    
    @Test("초기 권한 상태 조회 테스트")
    func getAuthorizationStatusInitial() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 권한 상태를 조회하면
        let status = useCase.authorisationStatus
        
        // Then: notDetermined 상태를 반환한다
        #expect(status == .notDetermined)
    }
    
    @Test("설정된 권한 상태 조회 테스트")
    func getAuthorizationStatusSet() {
        // Given: 권한이 허용된 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.setAuthorizationStatus(.sharingAuthorized)
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 권한 상태를 조회하면
        let status = useCase.authorisationStatus
        
        // Then: sharingAuthorized 상태를 반환한다
        #expect(status == .sharingAuthorized)
    }
    
    @Test("권한 거부 상태 조회 테스트")
    func getAuthorizationStatusDenied() {
        // Given: 권한이 거부된 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.setAuthorizationStatus(.sharingDenied)
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 권한 상태를 조회하면
        let status = useCase.authorisationStatus
        
        // Then: sharingDenied 상태를 반환한다
        #expect(status == .sharingDenied)
    }
    
    // MARK: - Request Authorization Tests
    
    @Test("권한 요청 성공 테스트")
    func requestAuthorizationSuccess() async throws {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 권한 요청을 실행하면
        try await useCase.requestAuthorization()
        
        // Then: Repository의 requestAuthorization이 1번 호출된다
        #expect(mockRepository.requestAuthorizationCallCount == 1)
        // Then: 권한 상태가 sharingAuthorized로 변경된다
        #expect(useCase.authorisationStatus == .sharingAuthorized)
    }
    
    @Test("권한 요청 실패 테스트")
    func requestAuthorizationFailure() async {
        // Given: 권한 요청 시 에러가 발생하도록 설정된 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.shouldThrowAuthorizationError = true
        mockRepository.authorizationErrorToThrow = .permissionDenied
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 권한 요청을 실행하면
        do {
            try await useCase.requestAuthorization()
            // Then: 이 지점에 도달하면 안 됨
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            // Then: HealthKitError.permissionDenied 에러가 발생한다
            #expect(error as? HealthKitError == .permissionDenied)
            // Then: Repository의 requestAuthorization이 1번 호출된다
            #expect(mockRepository.requestAuthorizationCallCount == 1)
        }
    }
    
    @Test("권한 요청 여러 번 호출 테스트")
    func requestAuthorizationMultipleTimes() async throws {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 권한 요청을 3번 실행하면
        try await useCase.requestAuthorization()
        try await useCase.requestAuthorization()
        try await useCase.requestAuthorization()
        
        // Then: Repository의 requestAuthorization이 3번 호출된다
        #expect(mockRepository.requestAuthorizationCallCount == 3)
    }
    
    // MARK: - Drink Water Tests
    
    @Test("물 마시기 성공 테스트")
    func drinkWaterSuccess() async throws {
        // Given: 권한이 허용된 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.simulateAuthorizationSuccess()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 물 마시기 기능을 실행하면
        try await useCase.drinkWater()
        
        // Then: Repository의 drinkWater가 1번 호출된다
        #expect(mockRepository.drinkWaterCallCount == 1)
    }
    
    @Test("권한 없이 물 마시기 시도 테스트")
    func drinkWaterWithoutPermission() async {
        // Given: 권한이 없는 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.setAuthorizationStatus(.notDetermined)
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 물 마시기 기능을 실행하면
        do {
            try await useCase.drinkWater()
            // Then: 이 지점에 도달하면 안 됨
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            // Then: HealthKitError.permissionDenied 에러가 발생한다
            #expect(error as? HealthKitError == .permissionDenied)
            // Then: Repository의 drinkWater가 1번 호출된다
            #expect(mockRepository.drinkWaterCallCount == 1)
        }
    }
    
    @Test("물 마시기 중 내부 에러 발생 테스트")
    func drinkWaterInternalError() async {
        // Given: 물 마시기 시 내부 에러가 발생하도록 설정된 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.simulateAuthorizationSuccess()
        mockRepository.shouldThrowDrinkWaterError = true
        mockRepository.drinkWaterErrorToThrow = .healthKitInternalError
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 물 마시기 기능을 실행하면
        do {
            try await useCase.drinkWater()
            // Then: 이 지점에 도달하면 안 됨
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            // Then: HealthKitError.healthKitInternalError 에러가 발생한다
            #expect(error as? HealthKitError == .healthKitInternalError)
            // Then: Repository의 drinkWater가 1번 호출된다
            #expect(mockRepository.drinkWaterCallCount == 1)
        }
    }
    
    @Test("물 마시기 여러 번 호출 테스트")
    func drinkWaterMultipleTimes() async throws {
        // Given: 권한이 허용된 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.simulateAuthorizationSuccess()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 물 마시기 기능을 5번 실행하면
        for _ in 1...5 {
            try await useCase.drinkWater()
        }
        
        // Then: Repository의 drinkWater가 5번 호출된다
        #expect(mockRepository.drinkWaterCallCount == 5)
    }
    
    // MARK: - Reset Tests
    
    @Test("리셋 성공 테스트")
    func resetSuccess() async throws {
        // Given: 권한이 허용된 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.simulateAuthorizationSuccess()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 리셋 기능을 실행하면
        try await useCase.reset()
        
        // Then: Repository의 reset이 1번 호출된다
        #expect(mockRepository.resetCallCount == 1)
    }
    
    @Test("권한 없이 리셋 시도 테스트")
    func resetWithoutPermission() async {
        // Given: 권한이 거부된 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.simulateAuthorizationDenied()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 리셋 기능을 실행하면
        do {
            try await useCase.reset()
            // Then: 이 지점에 도달하면 안 됨
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            // Then: HealthKitError.permissionDenied 에러가 발생한다
            #expect(error as? HealthKitError == .permissionDenied)
            // Then: Repository의 reset이 1번 호출된다
            #expect(mockRepository.resetCallCount == 1)
        }
    }
    
    @Test("리셋 중 내부 에러 발생 테스트")
    func resetInternalError() async {
        // Given: 리셋 시 내부 에러가 발생하도록 설정된 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.simulateAuthorizationSuccess()
        mockRepository.shouldThrowResetError = true
        mockRepository.resetErrorToThrow = .incompleteExecuteQuery
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 리셋 기능을 실행하면
        do {
            try await useCase.reset()
            // Then: 이 지점에 도달하면 안 됨
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            // Then: HealthKitError.incompleteExecuteQuery 에러가 발생한다
            #expect(error as? HealthKitError == .incompleteExecuteQuery)
            // Then: Repository의 reset이 1번 호출된다
            #expect(mockRepository.resetCallCount == 1)
        }
    }
    
    // MARK: - Integration Tests
    
    @Test("전체 시나리오 테스트: 권한 요청 → 물 마시기 → 리셋")
    func fullScenarioTest() async throws {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When & Then: 단계별로 시나리오를 실행한다
        
        // 1단계: 초기 권한 상태 확인
        #expect(useCase.authorisationStatus == .notDetermined)
        
        // 2단계: 권한 요청
        try await useCase.requestAuthorization()
        #expect(useCase.authorisationStatus == .sharingAuthorized)
        #expect(mockRepository.requestAuthorizationCallCount == 1)
        
        // 3단계: 물 마시기 3번 실행
        for _ in 1...3 {
            try await useCase.drinkWater()
        }
        #expect(mockRepository.drinkWaterCallCount == 3)
        
        // 4단계: 리셋 실행
        try await useCase.reset()
        #expect(mockRepository.resetCallCount == 1)
        
        // 5단계: 리셋 후 다시 물 마시기
        try await useCase.drinkWater()
        #expect(mockRepository.drinkWaterCallCount == 4) // 3 + 1
    }
    
    @Test("권한 거부 후 재요청 시나리오 테스트")
    func permissionDeniedRetryScenario() async throws {
        // Given: 권한 요청 시 처음에는 실패하고 두 번째는 성공하도록 설정된 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When & Then: 단계별로 시나리오를 실행한다
        
        // 1단계: 첫 번째 권한 요청 실패
        mockRepository.shouldThrowAuthorizationError = true
        do {
            try await useCase.requestAuthorization()
            #expect(Bool(false), "Expected error to be thrown")
        } catch {
            #expect(error as? HealthKitError == .permissionDenied)
        }
        
        // 2단계: 두 번째 권한 요청 성공
        mockRepository.shouldThrowAuthorizationError = false
        try await useCase.requestAuthorization()
        #expect(useCase.authorisationStatus == .sharingAuthorized)
        #expect(mockRepository.requestAuthorizationCallCount == 2)
        
        // 3단계: 권한 획득 후 정상적으로 물 마시기
        try await useCase.drinkWater()
        #expect(mockRepository.drinkWaterCallCount == 1)
    }
    
    @Test("UseCase는 Repository에만 의존해야 한다")
    func useCaseDependencyTest() {
        // Given: Mock Repository가 있을 때
        let mockRepository = MockHealthKitRepository()
        
        // When: UseCase를 생성하면
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // Then: UseCase는 정상적으로 생성되고 동작한다
        #expect(useCase.authorisationStatus == .notDetermined)
        
        // Repository의 상태를 변경하면 UseCase의 결과도 변경된다
        mockRepository.setAuthorizationStatus(.sharingAuthorized)
        #expect(useCase.authorisationStatus == .sharingAuthorized)
    }
    
    @Test("동시성 테스트: 병렬 물 마시기 호출")
    func concurrentDrinkWaterTest() async throws {
        // Given: 권한이 허용된 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockHealthKitRepository()
        mockRepository.simulateAuthorizationSuccess()
        let useCase = HealthKitUseCaseImpl(repository: mockRepository)
        
        // When: 물 마시기를 병렬로 10번 실행하면
        await withTaskGroup(of: Void.self) { group in
            for _ in 1...10 {
                group.addTask {
                    try? await useCase.drinkWater()
                }
            }
        }
        
        // Then: Repository의 drinkWater가 10번 호출된다
        #expect(mockRepository.drinkWaterCallCount == 10)
    }
}