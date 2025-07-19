//
//  DrinkWaterViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Combine
import Foundation

public final class DrinkWaterViewModel: ObservableObject {
    @Published private(set) var drinkWaterCount: Int
    @Published private(set) var offset: CGFloat = 0
    
    private let waterUseCase: DrinkWaterUseCase
    private let healthKitUseCase: HealthKitUseCase
    
    var mililiters: String {
        String(format: "%.0fml", Double(drinkWaterCount) * 250.0)
    }
    
    var progress: CGFloat {
        CGFloat(drinkWaterCount) * 0.125
    }
    
    public init(
        waterUseCase: DrinkWaterUseCase,
        healthKitUseCase: HealthKitUseCase
    ) {
        self.waterUseCase = waterUseCase
        self.healthKitUseCase = healthKitUseCase
        self.drinkWaterCount = waterUseCase.currentWater
    }
    
    func drinkWater() {
        drinkWaterCount += 1
        waterUseCase.drinkWater()
//        healthKitUseCase.drinkWater()
    }
    
    func reset() {
        drinkWaterCount = 0
        waterUseCase.drinkWater()
//        healthKitUseCase.reset()
    }
    
    func startAnimation() {
        offset = 360
    }
}
