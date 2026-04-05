//
//  UserPreferencesRepository.swift
//  DomainLayerInterface
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol UserPreferencesRepository: Sendable {
    func getMainIcon() -> MainIcon
    func setMainIcon(_ icon: MainIcon)
    func getDailyWaterLimit() -> Double
    func setDailyWaterLimit(_ limit: Double)
    func hasCompletedOnboarding() -> Bool
    func setHasCompletedOnboarding(_ completed: Bool)
    func getManualBodyProfile() -> BodyProfile
    func setManualBodyProfile(_ profile: BodyProfile)
}
