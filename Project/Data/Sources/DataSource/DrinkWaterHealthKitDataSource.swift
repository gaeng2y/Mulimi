//
//  DrinkWaterHealthKitDataSource.swift
//  DataLayer
//
//  Created by Codex on 3/25/26.
//

import DomainLayerInterface
import Foundation
import HealthKit
import OSLog

public protocol DrinkWaterDataSource: Sendable {
    var currentWaterIntakeML: Double { get async }

    func hydrationEvents(on date: Date) async -> [HydrationEvent]
    func hydrationEvents(in interval: DateInterval) async -> [HydrationEvent]
    func migrateLegacyDataIfNeeded() async
    @discardableResult
    func drinkWater() async -> HydrationWriteResult
    @discardableResult
    func drinkWater(volumeML: Int) async -> HydrationWriteResult
    func deleteHydrationEvent(id: UUID) async -> Bool
    @discardableResult
    func reset() async -> HydrationWriteResult
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

    @discardableResult
    public func drinkWater() async -> HydrationWriteResult {
        await drinkWater(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    @discardableResult
    public func drinkWater(volumeML: Int) async -> HydrationWriteResult {
        do {
            try await healthKitDataSource.setWaterIntake(volumeML: volumeML)
            return .success
        } catch {
            logger.error("Failed to save hydration sample to HealthKit: \(String(describing: error))")
            return .failure(Self.writeFailureReason(for: error))
        }
    }

    public func deleteHydrationEvent(id: UUID) async -> Bool {
        do {
            return try await healthKitDataSource.deleteWaterSample(id: id)
        } catch {
            logger.error("Failed to delete hydration sample from HealthKit: \(String(describing: error))")
            return false
        }
    }

    @discardableResult
    public func reset() async -> HydrationWriteResult {
        do {
            try await healthKitDataSource.resetWaterInTakeInToday()
            return .success
        } catch {
            logger.error("Failed to reset owned hydration samples: \(String(describing: error))")
            return .failure(Self.writeFailureReason(for: error))
        }
    }

    private static func writeFailureReason(for error: Error) -> HydrationWriteFailureReason {
        if let healthKitError = error as? HealthKitError {
            switch healthKitError {
            case .permissionDenied:
                return .permissionDenied
            case .invalidObjectType:
                return .invalidObjectType
            case .healthKitInternalError, .incompleteExecuteQuery:
                return .systemError
            }
        }

        if let healthKitError = error as? HKError {
            switch healthKitError.code {
            case .errorAuthorizationDenied, .errorAuthorizationNotDetermined:
                return .permissionDenied
            case .errorInvalidArgument:
                return .invalidObjectType
            default:
                return .systemError
            }
        }

        return .systemError
    }

    private func dayInterval(for date: Date) -> DateInterval {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
            ?? start.addingTimeInterval(86_400)
        return DateInterval(start: start, end: end)
    }
}
