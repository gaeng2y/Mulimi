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
    public var drinkWaterResult: HydrationWriteResult = .success
    public var resetResult: HydrationWriteResult = .success

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

    @discardableResult
    public func drinkWater() async -> HydrationWriteResult {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    @discardableResult
    public func drinkWater(volumeML: Int) async -> HydrationWriteResult {
        guard drinkWaterResult.isSuccess else {
            return drinkWaterResult
        }

        currentWaterIntakeMLValue += Double(volumeML)
        events.append(
            HydrationEvent(
                id: UUID(),
                consumedAt: .now,
                volumeML: volumeML
            )
        )
        return drinkWaterResult
    }

    public func deleteHydrationEvent(id: UUID) async -> Bool {
        guard let index = events.firstIndex(where: { $0.id == id && $0.isOwnedByCurrentApp }) else {
            return false
        }

        let event = events.remove(at: index)
        currentWaterIntakeMLValue = max(currentWaterIntakeMLValue - Double(event.volumeML), 0)
        return true
    }

    @discardableResult
    public func reset() async -> HydrationWriteResult {
        guard resetResult.isSuccess else {
            return resetResult
        }

        currentWaterIntakeMLValue = 0
        events.removeAll()
        return resetResult
    }
}
