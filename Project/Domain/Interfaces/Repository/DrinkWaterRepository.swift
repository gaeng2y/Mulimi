//
//  DrinkWaterRepository.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol DrinkWaterRepository: Sendable {
    var currentWaterIntakeML: Double { get async }

    func hydrationEvents(on date: Date) async -> [HydrationEvent]
    func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent]
    func migrateLegacyDataIfNeeded() async
    @discardableResult
    func drinkWater() async -> HydrationWriteResult
    @discardableResult
    func drinkWater(volumeML: Int) async -> HydrationWriteResult
    func deleteHydrationEvent(id: UUID) async -> Bool
    @discardableResult
    func reset() async -> HydrationWriteResult
}
