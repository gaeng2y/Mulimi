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
    private var currentWaterValue = 0
    private var _events: [HydrationEvent] = []
    
    // Call tracking properties
    private(set) var drinkWaterCallCount = 0
    private(set) var resetCallCount = 0
    private(set) var hydrationEventsCallCount = 0
    private(set) var hydrationEventsInIntervalCallCount = 0
    private(set) var migrateCallCount = 0
    
    var currentWater: Int {
        get async {
            currentWaterValue
        }
    }

    func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        hydrationEventsCallCount += 1
        return _events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent] {
        hydrationEventsInIntervalCallCount += 1
        return _events.filter {
            interval.contains($0.consumedAt)
        }
    }

    func migrateLegacyDataIfNeeded() async {
        migrateCallCount += 1
    }
    
    func drinkWater() async {
        drinkWaterCallCount += 1
        currentWaterValue += 1
        _events.append(
            HydrationEvent(
                id: UUID(),
                consumedAt: .now,
                volumeML: 250
            )
        )
    }
    
    func reset() async {
        resetCallCount += 1
        currentWaterValue = 0
        _events.removeAll()
    }
    
    // Test helper methods
    func setCurrentWater(_ value: Int) {
        currentWaterValue = value
    }

    func setHydrationEvents(_ events: [HydrationEvent]) {
        _events = events
        currentWaterValue = events.count
    }
    
    func resetCallCounts() {
        drinkWaterCallCount = 0
        resetCallCount = 0
        hydrationEventsCallCount = 0
        hydrationEventsInIntervalCallCount = 0
        migrateCallCount = 0
    }
}
