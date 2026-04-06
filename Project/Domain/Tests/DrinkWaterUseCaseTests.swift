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
import Foundation

@testable import DomainLayer

@Suite("DrinkWaterUseCase Tests")
struct DrinkWaterUseCaseTests {

    // MARK: - Current Water Tests

    @Test("현재 물 섭취량 조회 테스트")
    func getCurrentWater() async {
        // Given: Repository에 물 섭취량이 750ml로 설정되어 있을 때
        let mockRepository = MockDrinkWaterRepository()
        mockRepository.setCurrentWaterIntakeML(750)
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        // When: 현재 물 섭취량을 조회하면
        let currentWater = await useCase.currentWaterIntakeML

        // Then: Repository의 값과 동일한 값을 반환한다
        #expect(currentWater == 750)
    }

    @Test("초기 상태에서 현재 물 섭취량은 0이다")
    func getCurrentWaterInitialState() async {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        // When: 현재 물 섭취량을 조회하면
        let currentWater = await useCase.currentWaterIntakeML

        // Then: 0을 반환한다
        #expect(currentWater == 0)
    }

    // MARK: - Drink Water Tests

    @Test("물 마시기 기능 테스트")
    func drinkWater() async {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        // When: 물 마시기 기능을 실행하면
        await useCase.drinkWater()

        // Then: Repository의 drinkWater 메소드가 정확히 1번 호출된다
        #expect(mockRepository.drinkWaterCallCount == 1)
    }

    @Test("물 마시기 기능을 여러 번 호출할 때")
    func drinkWaterMultipleTimes() async {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        // When: 물 마시기 기능을 3번 실행하면
        await useCase.drinkWater()
        await useCase.drinkWater()
        await useCase.drinkWater()

        // Then: Repository의 drinkWater 메소드가 정확히 3번 호출된다
        #expect(mockRepository.drinkWaterCallCount == 3)
        // Then: 현재 물 섭취량이 3이 된다
        #expect(await useCase.currentWaterIntakeML == 750)
    }

    // MARK: - Reset Tests

    @Test("리셋 기능 테스트")
    func reset() async {
        // Given: 물을 이미 마신 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        mockRepository.setCurrentWaterIntakeML(1_250)
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        // When: 리셋 기능을 실행하면
        await useCase.reset()

        // Then: Repository의 reset 메소드가 정확히 1번 호출된다
        #expect(mockRepository.resetCallCount == 1)
        // Then: 현재 물 섭취량이 0이 된다
        #expect(await useCase.currentWaterIntakeML == 0)
    }

    @Test("리셋 후 다시 물 마시기 테스트")
    func resetAndDrinkAgain() async {
        // Given: 물을 마신 후 리셋한 상태의 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        // 먼저 물을 3번 마시고
        await useCase.drinkWater()
        await useCase.drinkWater()
        await useCase.drinkWater()

        // 리셋을 한다
        await useCase.reset()

        // When: 다시 물을 2번 마시면
        await useCase.drinkWater()
        await useCase.drinkWater()

        // Then: 현재 물 섭취량이 2가 된다
        #expect(await useCase.currentWaterIntakeML == 500)
        // Then: Repository의 drinkWater가 총 5번 호출된다 (리셋 전 3번 + 리셋 후 2번)
        #expect(mockRepository.drinkWaterCallCount == 5)
        // Then: Repository의 reset이 1번 호출된다
        #expect(mockRepository.resetCallCount == 1)
    }

    // MARK: - Integration Tests

    @Test("전체 시나리오 테스트: 물 마시기 → 리셋 → 다시 마시기")
    func fullScenarioTest() async {
        // Given: 초기 상태의 Repository와 UseCase가 있을 때
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        // When & Then: 단계별로 시나리오를 실행한다

        // 1단계: 물을 4번 마신다
        for _ in 1...4 {
            await useCase.drinkWater()
        }
        #expect(await useCase.currentWaterIntakeML == 1_000)
        #expect(mockRepository.drinkWaterCallCount == 4)

        // 2단계: 리셋한다
        await useCase.reset()
        #expect(await useCase.currentWaterIntakeML == 0)
        #expect(mockRepository.resetCallCount == 1)

        // 3단계: 다시 물을 2번 마신다
        await useCase.drinkWater()
        await useCase.drinkWater()
        #expect(await useCase.currentWaterIntakeML == 500)
        #expect(mockRepository.drinkWaterCallCount == 6) // 4 + 2
    }

    @Test("UseCase는 Repository에만 의존해야 한다")
    func useCaseDependencyTest() async {
        // Given: Mock Repository가 있을 때
        let mockRepository = MockDrinkWaterRepository()

        // When: UseCase를 생성하면
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        // Then: UseCase는 정상적으로 생성되고 동작한다
        #expect(await useCase.currentWaterIntakeML == 0)

        // Repository의 상태를 변경하면 UseCase의 결과도 변경된다
        mockRepository.setCurrentWaterIntakeML(2_500)
        #expect(await useCase.currentWaterIntakeML == 2_500)
    }

    @Test("HydrationEvent 조회는 Repository 호출 결과를 그대로 반환한다")
    func hydrationEvents() async {
        let mockRepository = MockDrinkWaterRepository()
        let now = Date.now
        let expected = [
            HydrationEvent(id: UUID(), consumedAt: now, volumeML: 250),
            HydrationEvent(id: UUID(), consumedAt: now.addingTimeInterval(60), volumeML: 250)
        ]
        mockRepository.setHydrationEvents(expected)
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        let actual = await useCase.hydrationEvents(on: now)

        #expect(mockRepository.hydrationEventsCallCount == 1)
        #expect(actual == expected)
    }

    @Test("기간 HydrationEvent 조회는 Repository 호출 결과를 그대로 반환한다")
    func hydrationEventsInInterval() async {
        let mockRepository = MockDrinkWaterRepository()
        let calendar = Calendar(identifier: .gregorian)
        let start = calendar.date(from: DateComponents(year: 2026, month: 3, day: 10))!
        let insideDate = calendar.date(byAdding: .hour, value: 12, to: start)!
        let end = calendar.date(byAdding: .day, value: 3, to: start)!
        let expected = [
            HydrationEvent(id: UUID(), consumedAt: insideDate, volumeML: 250),
            HydrationEvent(id: UUID(), consumedAt: calendar.date(byAdding: .day, value: 1, to: insideDate)!, volumeML: 500)
        ]
        mockRepository.setHydrationEvents(expected)
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        let actual = await useCase.hydrationEvents(in: DateInterval(start: start, end: end))

        #expect(mockRepository.hydrationEventsInIntervalCallCount == 1)
        #expect(actual == expected)
    }

    @Test("Legacy 마이그레이션 요청은 Repository에 위임된다")
    func migrateLegacyDataIfNeeded() async {
        let mockRepository = MockDrinkWaterRepository()
        let useCase = DrinkWaterUseCaseImpl(repository: mockRepository)

        await useCase.migrateLegacyDataIfNeeded()

        #expect(mockRepository.migrateCallCount == 1)
    }
}
