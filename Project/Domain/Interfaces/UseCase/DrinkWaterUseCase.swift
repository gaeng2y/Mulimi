//
//  DrinkWaterUseCase.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol DrinkWaterUseCase: Sendable {
    var currentWaterIntakeML: Double { get async }

    func hydrationEvents(on date: Date) async -> [HydrationEvent]
    func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent]
    func migrateLegacyDataIfNeeded() async
    func drinkWater() async
    func reset() async
}
