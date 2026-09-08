//
//  UserPreferencesDataSource.swift
//  AccountData
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import AccountDomain
import Foundation
import MulimiCloudKit
import Utils

public protocol UserPreferencesDataSource: Sendable {
    func getMainIcon() -> MainIcon
    func setMainIcon(_ icon: MainIcon)
    func getDailyWaterLimit() -> Double
    func setDailyWaterLimit(_ limit: Double)
    func hasCompletedOnboarding() -> Bool
    func setHasCompletedOnboarding(_ completed: Bool)
}

public final class UserPreferencesDataSourceImpl: UserPreferencesDataSource, @unchecked Sendable {
    private enum Constants {
        static let defaultDailyWaterLimit = 2000.0
    }

    private let userDefaults: UserDefaults
    private let syncedStore: SyncedValueStoring

    public init(
        userDefaults: UserDefaults,
        ubiquitousStore: NSUbiquitousKeyValueStore = .default
    ) {
        self.userDefaults = userDefaults
        self.syncedStore = UbiquitousMirroredStore(
            userDefaults: userDefaults,
            ubiquitousStore: ubiquitousStore
        )
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
        syncedStore.double(forKey: .dailyWaterLimit, default: Constants.defaultDailyWaterLimit)
    }

    public func setDailyWaterLimit(_ limit: Double) {
        syncedStore.setDouble(limit, forKey: .dailyWaterLimit)
    }

    // MARK: - Onboarding
    public func hasCompletedOnboarding() -> Bool {
        userDefaults.hasCompletedOnboarding
    }

    public func setHasCompletedOnboarding(_ completed: Bool) {
        userDefaults.hasCompletedOnboarding = completed
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

}
