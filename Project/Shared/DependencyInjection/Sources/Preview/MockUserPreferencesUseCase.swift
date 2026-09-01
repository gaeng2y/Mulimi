//
//  MockUserPreferencesUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import AccountDomain
import ChallengeDomain
import MulimiAnalytics
import HydrationDomain
import RoutineDomain

public final class MockUserPreferencesUseCase: UserPreferencesUseCase, @unchecked Sendable {
    private var mainIcon: MainIcon = .drop
    private var dailyWaterLimit: Double = 2000
    private var hasCompletedOnboarding = false
    private var accentColor: String = "blue"

    public init() {}

    public func getMainIcon() -> MainIcon {
        mainIcon
    }

    public func setMainIcon(_ appearance: MainIcon) {
        mainIcon = appearance
    }

    public func getDailyWaterLimit() -> Double {
        dailyWaterLimit
    }

    public func setDailyWaterLimit(_ limit: Double) {
        dailyWaterLimit = limit
    }

    public func hasCompletedOnboarding() -> Bool {
        hasCompletedOnboarding
    }

    public func setHasCompletedOnboarding(_ completed: Bool) {
        hasCompletedOnboarding = completed
    }

    public func getAccentColor() -> String {
        accentColor
    }

    public func setAccentColor(_ color: String) {
        accentColor = color
    }
}
