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
    
    // Call tracking properties
    private(set) var requestAuthorizationCallCount = 0
    private(set) var drinkWaterCallCount = 0
    private(set) var resetCallCount = 0
    
    // Error simulation properties
    var shouldThrowAuthorizationError = false
    var shouldThrowDrinkWaterError = false
    var shouldThrowResetError = false
    var authorizationErrorToThrow: HealthKitError = .permissionDenied
    var drinkWaterErrorToThrow: HealthKitError = .healthKitInternalError
    var resetErrorToThrow: HealthKitError = .healthKitInternalError
    
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
    
    // MARK: - Test Helper Methods
    
    func setAuthorizationStatus(_ status: HealthKitAuthorizationStatus) {
        _authorizationStatus = status
    }
    
    func resetCallCounts() {
        requestAuthorizationCallCount = 0
        drinkWaterCallCount = 0
        resetCallCount = 0
    }
    
    func resetErrorFlags() {
        shouldThrowAuthorizationError = false
        shouldThrowDrinkWaterError = false
        shouldThrowResetError = false
    }
    
    func simulateAuthorizationDenied() {
        _authorizationStatus = .sharingDenied
    }
    
    func simulateAuthorizationSuccess() {
        _authorizationStatus = .sharingAuthorized
    }
}