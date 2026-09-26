//
//  DrinkWaterRepositoryImpl.swift
//  HydrationData
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import HydrationDomain
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

    public func waterIntakeForLogging() async throws -> Double {
        try await dataSource.waterIntakeForLogging()
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

    @discardableResult
    public func drinkWater() async -> HydrationWriteResult {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    @discardableResult
    public func drinkWater(volumeML: Int, idempotencyKey: String? = nil) async -> HydrationWriteResult {
        await dataSource.drinkWater(volumeML: volumeML, idempotencyKey: idempotencyKey)
    }

    public func deleteHydrationEvent(id: UUID) async -> Bool {
        await dataSource.deleteHydrationEvent(id: id)
    }

    @discardableResult
    public func reset() async -> HydrationWriteResult {
        await dataSource.reset()
    }
}
