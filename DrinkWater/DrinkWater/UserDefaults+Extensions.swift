//
//  UserDefaults+.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/20.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.gaeng2y.drinkwater"
        return UserDefaults(suiteName: appGroupId)!
    }
}
