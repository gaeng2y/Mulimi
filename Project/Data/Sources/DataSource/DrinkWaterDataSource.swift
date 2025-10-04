//
//  DrinkWaterDataSource.swift
//  DataLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation
import Utils

public protocol DrinkWaterDataSource {
    var currentWater: Int { get }
    
    func drinkWater()
    func reset()
}

public struct DrinkWaterUserDefaultsDataSource: DrinkWaterDataSource {
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public var currentWater: Int {
        userDefaults.glassesOfToday
    }
    
    public func drinkWater() {
        userDefaults.glassesOfToday += 1
        userDefaults.synchronize()
    }

    public func reset() {
        userDefaults.glassesOfToday = .zero
        userDefaults.synchronize()
    }
}
