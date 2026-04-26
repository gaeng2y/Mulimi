//
//  MockDrinkWaterUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockDrinkWaterUseCase: DrinkWaterUseCase, @unchecked Sendable {
    public var currentWaterIntakeMLValue: Double = 750
    public var events: [HydrationEvent] = []

    public init() {}

    public var currentWaterIntakeML: Double {
        get async {
            currentWaterIntakeMLValue
        }
    }

    public func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    public func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent] {
        events.filter { interval.contains($0.consumedAt) }
    }

    public func migrateLegacyDataIfNeeded() async {}

    public func drinkWater() async {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    public func drinkWater(volumeML: Int) async {
        currentWaterIntakeMLValue += Double(volumeML)
        events.append(
            HydrationEvent(
                id: UUID(),
                consumedAt: .now,
                volumeML: volumeML
            )
        )
    }

    public func reset() async {
        currentWaterIntakeMLValue = 0
        events.removeAll()
    }
}
