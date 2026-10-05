//
//  DrinkWaterRepository.swift
//  HydrationDomain
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol DrinkWaterRepository: Sendable {
    var currentWaterIntakeML: Double { get async throws }
    func waterIntakeForLogging() async throws -> Double

    func hydrationEvents(on date: Date) async throws -> [HydrationEvent]
    func hydrationEvents(in interval: DateInterval) async throws -> [HydrationEvent]
    func migrateLegacyDataIfNeeded() async
    @discardableResult
    func drinkWater() async -> HydrationWriteResult
    @discardableResult
    func drinkWater(volumeML: Int, idempotencyKey: String?) async -> HydrationWriteResult
    func deleteHydrationEvent(id: UUID) async -> Bool
    @discardableResult
    func reset() async -> HydrationWriteResult
}

public extension DrinkWaterRepository {
    @discardableResult
    func drinkWater(volumeML: Int) async -> HydrationWriteResult {
        await drinkWater(volumeML: volumeML, idempotencyKey: nil)
    }
}
