//
//  MockDrinkWaterUseCaseForTesting.swift
//  DependencyInjectionTesting
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockDrinkWaterUseCaseForTesting: DrinkWaterUseCase, @unchecked Sendable {
    public var currentWaterValue: Int = 0
    public var drinkWaterCallCount = 0
    public var resetCallCount = 0
    public var hydrateEventsCallCount = 0
    public var migrateCallCount = 0
    public var events: [HydrationEvent] = []

    public init() {}

    public var currentWater: Int {
        get async {
            currentWaterValue
        }
    }

    public func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        hydrateEventsCallCount += 1
        return events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    public func migrateLegacyDataIfNeeded() async {
        migrateCallCount += 1
    }

    public func drinkWater() async {
        drinkWaterCallCount += 1
        currentWaterValue += 1
        events.append(HydrationEvent(id: UUID(), consumedAt: .now, volumeML: 250))
    }

    public func reset() async {
        resetCallCount += 1
        currentWaterValue = 0
        events.removeAll()
    }

    // Testing helpers
    public func setCurrentWater(_ count: Int) {
        currentWaterValue = count
    }
}
