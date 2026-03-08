//
//  MockDrinkWaterUseCaseForTesting.swift
//  DependencyInjectionTesting
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockDrinkWaterUseCaseForTesting: DrinkWaterUseCase, @unchecked Sendable {
    public var currentWater: Int = 0
    public var drinkWaterCallCount = 0
    public var resetCallCount = 0
    public var hydrateEventsCallCount = 0
    public var migrateCallCount = 0
    public var events: [HydrationEvent] = []

    public init() {}

    public func hydrationEvents(on date: Date) -> [HydrationEvent] {
        hydrateEventsCallCount += 1
        return events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    public func migrateLegacyDataIfNeeded() {
        migrateCallCount += 1
    }

    public func drinkWater() {
        drinkWaterCallCount += 1
        currentWater += 1
        events.append(HydrationEvent(id: UUID(), consumedAt: .now, volumeML: 250))
    }

    public func reset() {
        resetCallCount += 1
        currentWater = 0
        events.removeAll()
    }

    // Testing helpers
    public func setCurrentWater(_ count: Int) {
        currentWater = count
    }
}
