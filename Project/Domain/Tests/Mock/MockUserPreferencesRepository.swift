//
//  MockUserPreferencesRepository.swift
//  DomainLayerTests
//
//  Created by Kyeongmo Yang on 7/25/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface

final class MockUserPreferencesRepository: UserPreferencesRepository, @unchecked Sendable {
    private var _mainAppearance: MainAppearance = .default
    private var _dailyWaterLimit: Double = 2000.0

    // Call tracking properties
    private(set) var getMainAppearanceCallCount = 0
    private(set) var setMainAppearanceCallCount = 0
    private(set) var getDailyWaterLimitCallCount = 0
    private(set) var setDailyWaterLimitCallCount = 0

    // Captured values for verification
    private(set) var capturedMainAppearance: MainAppearance?
    private(set) var capturedDailyWaterLimit: Double?

    func getMainAppearance() -> MainAppearance {
        getMainAppearanceCallCount += 1
        return _mainAppearance
    }

    func setMainAppearance(_ appearance: MainAppearance) {
        setMainAppearanceCallCount += 1
        capturedMainAppearance = appearance
        _mainAppearance = appearance
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
        getMainAppearanceCallCount = 0
        setMainAppearanceCallCount = 0
        getDailyWaterLimitCallCount = 0
        setDailyWaterLimitCallCount = 0
    }

    func resetCapturedValues() {
        capturedMainAppearance = nil
        capturedDailyWaterLimit = nil
    }

    func resetToDefaults() {
        _mainAppearance = .default
        _dailyWaterLimit = 2000.0
        resetCallCounts()
        resetCapturedValues()
    }
}
