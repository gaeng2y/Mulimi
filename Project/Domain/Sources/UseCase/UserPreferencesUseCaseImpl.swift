//
//  UserPreferencesUseCaseImpl.swift
//  DomainLayer
//
//  Created by Assistant on 2025-09-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface

public struct UserPreferencesUseCaseImpl: UserPreferencesUseCase {
    private let repository: UserPreferencesRepository

    public init(repository: UserPreferencesRepository) {
        self.repository = repository
    }

    public func getMainIcon() -> MainIcon {
        repository.getMainIcon()
    }

    public func setMainIcon(_ icon: MainIcon) {
        repository.setMainIcon(icon)
    }

    public func getDailyWaterLimit() -> Double {
        repository.getDailyWaterLimit()
    }

    public func setDailyWaterLimit(_ limit: Double) {
        repository.setDailyWaterLimit(limit)
    }

    public func getManualBodyProfile() -> BodyProfile {
        repository.getManualBodyProfile()
    }

    public func setManualBodyProfile(_ profile: BodyProfile) {
        repository.setManualBodyProfile(profile)
    }
}
