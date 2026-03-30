//
//  MockUserPreferencesUseCaseForTesting.swift
//  DependencyInjectionTesting
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface

public final class MockUserPreferencesUseCaseForTesting: UserPreferencesUseCase, @unchecked Sendable {
    public var mainIcon: MainIcon = .drop
    public var dailyWaterLimit: Double = 2000
    public var manualBodyProfile: BodyProfile = .empty
    public var accentColor: String = "blue"

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

    public func getManualBodyProfile() -> BodyProfile {
        manualBodyProfile
    }

    public func setManualBodyProfile(_ profile: BodyProfile) {
        manualBodyProfile = profile
    }

    public func getAccentColor() -> String {
        accentColor
    }

    public func setAccentColor(_ color: String) {
        accentColor = color
    }
}
