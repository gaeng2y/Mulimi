//
//  MockHealthKitUseCaseForTesting.swift
//  DependencyInjectionTesting
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockHealthKitUseCaseForTesting: HealthKitUseCase, @unchecked Sendable {
    public var authorisationStatus: HealthKitAuthorizationStatus = .sharingAuthorized
    public var shouldThrowError = false
    public var fetchHistoryResult: [HydrationRecord] = []

    public var drinkWaterCallCount = 0
    public var resetCallCount = 0
    public var requestAuthorizationCallCount = 0
    public var fetchHistoryCallCount = 0

    public init() {}

    public func requestAuthorization() async throws {
        requestAuthorizationCallCount += 1

        if shouldThrowError {
            throw HealthKitError.permissionDenied
        }
        authorisationStatus = .sharingAuthorized
    }

    public func drinkWater() async throws {
        drinkWaterCallCount += 1
    }

    public func reset() async throws {
        resetCallCount += 1
    }

    public func fetchHistory(from startDate: Date, to endDate: Date) async throws -> [HydrationRecord] {
        fetchHistoryCallCount += 1

        if shouldThrowError {
            throw HealthKitError.healthKitInternalError
        }

        return fetchHistoryResult
    }

    // Testing helpers
    public func setFetchHistoryResult(_ records: [HydrationRecord]) {
        fetchHistoryResult = records
    }

    public func setShouldThrowError(_ shouldThrow: Bool) {
        shouldThrowError = shouldThrow
    }
}
