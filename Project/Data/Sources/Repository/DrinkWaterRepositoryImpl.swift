//
//  DrinkWaterRepositoryImpl.swift
//  DataLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

public struct DrinkWaterRepositoryImpl: DrinkWaterRepository {
    private let dataSource: DrinkWaterDataSource
    
    public init(dataSource: DrinkWaterDataSource) {
        self.dataSource = dataSource
    }
    
    public var currentWater: Int {
        dataSource.currentWater
    }

    public func hydrationEvents(on date: Date) -> [HydrationEvent] {
        dataSource.hydrationEvents(on: date)
    }

    public func migrateLegacyDataIfNeeded() {
        dataSource.migrateLegacyDataIfNeeded()
    }

    public func drinkWater() {
        dataSource.drinkWater()
    }
    
    public func reset() {
        dataSource.reset()
    }
}
