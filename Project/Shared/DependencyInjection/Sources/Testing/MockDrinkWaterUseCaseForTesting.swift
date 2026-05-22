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
    public var recordedVolumesML: [Int] = []
    public var resetCallCount = 0
    public var hydrateEventsCallCount = 0
    public var migrateCallCount = 0
    public var deleteHydrationEventCallCount = 0
    public var deletedHydrationEventIDs: [UUID] = []
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

    @discardableResult
    public func drinkWater() async -> HydrationWriteResult {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    @discardableResult
    public func drinkWater(volumeML: Int) async -> HydrationWriteResult {
        drinkWaterCallCount += 1
        recordedVolumesML.append(volumeML)
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

    @discardableResult
    public func reset() async -> HydrationWriteResult {
        resetCallCount += 1
        guard resetResult.isSuccess else {
            return resetResult
        }

        currentWaterIntakeMLValue = 0
        recordedVolumesML = []
        events.removeAll()
        return resetResult
    }

    public func deleteHydrationEvent(id: UUID) async -> Bool {
        deleteHydrationEventCallCount += 1
        deletedHydrationEventIDs.append(id)

        guard let index = events.firstIndex(where: { $0.id == id && $0.isOwnedByCurrentApp }) else {
            return false
        }

        let event = events.remove(at: index)
        currentWaterIntakeMLValue = max(currentWaterIntakeMLValue - Double(event.volumeML), 0)
        return true
    }

    // Testing helpers
    public func setCurrentWaterIntakeML(_ intakeML: Double) {
        currentWaterIntakeMLValue = intakeML
    }
}
