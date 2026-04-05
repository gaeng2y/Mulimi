//
//  MockDrinkWaterUseCaseForTesting.swift
//  DependencyInjectionTesting
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockDrinkWaterUseCaseForTesting: DrinkWaterUseCase, @unchecked Sendable {
    public var currentWaterIntakeMLValue: Double = 0
    public var drinkWaterCallCount = 0
    public var resetCallCount = 0
    public var hydrateEventsCallCount = 0
    public var migrateCallCount = 0
    public var events: [HydrationEvent] = []

    public init() {}

    public var currentWaterIntakeML: Double {
        get async {
            currentWaterIntakeMLValue
        }
    }

    public func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        hydrateEventsCallCount += 1
        return events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    public func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent] {
        hydrateEventsCallCount += 1
        return events.filter { interval.contains($0.consumedAt) }
    }

    public func migrateLegacyDataIfNeeded() async {
        migrateCallCount += 1
    }

    public func drinkWater() async {
        drinkWaterCallCount += 1
        currentWaterIntakeMLValue += HydrationServing.defaultGlassML
        events.append(
            HydrationEvent(
                id: UUID(),
                consumedAt: .now,
                volumeML: Int(HydrationServing.defaultGlassML)
            )
        )
    }

    public func reset() async {
        resetCallCount += 1
        currentWaterIntakeMLValue = 0
        events.removeAll()
    }

    // Testing helpers
    public func setCurrentWaterIntakeML(_ intakeML: Double) {
        currentWaterIntakeMLValue = intakeML
    }
}
