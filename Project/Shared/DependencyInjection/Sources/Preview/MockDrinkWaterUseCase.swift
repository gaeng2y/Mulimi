//
//  MockDrinkWaterUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockDrinkWaterUseCase: DrinkWaterUseCase, @unchecked Sendable {
    public var currentWaterValue: Int = 3
    public var events: [HydrationEvent] = []
    
    public init() {}

    public var currentWater: Int {
        get async {
            currentWaterValue
        }
    }

    public func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    public func migrateLegacyDataIfNeeded() async {}
    
    public func drinkWater() async {
        currentWaterValue += 1
        events.append(HydrationEvent(id: UUID(), consumedAt: .now, volumeML: 250))
    }
    
    public func reset() async {
        currentWaterValue = 0
        events.removeAll()
    }
}
