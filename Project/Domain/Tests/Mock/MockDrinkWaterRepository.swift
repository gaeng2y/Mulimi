//
//  MockDrinkWaterRepository.swift
//  DomainLayerTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

final class MockDrinkWaterRepository: DrinkWaterRepository, @unchecked Sendable {
    private var _currentWater: Int = 0
    private var _events: [HydrationEvent] = []
    
    // Call tracking properties
    private(set) var drinkWaterCallCount = 0
    private(set) var resetCallCount = 0
    private(set) var hydrationEventsCallCount = 0
    private(set) var migrateCallCount = 0
    
    var currentWater: Int {
        _currentWater
    }

    func hydrationEvents(on date: Date) -> [HydrationEvent] {
        hydrationEventsCallCount += 1
        return _events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    func migrateLegacyDataIfNeeded() {
        migrateCallCount += 1
    }
    
    func drinkWater() {
        drinkWaterCallCount += 1
        _currentWater += 1
        _events.append(
            HydrationEvent(
                id: UUID(),
                consumedAt: .now,
                volumeML: 250
            )
        )
    }
    
    func reset() {
        resetCallCount += 1
        _currentWater = 0
        _events.removeAll()
    }
    
    // Test helper methods
    func setCurrentWater(_ value: Int) {
        _currentWater = value
    }

    func setHydrationEvents(_ events: [HydrationEvent]) {
        _events = events
        _currentWater = events.count
    }
    
    func resetCallCounts() {
        drinkWaterCallCount = 0
        resetCallCount = 0
        hydrationEventsCallCount = 0
        migrateCallCount = 0
    }
}
