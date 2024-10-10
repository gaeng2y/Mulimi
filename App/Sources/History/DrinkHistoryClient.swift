//
//  DrinkHistoryClient.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import ComposableArchitecture
import HealthKit

@DependencyClient
struct DrinkHistoryClient {
    var requestAuthorization: @Sendable () async throws -> Void
    var authroization: @Sendable () -> HealthKitAuthorizationStatus = { .notDetermined }
    var histories: @Sendable (Date, Date) async throws -> [History] = { _, _  in [] }
}

extension DrinkHistoryClient: TestDependencyKey {
    static var previewValue = Self(
        requestAuthorization: { },
        authroization: { .sharingAuthorized },
        histories: { _, _ in [] }
    )
}

extension DrinkHistoryClient: DependencyKey {
    private static let healthStore = HealthKitStore()
    
    static let liveValue = Self(
        requestAuthorization: {
            try await healthStore.requestAuthorization()
        },
        authroization: {
            healthStore.healthKitAuthorizationStatus
        },
        histories: { startDate, endDate in
            return try await healthStore.readWaterIntake(from: startDate, to: endDate)
                .map(History.init)
        }
    )
}

extension DependencyValues {
    var drinkHistoryClient: DrinkHistoryClient {
        get { self[DrinkHistoryClient.self] }
        set { self[DrinkHistoryClient.self] = newValue }
    }
}
