//
//  MockDrinkWaterUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockDrinkWaterUseCase: DrinkWaterUseCase, @unchecked Sendable {
    public var currentWater: Int = 3
    public var events: [HydrationEvent] = []
    
    public init() {}

    public func hydrationEvents(on date: Date) -> [HydrationEvent] {
        events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    public func migrateLegacyDataIfNeeded() {}
    
    public func drinkWater() {
        currentWater += 1
        events.append(HydrationEvent(id: UUID(), consumedAt: .now, volumeML: 250))
    }
    
    public func reset() {
        currentWater = 0
        events.removeAll()
    }
}
