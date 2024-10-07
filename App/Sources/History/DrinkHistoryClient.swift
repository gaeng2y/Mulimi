//
//  DrinkHistoryClient.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import ComposableArchitecture
import HealthKit

enum HealthKitError: Error {
    case invalidObjectType
    case permissionDenied
    case healthKitInternalError
    case incompleteExecuteQuery
}

@DependencyClient
struct DrinkHistoryClient {
    fileprivate enum Constant {
        static let aGlassOfWater: Double = 250
    }
    
    var requestAuthorization: @Sendable () async throws -> Void
    var authroization: @Sendable () -> HealthKitAuthorizationStatus = { .notDetermined }
    var histories: @Sendable () -> [History] = { [] }
}

extension DrinkHistoryClient: TestDependencyKey {
    static var previewValue = Self(
        requestAuthorization: { },
        authroization: { .sharingAuthorized },
        histories: { [] }
    )
}

extension DrinkHistoryClient: DependencyKey {
    private static let healthStore = HKHealthStore()
    
    static let liveValue = Self(
        requestAuthorization: {
            guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                throw HealthKitError.invalidObjectType
            }
            
            do {
                try await healthStore.requestAuthorization(toShare: [waterType], read: [waterType])
            } catch {
                throw HealthKitError.permissionDenied
            }
        },
        authroization: {
            guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
                return .notDetermined
            }
            
            switch healthStore.authorizationStatus(for: waterType) {
            case .notDetermined: return .notDetermined
            case .sharingDenied: return .sharingDenied
            case .sharingAuthorized: return .sharingAuthorized
            @unknown default: return .notDetermined
            }
        },
        histories: { [] }
    )
}

extension DependencyValues {
    var drinkHistoryClient: DrinkHistoryClient {
        get { self[DrinkHistoryClient.self] }
        set { self[DrinkHistoryClient.self] = newValue }
    }
}
