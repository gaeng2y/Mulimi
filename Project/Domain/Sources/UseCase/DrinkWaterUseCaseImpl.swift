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
    
    public var currentWaterIntakeML: Double {
        get async {
            await repository.currentWaterIntakeML
        }
    }

    public func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        await repository.hydrationEvents(on: date)
    }

    public func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent] {
        await repository.hydrationEvents(in: interval)
    }

    public func migrateLegacyDataIfNeeded() async {
        await repository.migrateLegacyDataIfNeeded()
    }

    public func drinkWater() async {
        await repository.drinkWater()
    }
    
    public func reset() async {
        await repository.reset()
    }
}
