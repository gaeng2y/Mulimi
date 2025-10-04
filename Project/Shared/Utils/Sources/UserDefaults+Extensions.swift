//
//  UserDefaults+.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/20.
//

import Foundation

public extension UserDefaults {
    static let appGroup: UserDefaults = {
        guard let appGroupUserDefaults = UserDefaults(suiteName: .appGroupId) else {
            fatalError("Undefined App Group, Please check capabilities")
        }
        return appGroupUserDefaults
    }()
    
    @objc dynamic var glassesOfToday: Int {
        get { self.integer(forKey: .glassesOfToday) }
        set { self.set(newValue, forKey: .glassesOfToday) }
    }

    @objc dynamic var mainAppearance: String {
        get { self.string(forKey: .mainAppearance) ?? "drop" }
        set { self.set(newValue, forKey: .mainAppearance) }
    }

    @objc dynamic var dailyLimit: Double {
        get { self.double(forKey: .dailyWaterLimit) }
        set { self.set(newValue, forKey: .dailyWaterLimit) }
    }
}
