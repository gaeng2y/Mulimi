//
//  UserPreferencesRepository.swift
//  DomainLayerInterface
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol UserPreferencesRepository {
    func getMainAppearance() -> MainAppearance
    func setMainAppearance(_ appearance: MainAppearance)
    func getDailyWaterLimit() -> Double
    func setDailyWaterLimit(_ limit: Double)
}