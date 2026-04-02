//
//  UserPreferencesDataSource.swift
//  DataLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation
import Utils

public protocol UserPreferencesDataSource: Sendable {
    func getMainIcon() -> MainIcon
    func setMainIcon(_ icon: MainIcon)
    func getDailyWaterLimit() -> Double
    func setDailyWaterLimit(_ limit: Double)
    func hasCompletedOnboarding() -> Bool
    func setHasCompletedOnboarding(_ completed: Bool)
    func getManualBodyProfile() -> BodyProfile
    func setManualBodyProfile(_ profile: BodyProfile)
}

public final class UserPreferencesDataSourceImpl: UserPreferencesDataSource, @unchecked Sendable {
    private enum Constants {
        static let defaultDailyWaterLimit = 2000.0
    }

    private let userDefaults: UserDefaults
    private let ubiquitousStore: NSUbiquitousKeyValueStore

    public init(
        userDefaults: UserDefaults,
        ubiquitousStore: NSUbiquitousKeyValueStore = .default
    ) {
        self.userDefaults = userDefaults
        self.ubiquitousStore = ubiquitousStore
    }
    
    // MARK: - MainIcon
    public func getMainIcon() -> MainIcon {
        let storedValue = userDefaults.mainIcon
        migrateLegacyMainIconIfNeeded(currentValue: storedValue)

        return switch userDefaults.mainIcon {
        case "drop": .drop
        case "heart": .heart
        case "cloud": .cloud
        default: .drop
        }
    }
    
    public func setMainIcon(_ icon: MainIcon) {
        let stringValue: String
        switch icon {
        case .drop:
            stringValue = "drop"
        case .heart:
            stringValue = "heart"
        case .cloud:
            stringValue = "cloud"
        }
        userDefaults.mainIcon = stringValue
        userDefaults.removeObject(forKey: .legacyMainAppearance)
        userDefaults.synchronize()
    }
    
    // MARK: - Daily Water Limit
    public func getDailyWaterLimit() -> Double {
        ubiquitousStore.synchronize()

        let localValue = userDefaults.dailyLimit
        let syncedValue = ubiquitousStore.double(forKey: .dailyWaterLimit)

        if syncedValue > 0 {
            if localValue != syncedValue {
                userDefaults.dailyLimit = syncedValue
                userDefaults.synchronize()
            }
            return syncedValue
        }

        if localValue > 0 {
            ubiquitousStore.set(localValue, forKey: .dailyWaterLimit)
            ubiquitousStore.synchronize()
            return localValue
        }

        return Constants.defaultDailyWaterLimit
    }

    public func setDailyWaterLimit(_ limit: Double) {
        userDefaults.dailyLimit = limit
        userDefaults.synchronize()
        ubiquitousStore.set(limit, forKey: .dailyWaterLimit)
        ubiquitousStore.synchronize()
    }

    // MARK: - Onboarding
    public func hasCompletedOnboarding() -> Bool {
        userDefaults.hasCompletedOnboarding
    }

    public func setHasCompletedOnboarding(_ completed: Bool) {
        userDefaults.hasCompletedOnboarding = completed
        userDefaults.synchronize()
    }

    // MARK: - Manual Body Profile
    public func getManualBodyProfile() -> BodyProfile {
        let heightValue = userDefaults.object(forKey: .manualBodyHeightCM) as? Double
        let weightValue = userDefaults.object(forKey: .manualBodyWeightKG) as? Double

        return BodyProfile(
            heightCM: sanitizedValue(heightValue).map {
                BodyProfileValue(value: $0, source: .manual)
            },
            weightKG: sanitizedValue(weightValue).map {
                BodyProfileValue(value: $0, source: .manual)
            }
        )
    }

    public func setManualBodyProfile(_ profile: BodyProfile) {
        store(profile.heightCM?.value, forKey: .manualBodyHeightCM)
        store(profile.weightKG?.value, forKey: .manualBodyWeightKG)
        userDefaults.synchronize()
    }

    private func migrateLegacyMainIconIfNeeded(currentValue: String) {
        guard userDefaults.object(forKey: .mainIcon) == nil,
              userDefaults.object(forKey: .legacyMainAppearance) != nil else {
            return
        }

        userDefaults.mainIcon = currentValue
        userDefaults.removeObject(forKey: .legacyMainAppearance)
        userDefaults.synchronize()
    }

    private func store(_ value: Double?, forKey key: String) {
        guard let value = sanitizedValue(value) else {
            userDefaults.removeObject(forKey: key)
            return
        }

        userDefaults.set(value, forKey: key)
    }

    private func sanitizedValue(_ value: Double?) -> Double? {
        guard let value, value > 0 else {
            return nil
        }

        return value
    }
}
