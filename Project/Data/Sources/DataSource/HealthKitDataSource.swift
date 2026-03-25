//
//  HealthKitDataSource.swift
//  DataLayer
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation
import HealthKit

public protocol HealthKitDataSource: Sendable {
    var healthKitAuthorizationStatus: HealthKitAuthorizationStatus { get }
    
    func requestAuthorization() async throws
    func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(date: Date, amount: Double)]
    func readWaterSamples(from startDate: Date, to endDate: Date) async throws -> [HydrationEvent]
    func setAGlassOfWater() async throws
    func resetWaterInTakeInToday() async throws
}

public final class HealthKitDataSourceImpl: HealthKitDataSource, @unchecked Sendable {
    private enum Constant {
        static let aGlassOfWater: Double = 250
        static let appSourcePrefix = "gaeng2y.DrinkWater"
    }
    
    private let healthStore: HKHealthStore
    
    public init() {
        self.healthStore = HKHealthStore()
    }
    
    private var authorizationStatus: HKAuthorizationStatus {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            return .notDetermined
        }
        
        return healthStore.authorizationStatus(for: waterType)
    }
    
    public var healthKitAuthorizationStatus: HealthKitAuthorizationStatus {
        switch authorizationStatus {
        case .notDetermined: .notDetermined
        case .sharingDenied: .sharingDenied
        case .sharingAuthorized: .sharingAuthorized
        @unknown default: .notDetermined
        }
    }
    
    public func requestAuthorization() async throws {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            throw HealthKitError.invalidObjectType
        }
        
        do {
            try await healthStore.requestAuthorization(toShare: [waterType], read: [waterType])
        } catch {
            throw HealthKitError.permissionDenied
        }
    }
    
    public func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(date: Date, amount: Double)] {
        guard HKHealthStore.isHealthDataAvailable(), authorizationStatus == .sharingAuthorized else {
            return []
        }

        return try await withCheckedThrowingContinuation { continuation in
            guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                continuation.resume(throwing: HealthKitError.invalidObjectType)
                return
            }
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let query = HKStatisticsCollectionQuery(quantityType: waterType, quantitySamplePredicate: predicate, options: .cumulativeSum, anchorDate: startDate, intervalComponents: DateComponents(day: 1))
            query.initialResultsHandler = { query, result, error in
                if error != nil {
                    continuation.resume(throwing: HealthKitError.healthKitInternalError)
                    return
                }
                
                // If this property is not set to nil, the query executes the results handler on a background queue after it has finished calculating the statistics for all matching samples currently stored in HealthKit.
                guard let result else {
                    continuation.resume(throwing: HealthKitError.incompleteExecuteQuery)
                    return
                }
                
                var waterIntakeResults: [(Date, Double)] = []
                
                result.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    let date = statistics.startDate
                    let waterInTake = statistics.sumQuantity()?.doubleValue(for: .literUnit(with: .milli)) ?? 0
                    waterIntakeResults.append((date, waterInTake))
                }
                continuation.resume(returning: waterIntakeResults)
            }
            
            healthStore.execute(query)
        }
    }

    public func readWaterSamples(from startDate: Date, to endDate: Date) async throws -> [HydrationEvent] {
        guard HKHealthStore.isHealthDataAvailable(), authorizationStatus == .sharingAuthorized else {
            return []
        }

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<[HydrationEvent], Error>) in
            guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                continuation.resume(throwing: HealthKitError.invalidObjectType)
                return
            }

            let predicate = HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: .strictStartDate
            )

            let query = HKSampleQuery(
                sampleType: waterType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if error != nil {
                    continuation.resume(throwing: HealthKitError.healthKitInternalError)
                    return
                }

                guard let samples = samples as? [HKQuantitySample] else {
                    continuation.resume(returning: [])
                    return
                }

                let events = samples.map { sample in
                    HydrationEvent(
                        id: sample.uuid,
                        consumedAt: sample.startDate,
                        volumeML: Int(
                            sample.quantity.doubleValue(for: .literUnit(with: .milli)).rounded()
                        )
                    )
                }

                continuation.resume(returning: events)
            }

            healthStore.execute(query)
        }
    }
    
    public func setAGlassOfWater() async throws {
        guard HKHealthStore.isHealthDataAvailable(), authorizationStatus == .sharingAuthorized else {
            throw HealthKitError.permissionDenied
        }

        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            throw HealthKitError.invalidObjectType
        }
            
        let waterQuantity = HKQuantity(unit: .literUnit(with: .milli), doubleValue: Constant.aGlassOfWater)
        let waterSample = HKQuantitySample(type: waterType, quantity: waterQuantity, start: .now, end: .now)
            
        try await healthStore.save(waterSample)
    }
    
    public func resetWaterInTakeInToday() async throws {
        guard HKHealthStore.isHealthDataAvailable(), authorizationStatus == .sharingAuthorized else {
            throw HealthKitError.permissionDenied
        }

        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            throw HealthKitError.invalidObjectType
        }
        
        // Create date range for today
        let calendar = Calendar.current
        let today = Date()
        let startOfDay = calendar.startOfDay(for: today)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? today
        
        // Create predicate for today's water intake samples
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        // Find and delete all water intake samples for today
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let sampleQuery = HKSampleQuery(
                sampleType: waterType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { query, samples, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }

                let ownedSamples = (samples as? [HKQuantitySample])?.filter { sample in
                    sample.sourceRevision.source.bundleIdentifier.hasPrefix(Constant.appSourcePrefix)
                } ?? []

                guard !ownedSamples.isEmpty else {
                    // No samples to delete, operation complete
                    continuation.resume(returning: ())
                    return
                }

                self.healthStore.delete(ownedSamples) { _, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }
            
            healthStore.execute(sampleQuery)
        }
    }
}
