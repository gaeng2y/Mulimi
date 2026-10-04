//
//  MockDrinkWaterRepository.swift
//  FeatureDomainTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import HydrationDomain
import Foundation

final class MockDrinkWaterRepository: DrinkWaterRepository, @unchecked Sendable {
    var readError: Error?
    var readErrorAfterWrite: Error?
    var failingEventDate: Date?
    var loggingReadError: Error?
    var recordedIdempotencyKeys: [String?] = []

    private var currentWaterIntakeMLValue = 0.0
    private var _events: [HydrationEvent] = []

    // Call tracking properties
    private(set) var drinkWaterCallCount = 0
    private(set) var resetCallCount = 0
    private(set) var hydrationEventsCallCount = 0
    private(set) var hydrationEventsInIntervalCallCount = 0
    private(set) var migrateCallCount = 0
    private(set) var deleteHydrationEventCallCount = 0
    private(set) var recordedVolumesML: [Int] = []
    private(set) var deletedHydrationEventIDs: [UUID] = []
    var drinkWaterResult: HydrationWriteResult = .success
    var resetResult: HydrationWriteResult = .success

    var currentWaterIntakeML: Double {
        get async throws {
            if let readError { throw readError }
            return currentWaterIntakeMLValue
        }
    }

    func waterIntakeForLogging() async throws -> Double {
        if let loggingReadError { throw loggingReadError }
        return try await currentWaterIntakeML
    }

    func hydrationEvents(on date: Date) async throws -> [HydrationEvent] {
        if let readError { throw readError }
        if let failingEventDate, Calendar.current.isDate(date, inSameDayAs: failingEventDate) {
            throw CocoaError(.fileReadUnknown)
        }
        hydrationEventsCallCount += 1
        return _events.filter { Calendar.autoupdatingCurrent.isDate($0.consumedAt, inSameDayAs: date) }
    }

    func hydrationEvents(in interval: DateInterval) async throws -> [HydrationEvent] {
        if let readError { throw readError }
        hydrationEventsInIntervalCallCount += 1
        return _events.filter {
            interval.contains($0.consumedAt)
        }
    }

    func migrateLegacyDataIfNeeded() async {
        migrateCallCount += 1
    }

    @discardableResult
    func drinkWater() async -> HydrationWriteResult {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    @discardableResult
    func drinkWater(volumeML: Int, idempotencyKey: String? = nil) async -> HydrationWriteResult {
        drinkWaterCallCount += 1
        recordedVolumesML.append(volumeML)
        recordedIdempotencyKeys.append(idempotencyKey)
        guard drinkWaterResult.isSuccess else {
            return drinkWaterResult
        }

        currentWaterIntakeMLValue += Double(volumeML)
        _events.append(
            HydrationEvent(
                id: UUID(),
                consumedAt: .now,
                volumeML: volumeML
            )
        )
        readError = readErrorAfterWrite
        return drinkWaterResult
    }

    @discardableResult
    func reset() async -> HydrationWriteResult {
        resetCallCount += 1
        guard resetResult.isSuccess else {
            return resetResult
        }

        currentWaterIntakeMLValue = 0
        _events.removeAll()
        readError = readErrorAfterWrite
        return resetResult
    }

    func deleteHydrationEvent(id: UUID) async -> Bool {
        deleteHydrationEventCallCount += 1
        deletedHydrationEventIDs.append(id)

        guard let index = _events.firstIndex(where: { $0.id == id && $0.isOwnedByCurrentApp }) else {
            return false
        }

        let event = _events.remove(at: index)
        currentWaterIntakeMLValue = max(currentWaterIntakeMLValue - Double(event.volumeML), 0)
        return true
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
        deleteHydrationEventCallCount = 0
        recordedVolumesML = []
        deletedHydrationEventIDs = []
        drinkWaterResult = .success
        resetResult = .success
    }
}
