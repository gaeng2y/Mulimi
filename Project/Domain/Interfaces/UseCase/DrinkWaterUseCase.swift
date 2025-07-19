//
//  DrinkWaterUseCase.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol DrinkWaterUseCase {
    var currentWater: Int { get }
    
    func drinkWater()
    func reset()
}
