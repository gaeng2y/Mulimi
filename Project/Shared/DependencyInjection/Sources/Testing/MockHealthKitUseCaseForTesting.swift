//
//  MockHealthKitUseCaseForTesting.swift
//  DependencyInjectionTesting
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockHealthKitUseCaseForTesting: HealthKitUseCase {
    public var requestAuthorizationResult: HealthKitAuthorizationStatus = .authorized
    public var shouldThrowError = false
    public var fetchRecordsResult: [HydrationRecord] = []

    public var drinkWaterCallCount = 0
    public var resetCallCount = 0
    public var requestAuthorizationCallCount = 0
    public var fetchRecordsCallCount = 0

    public init() {}

    public func requestAuthorization() async throws -> HealthKitAuthorizationStatus {
        requestAuthorizationCallCount += 1

        if shouldThrowError {
            throw HealthKitError.authorizationDenied
        }

        return requestAuthorizationResult
    }

    public func drinkWater() {
        drinkWaterCallCount += 1
    }

    public func reset() {
        resetCallCount += 1
    }

    public func fetchRecords() async throws -> [HydrationRecord] {
        fetchRecordsCallCount += 1

        if shouldThrowError {
            throw HealthKitError.dataNotAvailable
        }

        return fetchRecordsResult
    }

    // Testing helpers
    public func setFetchRecordsResult(_ records: [HydrationRecord]) {
        fetchRecordsResult = records
    }

    public func setShouldThrowError(_ shouldThrow: Bool) {
        shouldThrowError = shouldThrow
    }
}