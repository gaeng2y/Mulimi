//
//  MockHealthKitRepository.swift
//  DomainLayerTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

final class MockHealthKitRepository: HealthKitRepository {
    private var _authorizationStatus: HealthKitAuthorizationStatus = .notDetermined
    private var _hydrationRecords: [HydrationRecord] = []

    // Call tracking properties
    private(set) var requestAuthorizationCallCount = 0
    private(set) var drinkWaterCallCount = 0
    private(set) var resetCallCount = 0
    private(set) var fetchHistoryCallCount = 0

    // Error simulation properties
    var shouldThrowAuthorizationError = false
    var shouldThrowDrinkWaterError = false
    var shouldThrowResetError = false
    var shouldThrowFetchHistoryError = false
    var authorizationErrorToThrow: HealthKitError = .permissionDenied
    var drinkWaterErrorToThrow: HealthKitError = .healthKitInternalError
    var resetErrorToThrow: HealthKitError = .healthKitInternalError
    var fetchHistoryErrorToThrow: HealthKitError = .healthKitInternalError

    // Captured parameters for verification
    private(set) var capturedStartDate: Date?
    private(set) var capturedEndDate: Date?
    
    var authorisationStatus: HealthKitAuthorizationStatus {
        _authorizationStatus
    }
    
    func requestAuthorization() async throws {
        requestAuthorizationCallCount += 1
        
        if shouldThrowAuthorizationError {
            throw authorizationErrorToThrow
        }
        
        // 성공 시 권한 상태를 변경
        _authorizationStatus = .sharingAuthorized
    }
    
    func drinkWater() async throws {
        drinkWaterCallCount += 1
        
        if shouldThrowDrinkWaterError {
            throw drinkWaterErrorToThrow
        }
        
        // 권한이 없으면 에러 발생
        if _authorizationStatus != .sharingAuthorized {
            throw HealthKitError.permissionDenied
        }
    }
    
    func reset() async throws {
        resetCallCount += 1

        if shouldThrowResetError {
            throw resetErrorToThrow
        }

        // 권한이 없으면 에러 발생
        if _authorizationStatus != .sharingAuthorized {
            throw HealthKitError.permissionDenied
        }
    }

    func fetchHistory(from startDate: Date, to endDate: Date) async throws -> [HydrationRecord] {
        fetchHistoryCallCount += 1
        capturedStartDate = startDate
        capturedEndDate = endDate

        if shouldThrowFetchHistoryError {
            throw fetchHistoryErrorToThrow
        }

        // 권한이 없으면 에러 발생
        if _authorizationStatus != .sharingAuthorized {
            throw HealthKitError.permissionDenied
        }

        // 날짜 범위 내의 기록만 필터링하여 반환
        return _hydrationRecords.filter { record in
            record.date >= startDate && record.date <= endDate
        }.sorted { $0.date < $1.date }
    }

    // MARK: - Test Helper Methods
    
    func setAuthorizationStatus(_ status: HealthKitAuthorizationStatus) {
        _authorizationStatus = status
    }
    
    func resetCallCounts() {
        requestAuthorizationCallCount = 0
        drinkWaterCallCount = 0
        resetCallCount = 0
        fetchHistoryCallCount = 0
    }

    func resetErrorFlags() {
        shouldThrowAuthorizationError = false
        shouldThrowDrinkWaterError = false
        shouldThrowResetError = false
        shouldThrowFetchHistoryError = false
    }

    func resetCapturedValues() {
        capturedStartDate = nil
        capturedEndDate = nil
    }

    func simulateAuthorizationDenied() {
        _authorizationStatus = .sharingDenied
    }

    func simulateAuthorizationSuccess() {
        _authorizationStatus = .sharingAuthorized
    }

    func setHydrationRecords(_ records: [HydrationRecord]) {
        _hydrationRecords = records
    }

    func addHydrationRecord(_ record: HydrationRecord) {
        _hydrationRecords.append(record)
    }

    func clearHydrationRecords() {
        _hydrationRecords.removeAll()
    }
}