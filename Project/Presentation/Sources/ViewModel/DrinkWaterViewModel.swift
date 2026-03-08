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
import WidgetKit

@MainActor
@Observable
public final class DrinkWaterViewModel {
    // MARK: - Published State
    private(set) var drinkWaterCount: Int
    private(set) var offset: CGFloat = 0
    private(set) var mainAppearance: MainAppearance
    private(set) var currentDailyLimit: Double
    
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
        currentDailyLimit
    }
    
    var isLimitReached: Bool {
        currentWaterIntakeInMl.rounded() >= dailyLimit.rounded()
    }
    
    var progress: CGFloat {
        let maxProgress = currentDailyLimit / 250.0  // 목표량을 잔수로 변환
        return min(CGFloat(drinkWaterCount) / CGFloat(maxProgress), 1.0)
    }
    
    public init(
        waterUseCase: DrinkWaterUseCase,
        healthKitUseCase: HealthKitUseCase,
        userPreferencesUseCase: UserPreferencesUseCase
    ) {
        self.waterUseCase = waterUseCase
        self.healthKitUseCase = healthKitUseCase
        self.userPreferencesUseCase = userPreferencesUseCase

        waterUseCase.migrateLegacyDataIfNeeded()
        self.drinkWaterCount = waterUseCase.currentWater
        self.mainAppearance = userPreferencesUseCase.getMainAppearance()
        self.currentDailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        
        setupUserPreferencesObservation()
    }
    
    private func setupUserPreferencesObservation() {
        // Observe any UserDefaults changes, not just from specific instance
        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.refreshFromUserDefaults()
            }
            .store(in: &cancellables)
        
        // Also observe when app becomes active to catch Widget changes
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.refreshFromUserDefaults()
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
        let newCount = waterUseCase.currentWater
        if drinkWaterCount != newCount {
            drinkWaterCount = newCount
        }
    }

    private func updateDailyLimit() {
        let newLimit = userPreferencesUseCase.getDailyWaterLimit()
        if currentDailyLimit != newLimit {
            currentDailyLimit = newLimit
        }
    }
    
    func drinkWater() async {
        // Check if adding one more glass would exceed daily limit
        let nextIntake = currentWaterIntakeInMl + 250.0

        // Use rounded comparison to avoid floating point precision issues
        if nextIntake.rounded() > dailyLimit.rounded() {
            return // Do not allow drinking more than daily limit
        }
        
        drinkWaterCount += 1
        waterUseCase.drinkWater()
        
        // Reload Widget timeline
        WidgetCenter.shared.reloadAllTimelines()
        
        do {
            try await healthKitUseCase.drinkWater()
        } catch {
            print("Failed to log water to HealthKit: \(error)")
        }
    }
    
    func reset() async {
        drinkWaterCount = 0
        waterUseCase.reset()
        
        // Reload Widget timeline
        WidgetCenter.shared.reloadAllTimelines()
        
        do {
            try await healthKitUseCase.reset()
        } catch {
            print("Failed to reset HealthKit data: \(error)")
        }
    }
    
    func startAnimation() {
        offset = 360
    }
    
    public func refreshState() {
        // Refresh from persistence and user preferences.
        updateMainAppearance()
        updateWaterCount()
        updateDailyLimit()
    }

    public func refreshFromUserDefaults() {
        refreshState()
    }
}
