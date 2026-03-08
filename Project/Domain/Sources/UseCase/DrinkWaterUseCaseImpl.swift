//
//  DrinkWaterUseCaseImpl.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

public struct DrinkWaterUseCaseImpl: DrinkWaterUseCase {
    private let repository: DrinkWaterRepository
    
    public init(repository: DrinkWaterRepository) {
        self.repository = repository
    }
    
    public var currentWater: Int {
        repository.currentWater
    }

    public func hydrationEvents(on date: Date) -> [HydrationEvent] {
        repository.hydrationEvents(on: date)
    }

    public func migrateLegacyDataIfNeeded() {
        repository.migrateLegacyDataIfNeeded()
    }

    public func drinkWater() {
        repository.drinkWater()
    }
    
    public func reset() {
        repository.reset()
    }
}
