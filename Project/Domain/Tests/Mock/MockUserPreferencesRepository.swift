//
//  MockUserPreferencesRepository.swift
//  DomainLayerTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface

final class MockUserPreferencesRepository: UserPreferencesRepository, @unchecked Sendable {
    private var _mainIcon: MainIcon = .default
    private var _dailyWaterLimit: Double = 2000.0

    // Call tracking properties
    private(set) var getMainIconCallCount = 0
    private(set) var setMainIconCallCount = 0
    private(set) var getDailyWaterLimitCallCount = 0
    private(set) var setDailyWaterLimitCallCount = 0

    // Captured values for verification
    private(set) var capturedMainIcon: MainIcon?
    private(set) var capturedDailyWaterLimit: Double?

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

    // MARK: - Test Helper Methods

    func resetCallCounts() {
        getMainIconCallCount = 0
        setMainIconCallCount = 0
        getDailyWaterLimitCallCount = 0
        setDailyWaterLimitCallCount = 0
    }

    func resetCapturedValues() {
        capturedMainIcon = nil
        capturedDailyWaterLimit = nil
    }

    func resetToDefaults() {
        _mainIcon = .default
        _dailyWaterLimit = 2000.0
        resetCallCounts()
        resetCapturedValues()
    }
}
