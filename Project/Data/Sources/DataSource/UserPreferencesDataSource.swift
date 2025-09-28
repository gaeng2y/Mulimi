//
//  UserPreferencesDataSource.swift
//  DataLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

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
    
    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - MainAppearance
    public func getMainAppearance() -> MainAppearance {
        let storedValue = userDefaults.string(forKey: "mainScreenAppearance") ?? "drop"
        
        switch storedValue {
        case "drop":
            return .drop
        case "heart":
            return .heart
        case "cloud":
            return .cloud
        default:
            return .drop
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
        userDefaults.set(stringValue, forKey: "mainScreenAppearance")
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
