//
//  DrinkWaterViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

@Observable
public final class DrinkWaterViewModel {
    private(set) var drinkWaterCount: Int
    private(set) var offset: CGFloat = 0
    
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

        Task {
            do {
                try await healthKitUseCase.drinkWater()
            } catch {
                print("Failed to log water to HealthKit: \(error)")
            }
        }
    }
    
    func reset() {
        drinkWaterCount = 0
        waterUseCase.reset()

        Task {
            do {
                try await healthKitUseCase.reset()
            } catch {
                print("Failed to reset HealthKit data: \(error)")
            }
        }
    }
    
    func startAnimation() {
        offset = 360
    }
}
