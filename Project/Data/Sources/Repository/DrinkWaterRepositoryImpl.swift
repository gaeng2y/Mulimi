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

    public var currentWaterIntakeML: Double {
        get async {
            await dataSource.currentWaterIntakeML
        }
    }

    public func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        await dataSource.hydrationEvents(on: date)
    }

    public func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent] {
        await dataSource.hydrationEvents(in: interval)
    }

    public func migrateLegacyDataIfNeeded() async {
        await dataSource.migrateLegacyDataIfNeeded()
    }

    public func drinkWater() async {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    public func drinkWater(volumeML: Int) async {
        await dataSource.drinkWater(volumeML: volumeML)
    }

    public func reset() async {
        await dataSource.reset()
    }
}
