//
//  UserDefaults+.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/20.
//

import Foundation

public extension UserDefaults {
    static var appGroup: UserDefaults {
        guard let appGroupUserDefaults = UserDefaults(suiteName: .appGroupId) else {
            fatalError("Undefined App Group, Please check capabilities")
        }
        return appGroupUserDefaults
    }

    @objc dynamic var glassesOfToday: Int {
        get { self.integer(forKey: .glassesOfToday) }
        set { self.set(newValue, forKey: .glassesOfToday) }
    }

    @objc dynamic var mainIcon: String {
        get {
            self.string(forKey: .mainIcon)
            ?? self.string(forKey: .legacyMainAppearance)
            ?? "drop"
        }
        set { self.set(newValue, forKey: .mainIcon) }
    }

    @objc dynamic var dailyLimit: Double {
        get { self.double(forKey: .dailyWaterLimit) }
        set { self.set(newValue, forKey: .dailyWaterLimit) }
    }

    @objc dynamic var hasCompletedOnboarding: Bool {
        get { self.bool(forKey: .hasCompletedOnboarding) }
        set { self.set(newValue, forKey: .hasCompletedOnboarding) }
    }

    @objc dynamic var manualBodyHeightCM: Double {
        get { self.double(forKey: .manualBodyHeightCM) }
        set { self.set(newValue, forKey: .manualBodyHeightCM) }
    }

    @objc dynamic var manualBodyWeightKG: Double {
        get { self.double(forKey: .manualBodyWeightKG) }
        set { self.set(newValue, forKey: .manualBodyWeightKG) }
    }
}
