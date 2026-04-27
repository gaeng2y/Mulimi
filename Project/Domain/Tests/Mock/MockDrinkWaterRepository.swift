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
    private var currentWaterIntakeMLValue = 0.0
    private var _events: [HydrationEvent] = []

    // Call tracking properties
    private(set) var drinkWaterCallCount = 0
    private(set) var resetCallCount = 0
    private(set) var hydrationEventsCallCount = 0
    private(set) var hydrationEventsInIntervalCallCount = 0
    private(set) var migrateCallCount = 0
    private(set) var recordedVolumesML: [Int] = []

    var currentWaterIntakeML: Double {
        get async {
            currentWaterIntakeMLValue
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
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    func drinkWater(volumeML: Int) async {
        drinkWaterCallCount += 1
        recordedVolumesML.append(volumeML)
        currentWaterIntakeMLValue += Double(volumeML)
        _events.append(
            HydrationEvent(
                id: UUID(),
                consumedAt: .now,
                volumeML: volumeML
            )
        )
    }

    func reset() async {
        resetCallCount += 1
        currentWaterIntakeMLValue = 0
        _events.removeAll()
    }

    // Test helper methods
    func setCurrentWaterIntakeML(_ value: Double) {
        currentWaterIntakeMLValue = value
    }

    func setHydrationEvents(_ events: [HydrationEvent]) {
        _events = events
        currentWaterIntakeMLValue = events.reduce(0) { $0 + Double($1.volumeML) }
    }

    func resetCallCounts() {
        drinkWaterCallCount = 0
        resetCallCount = 0
        hydrationEventsCallCount = 0
        hydrationEventsInIntervalCallCount = 0
        migrateCallCount = 0
        recordedVolumesML = []
    }
}
