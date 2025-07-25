//
//  DrinkWaterUseCaseTests.swift
//  DomainLayerTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Testing
import DomainLayer
import DomainLayerInterface

@testable import DomainLayer

@Suite("DrinkWaterUseCase Tests")
struct DrinkWaterUseCaseTests {
    
    // MARK: - Current Water Tests
    
    @Test("현재 물 섭취량 조회 테스트")
    func getCurrentWater() {
        // Given: Repository에 물 섭취량이 3잔으로 설정되어 있을 때
        let mockRepository = MockDrinkWaterRepository()
        mockRepository.setCurrentWater(3)
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)
        
        // When: 현재 물 섭취량을 조회하면
        let currentWater = useCase.currentWater
        
        // Then: Repository의 값과 동일한 값을 반환한다
        #expect(currentWater == 3)
    }
    
    @Test("초기 상태에서 현재 물 섭취량은 0이다")
    func getCurrentWaterInitialState() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)
        
        // When: 현재 물 섭취량을 조회하면
        let currentWater = useCase.currentWater
        
        // Then: 0을 반환한다
        #expect(currentWater == 0)
    }
    
    // MARK: - Drink Water Tests
    
    @Test("물 마시기 기능 테스트")
    func drinkWater() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)
        
        // When: 물 마시기 기능을 실행하면
        useCase.drinkWater()
        
        // Then: Repository의 drinkWater 메소드가 정확히 1번 호출된다
        #expect(mockRepository.drinkWaterCallCount == 1)
    }
    
    @Test("물 마시기 기능을 여러 번 호출할 때")
    func drinkWaterMultipleTimes() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)
        
        // When: 물 마시기 기능을 3번 실행하면
        useCase.drinkWater()
        useCase.drinkWater()
        useCase.drinkWater()
        
        // Then: Repository의 drinkWater 메소드가 정확히 3번 호출된다
        #expect(mockRepository.drinkWaterCallCount == 3)
        // Then: 현재 물 섭취량이 3이 된다
        #expect(useCase.currentWater == 3)
    }
    
    // MARK: - Reset Tests
    
    @Test("리셋 기능 테스트")
    func reset() {
        // Given: 물을 이미 마신 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        mockRepository.setCurrentWater(5)
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)
        
        // When: 리셋 기능을 실행하면
        useCase.reset()
        
        // Then: Repository의 reset 메소드가 정확히 1번 호출된다
        #expect(mockRepository.resetCallCount == 1)
        // Then: 현재 물 섭취량이 0이 된다
        #expect(useCase.currentWater == 0)
    }
    
    @Test("리셋 후 다시 물 마시기 테스트")
    func resetAndDrinkAgain() {
        // Given: 물을 마신 후 리셋한 상태의 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)
        
        // 먼저 물을 3번 마시고
        useCase.drinkWater()
        useCase.drinkWater()
        useCase.drinkWater()
        
        // 리셋을 한다
        useCase.reset()
        
        // When: 다시 물을 2번 마시면
        useCase.drinkWater()
        useCase.drinkWater()
        
        // Then: 현재 물 섭취량이 2가 된다
        #expect(useCase.currentWater == 2)
        // Then: Repository의 drinkWater가 총 5번 호출된다 (리셋 전 3번 + 리셋 후 2번)
        #expect(mockRepository.drinkWaterCallCount == 5)
        // Then: Repository의 reset이 1번 호출된다
        #expect(mockRepository.resetCallCount == 1)
    }
    
    // MARK: - Integration Tests
    
    @Test("전체 시나리오 테스트: 물 마시기 → 리셋 → 다시 마시기")
    func fullScenarioTest() {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)
        
        // When & Then: 단계별로 시나리오를 실행한다
        
        // 1단계: 물을 4번 마신다
        for _ in 1...4 {
            useCase.drinkWater()
        }
        #expect(useCase.currentWater == 4)
        #expect(mockRepository.drinkWaterCallCount == 4)
        
        // 2단계: 리셋한다
        useCase.reset()
        #expect(useCase.currentWater == 0)
        #expect(mockRepository.resetCallCount == 1)
        
        // 3단계: 다시 물을 2번 마신다
        useCase.drinkWater()
        useCase.drinkWater()
        #expect(useCase.currentWater == 2)
        #expect(mockRepository.drinkWaterCallCount == 6) // 4 + 2
    }
    
    @Test("UseCase는 Repository에만 의존해야 한다")
    func useCaseDependencyTest() {
        // Given: Mock Repository가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        
        // When: UseCase를 생성하면
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)
        
        // Then: UseCase는 정상적으로 생성되고 동작한다
        #expect(useCase.currentWater == 0)
        
        // Repository의 상태를 변경하면 UseCase의 결과도 변경된다
        mockRepository.setCurrentWater(10)
        #expect(useCase.currentWater == 10)
    }
}