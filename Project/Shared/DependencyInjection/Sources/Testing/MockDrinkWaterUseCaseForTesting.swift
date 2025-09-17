//
//  MockDrinkWaterUseCaseForTesting.swift
//  DependencyInjectionTesting
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface

public final class MockDrinkWaterUseCaseForTesting: DrinkWaterUseCase {
    public var currentWater: Int = 0
    public var drinkWaterCallCount = 0
    public var resetCallCount = 0

    public init() {}

    public func drinkWater() {
        drinkWaterCallCount += 1
        currentWater += 1
    }

    public func reset() {
        resetCallCount += 1
        currentWater = 0
    }

    // Testing helpers
    public func setCurrentWater(_ count: Int) {
        currentWater = count
    }
}