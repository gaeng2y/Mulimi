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

public protocol UserPreferencesDataSource {
    func getMainAppearance() -> MainAppearance
    func setMainAppearance(_ appearance: MainAppearance)
    func getDailyWaterLimit() -> Double
    func setDailyWaterLimit(_ limit: Double)
    func getAccentColor() -> String
    func setAccentColor(_ color: String)
}

public final class UserPreferencesDataSourceImpl: UserPreferencesDataSource {
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults = .appGroup) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - MainAppearance
    public func getMainAppearance() -> MainAppearance {
        switch userDefaults.mainAppearance {
        case "drop": .drop
        case "heart": .heart
        case "cloud": .cloud
        default: .drop
        }
    }
    
    public func setMainAppearance(_ appearance: MainAppearance) {
        let stringValue: String
        switch appearance {
        case .drop:
            stringValue = "drop"
        case .heart:
            stringValue = "heart"
        case .cloud:
            stringValue = "cloud"
        }
        userDefaults.mainAppearance = stringValue
    }
    
    // MARK: - Daily Water Limit
    public func getDailyWaterLimit() -> Double {
        let limit = userDefaults.double(forKey: "dailyWaterLimit")
        return limit == 0 ? 2000 : limit // Default 2000ml
    }
    
    public func setDailyWaterLimit(_ limit: Double) {
        userDefaults.set(limit, forKey: "dailyWaterLimit")
    }
    
    // MARK: - Accent Color
    public func getAccentColor() -> String {
        userDefaults.string(forKey: "appAccentColor") ?? "blue"
    }
    
    public func setAccentColor(_ color: String) {
        userDefaults.set(color, forKey: "appAccentColor")
    }
}
