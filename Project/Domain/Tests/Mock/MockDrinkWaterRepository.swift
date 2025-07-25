//
//  MockDrinkWaterRepository.swift
//  DomainLayerTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface

final class MockDrinkWaterRepository: DrinkWaterRepository {
    private var _currentWater: Int = 0
    
    // Call tracking properties
    private(set) var drinkWaterCallCount = 0
    private(set) var resetCallCount = 0
    
    var currentWater: Int {
        _currentWater
    }
    
    func drinkWater() {
        drinkWaterCallCount += 1
        _currentWater += 1
    }
    
    func reset() {
        resetCallCount += 1
        _currentWater = 0
    }
    
    // Test helper methods
    func setCurrentWater(_ value: Int) {
        _currentWater = value
    }
    
    func resetCallCounts() {
        drinkWaterCallCount = 0
        resetCallCount = 0
    }
}