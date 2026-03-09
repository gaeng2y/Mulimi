//
//  DrinkWaterUseCase.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol DrinkWaterUseCase: Sendable {
    var currentWater: Int { get }

    func hydrationEvents(on date: Date) -> [HydrationEvent]
    func migrateLegacyDataIfNeeded()
    func drinkWater()
    func reset()
}
