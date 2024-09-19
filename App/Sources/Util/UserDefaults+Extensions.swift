//
//  UserDefaults+.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/20.
//

import Foundation

extension UserDefaults {
    @objc dynamic var glassesOfToday: Int {
        get { UserDefaults.appGroup.integer(forKey: .glassesOfToday) }
        set { UserDefaults.appGroup.set(newValue, forKey: .glassesOfToday) }
    }
    
    static let appGroup: UserDefaults = {
        guard let appGroupUserDefaults = UserDefaults(suiteName: .appGroupId) else {
            fatalError("Undefined App Group, Please check capabilities")
        }
        return appGroupUserDefaults
    }()
}
