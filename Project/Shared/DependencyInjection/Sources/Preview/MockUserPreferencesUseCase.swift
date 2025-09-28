//
//  MockUserPreferencesUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface

public final class MockUserPreferencesUseCase: UserPreferencesUseCase {
    private var mainAppearance: MainAppearance = .drop
    private var dailyWaterLimit: Double = 2000
    private var accentColor: String = "blue"

    public init() {}

    public func getMainAppearance() -> MainAppearance {
        mainAppearance
    }

    public func setMainAppearance(_ appearance: MainAppearance) {
        mainAppearance = appearance
    }

    public func getDailyWaterLimit() -> Double {
        dailyWaterLimit
    }

    public func setDailyWaterLimit(_ limit: Double) {
        dailyWaterLimit = limit
    }

    public func getAccentColor() -> String {
        accentColor
    }

    public func setAccentColor(_ color: String) {
        accentColor = color
    }
}