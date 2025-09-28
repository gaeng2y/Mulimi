//
//  MockDrinkWaterUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface

public final class MockDrinkWaterUseCase: DrinkWaterUseCase {
    public var currentWater: Int = 3
    
    public init() {}
    
    public func drinkWater() {
        currentWater += 1
    }
    
    public func reset() {
        currentWater = 0
    }
}
