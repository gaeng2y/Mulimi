//
//  DrinkWaterViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Combine
import DomainLayerInterface
import Foundation
import UIKit
import Utils
import WidgetKit

@Observable
public final class DrinkWaterViewModel {
    // MARK: - Published State
    private(set) var drinkWaterCount: Int
    private(set) var offset: CGFloat = 0
    private(set) var mainAppearance: MainAppearance
    
    private let waterUseCase: DrinkWaterUseCase
    private let healthKitUseCase: HealthKitUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var mililiters: String {
        String(format: "%.0fml", currentWaterIntakeInMl)
    }
    
    var currentWaterIntakeInMl: Double {
        Double(drinkWaterCount) * 250.0
    }
    
    var dailyLimit: Double {
        userPreferencesUseCase.getDailyWaterLimit()
    }
    
    var isLimitReached: Bool {
        currentWaterIntakeInMl >= dailyLimit
    }
    
    var progress: CGFloat {
        CGFloat(drinkWaterCount) * 0.125
    }
    
    public init(
        waterUseCase: DrinkWaterUseCase,
        healthKitUseCase: HealthKitUseCase,
        userPreferencesUseCase: UserPreferencesUseCase
    ) {
        self.waterUseCase = waterUseCase
        self.healthKitUseCase = healthKitUseCase
        self.userPreferencesUseCase = userPreferencesUseCase
        self.drinkWaterCount = waterUseCase.currentWater
        self.mainAppearance = userPreferencesUseCase.getMainAppearance()
        
        setupUserPreferencesObservation()
    }
    
    private func setupUserPreferencesObservation() {
        // Observe any UserDefaults changes, not just from specific instance
        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateMainAppearance()
                    self?.updateWaterCount()
                }
            }
            .store(in: &cancellables)
        
        // Also observe when app becomes active to catch Widget changes
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .sink { [weak self] _ in
                DispatchQueue.main.async {
                    self?.updateMainAppearance()
                    self?.updateWaterCount()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateMainAppearance() {
        let newAppearance = userPreferencesUseCase.getMainAppearance()
        if mainAppearance != newAppearance {
            mainAppearance = newAppearance
        }
    }
    
    private func updateWaterCount() {
        // Directly read from UserDefaults to ensure fresh data
        let newCount = UserDefaults.appGroup.glassesOfToday
        if drinkWaterCount != newCount {
            drinkWaterCount = newCount
        }
    }
    
    func drinkWater() {
        // Check if adding one more glass would exceed daily limit
        let nextIntake = currentWaterIntakeInMl + 250.0
        if nextIntake > dailyLimit {
            return // Do not allow drinking more than daily limit
        }
        
        drinkWaterCount += 1
        waterUseCase.drinkWater()
        
        // Reload Widget timeline
        WidgetCenter.shared.reloadAllTimelines()
        
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
        
        // Reload Widget timeline
        WidgetCenter.shared.reloadAllTimelines()
        
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
    
    public func refreshFromUserDefaults() {
        // Force refresh from UserDefaults
        updateMainAppearance()
        updateWaterCount()
    }
}
