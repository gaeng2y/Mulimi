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

public protocol HealthKitDataSource {
    var healthKitAuthorizationStatus: HealthKitAuthorizationStatus { get }
    
    func requestAuthorization() async throws
    func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(date: Date, amount: Double)]
    func setAGlassOfWater() async throws
    func resetWaterInTakeInToday() async throws
}

public final class HealthKitDataSourceImpl: HealthKitDataSource {
    private enum Constant {
        static let aGlassOfWater: Double = 250
    }
    
    private static let healthStore = HKHealthStore()
    
    public init() {}
    
    private var authorizationStatus: HKAuthorizationStatus {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            return .notDetermined
        }
        
        return Self.healthStore.authorizationStatus(for: waterType)
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
            try await Self.healthStore.requestAuthorization(toShare: [waterType], read: [waterType])
        } catch {
            throw HealthKitError.permissionDenied
        }
    }
    
    public func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(date: Date, amount: Double)] {
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
            
            Self.healthStore.execute(query)
        }
    }
    
    public func setAGlassOfWater() async throws {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            throw HealthKitError.invalidObjectType
        }
            
        let waterQuantity = HKQuantity(unit: .literUnit(with: .milli), doubleValue: Constant.aGlassOfWater)
        let waterSample = HKQuantitySample(type: waterType, quantity: waterQuantity, start: .now, end: .now)
            
        try await Self.healthStore.save(waterSample)
    }
    
    public func resetWaterInTakeInToday() async throws {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            throw HealthKitError.invalidObjectType
        }
            
        let waterQuantity = HKQuantity(unit: .literUnit(with: .milli), doubleValue: .zero)
        let waterSample = HKQuantitySample(type: waterType, quantity: waterQuantity, start: .now, end: .now)
            
        try await Self.healthStore.save(waterSample)
    }
}
