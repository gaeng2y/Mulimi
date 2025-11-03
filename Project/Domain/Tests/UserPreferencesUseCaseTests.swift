//
//  UserPreferencesUseCaseTests.swift
//  DomainLayerTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Testing
import DomainLayer
import DomainLayerInterface

@testable import DomainLayer

@Suite("UserPreferencesUseCase Tests")
struct UserPreferencesUseCaseTests {

    // MARK: - MainAppearance Tests

    @Test("초기 메인 외관 조회 테스트")
    func getMainAppearanceInitial() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 메인 외관을 조회하면
        let appearance = useCase.getMainAppearance()

        // Then: 기본값인 .drop을 반환한다
        #expect(appearance == .drop)
        // Then: Repository의 getMainAppearance가 1번 호출된다
        #expect(mockRepository.getMainAppearanceCallCount == 1)
    }

    @Test("메인 외관 설정 테스트")
    func setMainAppearance() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 메인 외관을 .heart로 설정하면
        useCase.setMainAppearance(.heart)

        // Then: Repository의 setMainAppearance가 1번 호출된다
        #expect(mockRepository.setMainAppearanceCallCount == 1)
        // Then: Repository에 .heart가 전달된다
        #expect(mockRepository.capturedMainAppearance == .heart)
        // Then: 조회 시 .heart를 반환한다
        #expect(useCase.getMainAppearance() == .heart)
    }

    @Test("메인 외관 여러 번 변경 테스트")
    func setMainAppearanceMultipleTimes() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 메인 외관을 여러 번 변경하면
        useCase.setMainAppearance(.heart)
        useCase.setMainAppearance(.cloud)
        useCase.setMainAppearance(.drop)

        // Then: Repository의 setMainAppearance가 3번 호출된다
        #expect(mockRepository.setMainAppearanceCallCount == 3)
        // Then: 마지막으로 설정한 .drop이 저장된다
        #expect(mockRepository.capturedMainAppearance == .drop)
        // Then: 조회 시 마지막 값인 .drop을 반환한다
        #expect(useCase.getMainAppearance() == .drop)
    }

    @Test("모든 MainAppearance 타입 설정 테스트")
    func setAllMainAppearanceTypes() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When & Then: 각 MainAppearance 타입을 설정하고 검증한다
        for appearance in MainAppearance.allCases {
            useCase.setMainAppearance(appearance)
            #expect(useCase.getMainAppearance() == appearance)
        }

        // Then: Repository의 setMainAppearance가 allCases 개수만큼 호출된다
        #expect(mockRepository.setMainAppearanceCallCount == MainAppearance.allCases.count)
    }

    // MARK: - DailyWaterLimit Tests

    @Test("초기 일일 물 섭취 목표량 조회 테스트")
    func getDailyWaterLimitInitial() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 일일 물 섭취 목표량을 조회하면
        let limit = useCase.getDailyWaterLimit()

        // Then: 기본값인 2000.0을 반환한다
        #expect(limit == 2000.0)
        // Then: Repository의 getDailyWaterLimit가 1번 호출된다
        #expect(mockRepository.getDailyWaterLimitCallCount == 1)
    }

    @Test("일일 물 섭취 목표량 설정 테스트")
    func setDailyWaterLimit() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 일일 물 섭취 목표량을 2500.0으로 설정하면
        useCase.setDailyWaterLimit(2500.0)

        // Then: Repository의 setDailyWaterLimit가 1번 호출된다
        #expect(mockRepository.setDailyWaterLimitCallCount == 1)
        // Then: Repository에 2500.0이 전달된다
        #expect(mockRepository.capturedDailyWaterLimit == 2500.0)
        // Then: 조회 시 2500.0을 반환한다
        #expect(useCase.getDailyWaterLimit() == 2500.0)
    }

    @Test("일일 물 섭취 목표량 여러 번 변경 테스트")
    func setDailyWaterLimitMultipleTimes() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 일일 물 섭취 목표량을 여러 번 변경하면
        useCase.setDailyWaterLimit(1500.0)
        useCase.setDailyWaterLimit(2000.0)
        useCase.setDailyWaterLimit(2500.0)

        // Then: Repository의 setDailyWaterLimit가 3번 호출된다
        #expect(mockRepository.setDailyWaterLimitCallCount == 3)
        // Then: 마지막으로 설정한 2500.0이 저장된다
        #expect(mockRepository.capturedDailyWaterLimit == 2500.0)
        // Then: 조회 시 마지막 값인 2500.0을 반환한다
        #expect(useCase.getDailyWaterLimit() == 2500.0)
    }

    @Test("일일 물 섭취 목표량 경계값 테스트")
    func setDailyWaterLimitBoundaryValues() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When & Then: 다양한 경계값을 설정하고 검증한다
        let boundaryValues: [Double] = [0.0, 1.0, 1000.0, 5000.0, 10000.0]

        for value in boundaryValues {
            useCase.setDailyWaterLimit(value)
            #expect(useCase.getDailyWaterLimit() == value)
        }

        // Then: Repository의 setDailyWaterLimit가 경계값 개수만큼 호출된다
        #expect(mockRepository.setDailyWaterLimitCallCount == boundaryValues.count)
    }

    @Test("일일 물 섭취 목표량 소수점 정밀도 테스트")
    func setDailyWaterLimitPrecision() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 소수점을 포함한 값을 설정하면
        let preciseValue = 2345.67
        useCase.setDailyWaterLimit(preciseValue)

        // Then: 정확한 소수점 값이 저장되고 반환된다
        #expect(useCase.getDailyWaterLimit() == preciseValue)
        #expect(mockRepository.capturedDailyWaterLimit == preciseValue)
    }

    // MARK: - Integration Tests

    @Test("전체 시나리오 테스트: 외관 및 목표량 변경")
    func fullScenarioTest() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When & Then: 단계별로 시나리오를 실행한다

        // 1단계: 초기값 확인
        #expect(useCase.getMainAppearance() == .drop)
        #expect(useCase.getDailyWaterLimit() == 2000.0)

        // 2단계: 외관 변경
        useCase.setMainAppearance(.heart)
        #expect(useCase.getMainAppearance() == .heart)
        #expect(mockRepository.setMainAppearanceCallCount == 1)

        // 3단계: 목표량 변경
        useCase.setDailyWaterLimit(2500.0)
        #expect(useCase.getDailyWaterLimit() == 2500.0)
        #expect(mockRepository.setDailyWaterLimitCallCount == 1)

        // 4단계: 외관 재변경
        useCase.setMainAppearance(.cloud)
        #expect(useCase.getMainAppearance() == .cloud)
        #expect(mockRepository.setMainAppearanceCallCount == 2)

        // 5단계: 목표량 재변경
        useCase.setDailyWaterLimit(3000.0)
        #expect(useCase.getDailyWaterLimit() == 3000.0)
        #expect(mockRepository.setDailyWaterLimitCallCount == 2)
    }

    @Test("동시에 여러 설정 변경 테스트")
    func simultaneousSettingsChange() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 외관과 목표량을 동시에 변경하면
        useCase.setMainAppearance(.heart)
        useCase.setDailyWaterLimit(2500.0)

        // Then: 각각의 설정이 독립적으로 저장된다
        #expect(useCase.getMainAppearance() == .heart)
        #expect(useCase.getDailyWaterLimit() == 2500.0)
        #expect(mockRepository.setMainAppearanceCallCount == 1)
        #expect(mockRepository.setDailyWaterLimitCallCount == 1)
    }

    @Test("UseCase는 Repository에만 의존해야 한다")
    func useCaseDependencyTest() {
        // Given: Mock Repository가 있을 때
        let mockRepository = MockUserPreferencesRepository()

        // When: UseCase를 생성하면
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // Then: UseCase는 정상적으로 생성되고 동작한다
        #expect(useCase.getMainAppearance() == .drop)
        #expect(useCase.getDailyWaterLimit() == 2000.0)

        // Repository의 상태를 직접 변경하면 UseCase의 결과도 변경된다
        mockRepository.setMainAppearance(.cloud)
        #expect(useCase.getMainAppearance() == .cloud)

        mockRepository.setDailyWaterLimit(3500.0)
        #expect(useCase.getDailyWaterLimit() == 3500.0)
    }

    @Test("Repository 메소드 호출 횟수 정확성 테스트")
    func repositoryCallCountAccuracy() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        // When: 다양한 메소드를 호출하면
        let _ = useCase.getMainAppearance()
        let _ = useCase.getMainAppearance()
        useCase.setMainAppearance(.heart)

        let _ = useCase.getDailyWaterLimit()
        let _ = useCase.getDailyWaterLimit()
        let _ = useCase.getDailyWaterLimit()
        useCase.setDailyWaterLimit(2500.0)
        useCase.setDailyWaterLimit(3000.0)

        // Then: 각 메소드의 호출 횟수가 정확히 기록된다
        #expect(mockRepository.getMainAppearanceCallCount == 2)
        #expect(mockRepository.setMainAppearanceCallCount == 1)
        #expect(mockRepository.getDailyWaterLimitCallCount == 3)
        #expect(mockRepository.setDailyWaterLimitCallCount == 2)
    }

    @Test("설정값 불변성 테스트")
    func settingsImmutabilityTest() {
        // Given: 설정값이 저장된 Repository와 UseCase가 있을 때
        let mockRepository = MockUserPreferencesRepository()
        let useCase = UserPreferencesUseCaseImpl(repository: mockRepository)

        useCase.setMainAppearance(.heart)
        useCase.setDailyWaterLimit(2500.0)

        // When: 여러 번 조회하면
        let appearance1 = useCase.getMainAppearance()
        let appearance2 = useCase.getMainAppearance()
        let limit1 = useCase.getDailyWaterLimit()
        let limit2 = useCase.getDailyWaterLimit()

        // Then: 항상 동일한 값을 반환한다
        #expect(appearance1 == appearance2)
        #expect(appearance1 == .heart)
        #expect(limit1 == limit2)
        #expect(limit1 == 2500.0)
    }
}
