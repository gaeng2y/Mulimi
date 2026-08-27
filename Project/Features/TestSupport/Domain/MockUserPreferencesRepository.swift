//
//  MockUserPreferencesRepository.swift
//  FeatureDomainTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import AccountDomain

final class MockUserPreferencesRepository: UserPreferencesRepository, @unchecked Sendable {
    private var _mainIcon: MainIcon = .default
    private var _dailyWaterLimit: Double = 2000.0
    private var _hasCompletedOnboarding = false

    // Call tracking properties
    private(set) var getMainIconCallCount = 0
    private(set) var setMainIconCallCount = 0
    private(set) var getDailyWaterLimitCallCount = 0
    private(set) var setDailyWaterLimitCallCount = 0
    private(set) var hasCompletedOnboardingCallCount = 0
    private(set) var setHasCompletedOnboardingCallCount = 0

    // Captured values for verification
    private(set) var capturedMainIcon: MainIcon?
    private(set) var capturedDailyWaterLimit: Double?
    private(set) var capturedHasCompletedOnboarding: Bool?

    func getMainIcon() -> MainIcon {
        getMainIconCallCount += 1
        return _mainIcon
    }

    func setMainIcon(_ icon: MainIcon) {
        setMainIconCallCount += 1
        capturedMainIcon = icon
        _mainIcon = icon
    }

    func getDailyWaterLimit() -> Double {
        getDailyWaterLimitCallCount += 1
        return _dailyWaterLimit
    }

    func setDailyWaterLimit(_ limit: Double) {
        setDailyWaterLimitCallCount += 1
        capturedDailyWaterLimit = limit
        _dailyWaterLimit = limit
    }

    func hasCompletedOnboarding() -> Bool {
        hasCompletedOnboardingCallCount += 1
        return _hasCompletedOnboarding
    }

    func setHasCompletedOnboarding(_ completed: Bool) {
        setHasCompletedOnboardingCallCount += 1
        capturedHasCompletedOnboarding = completed
        _hasCompletedOnboarding = completed
    }

    // MARK: - Test Helper Methods

    func resetCallCounts() {
        getMainIconCallCount = 0
        setMainIconCallCount = 0
        getDailyWaterLimitCallCount = 0
        setDailyWaterLimitCallCount = 0
        hasCompletedOnboardingCallCount = 0
        setHasCompletedOnboardingCallCount = 0
    }

    func resetCapturedValues() {
        capturedMainIcon = nil
        capturedDailyWaterLimit = nil
        capturedHasCompletedOnboarding = nil
    }

    func resetToDefaults() {
        _mainIcon = .default
        _dailyWaterLimit = 2000.0
        _hasCompletedOnboarding = false
        resetCallCounts()
        resetCapturedValues()
    }
}
