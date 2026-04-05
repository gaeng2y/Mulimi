//
//  DrinkWaterHealthKitDataSource.swift
//  DataLayer
//
//  Created by Codex on 3/25/26.
//

import DomainLayerInterface
import Foundation
import OSLog

public protocol DrinkWaterDataSource: Sendable {
    var currentWaterIntakeML: Double { get async }

    func hydrationEvents(on date: Date) async -> [HydrationEvent]
    func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent]
    func migrateLegacyDataIfNeeded() async
    func drinkWater() async
    func reset() async
}

public actor DrinkWaterHealthKitDataSource: DrinkWaterDataSource {
    private let logger = Logger(
        subsystem: "gaeng2y.DrinkWater",
        category: "DrinkWaterHealthKitDataSource"
    )
    private let healthKitDataSource: HealthKitDataSource
    private let calendar: Calendar

    public init(
        healthKitDataSource: HealthKitDataSource,
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.healthKitDataSource = healthKitDataSource
        self.calendar = calendar
    }

    public var currentWaterIntakeML: Double {
        get async {
            let dayInterval = dayInterval(for: .now)

            do {
                let samples = try await healthKitDataSource.readWaterSamples(
                    from: dayInterval.start,
                    to: dayInterval.end
                )
                return samples.reduce(0.0) { partialResult, event in
                    partialResult + Double(event.volumeML)
                }
            } catch {
                logger.error("Failed to fetch current hydration samples: \(String(describing: error))")
                return 0
            }
        }
    }

    public func hydrationEvents(on date: Date) async -> [HydrationEvent] {
        let interval = dayInterval(for: date)
        return await hydrationEvents(in: interval)
    }

    public func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent] {
        do {
            return try await healthKitDataSource.readWaterSamples(
                from: interval.start,
                to: interval.end
            )
        } catch {
            logger.error("Failed to fetch hydration samples: \(String(describing: error))")
            return []
        }
    }

    public func migrateLegacyDataIfNeeded() async {}

    public func drinkWater() async {
        do {
            try await healthKitDataSource.setAGlassOfWater()
        } catch {
            logger.error("Failed to save hydration sample to HealthKit: \(String(describing: error))")
        }
    }

    public func reset() async {
        do {
            try await healthKitDataSource.resetWaterInTakeInToday()
        } catch {
            logger.error("Failed to reset owned hydration samples: \(String(describing: error))")
        }
    }

    private func dayInterval(for date: Date) -> DateInterval {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
            ?? start.addingTimeInterval(86_400)
        return DateInterval(start: start, end: end)
    }
}
