//
//  DrinkWaterDataSource.swift
//  DataLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation
import Persistence
import SwiftData

public protocol DrinkWaterDataSource: Sendable {
    var currentWater: Int { get }

    func hydrationEvents(on date: Date) -> [HydrationEvent]
    func migrateLegacyDataIfNeeded()
    func drinkWater()
    func reset()
}

public final class DrinkWaterSwiftDataDataSource: DrinkWaterDataSource, @unchecked Sendable {
    private enum Constants {
        static let defaultVolumeML = 250
        static let migrationFlagKey = "hydrationMigration.swiftData.v1.completed"
    }

    private let modelContainer: ModelContainer
    private let userDefaults: UserDefaults
    private let calendar: Calendar
    private let lock = NSLock()

    public init(
        modelContainer: ModelContainer,
        userDefaults: UserDefaults,
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.modelContainer = modelContainer
        self.userDefaults = userDefaults
        self.calendar = calendar
        migrateLegacyDataIfNeeded()
    }

    public convenience init(
        userDefaults: UserDefaults,
        calendar: Calendar = .autoupdatingCurrent,
        isStoredInMemoryOnly: Bool = false
    ) throws {
        let modelContainer = try SharedHydrationStore.makeModelContainer(
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )
        self.init(
            modelContainer: modelContainer,
            userDefaults: userDefaults,
            calendar: calendar
        )
    }

    public var currentWater: Int {
        withLock {
            do {
                return try fetchEventCount(on: .now, using: makeContext())
            } catch {
                assertionFailure("Failed to fetch current water: \(error)")
                return legacyGlassesCount
            }
        }
    }

    public func hydrationEvents(on date: Date) -> [HydrationEvent] {
        withLock {
            do {
                return try fetchEventModels(on: date, using: makeContext()).map {
                    HydrationEvent(
                        id: $0.id,
                        consumedAt: $0.consumedAt,
                        volumeML: $0.volumeML
                    )
                }
            } catch {
                assertionFailure("Failed to fetch hydration events: \(error)")
                return []
            }
        }
    }

    public func migrateLegacyDataIfNeeded() {
        withLock {
            if userDefaults.bool(forKey: Constants.migrationFlagKey) {
                return
            }

            let legacyCount = max(0, legacyGlassesCount)

            do {
                let context = makeContext()
                let existingCount = try fetchEventCount(on: .now, using: context)

                if existingCount == 0, legacyCount > 0 {
                    let now = Date()
                    for offset in 0..<legacyCount {
                        context.insert(
                            HydrationEventModel(
                                consumedAt: now.addingTimeInterval(TimeInterval(offset)),
                                volumeML: Constants.defaultVolumeML
                            )
                        )
                    }
                    try context.save()
                }

                try syncLegacyCount(using: context)
                userDefaults.set(true, forKey: Constants.migrationFlagKey)
                userDefaults.synchronize()
            } catch {
                assertionFailure("Failed to migrate legacy hydration data: \(error)")
            }
        }
    }

    public func drinkWater() {
        withLock {
            do {
                let context = makeContext()
                context.insert(
                    HydrationEventModel(
                        consumedAt: .now,
                        volumeML: Constants.defaultVolumeML
                    )
                )
                try context.save()
                try syncLegacyCount(using: context)
                userDefaults.synchronize()
            } catch {
                assertionFailure("Failed to save hydration event: \(error)")
                legacyGlassesCount += 1
                userDefaults.synchronize()
            }
        }
    }

    public func reset() {
        withLock {
            do {
                let context = makeContext()
                let events = try fetchEventModels(on: .now, using: context)
                events.forEach { context.delete($0) }
                try context.save()
                legacyGlassesCount = .zero
                userDefaults.synchronize()
            } catch {
                assertionFailure("Failed to reset hydration events: \(error)")
                legacyGlassesCount = .zero
                userDefaults.synchronize()
            }
        }
    }

    private func makeContext() -> ModelContext {
        ModelContext(modelContainer)
    }

    private func syncLegacyCount(using context: ModelContext) throws {
        legacyGlassesCount = try fetchEventCount(on: .now, using: context)
    }

    private func fetchEventCount(
        on date: Date,
        using context: ModelContext
    ) throws -> Int {
        try fetchEventModels(on: date, using: context).count
    }

    private func fetchEventModels(
        on date: Date,
        using context: ModelContext
    ) throws -> [HydrationEventModel] {
        let dayStart = calendar.startOfDay(for: date)
        let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart) ?? dayStart.addingTimeInterval(86_400)

        let descriptor = FetchDescriptor<HydrationEventModel>(
            predicate: #Predicate { model in
                model.consumedAt >= dayStart && model.consumedAt < dayEnd
            },
            sortBy: [SortDescriptor(\.consumedAt, order: .forward)]
        )

        return try context.fetch(descriptor)
    }

    private func withLock<T>(_ operation: () throws -> T) rethrows -> T {
        lock.lock()
        defer { lock.unlock() }
        return try operation()
    }

    private var legacyGlassesCount: Int {
        get { userDefaults.integer(forKey: legacyCountKey(for: .now)) }
        set { userDefaults.set(newValue, forKey: legacyCountKey(for: .now)) }
    }

    private func legacyCountKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
