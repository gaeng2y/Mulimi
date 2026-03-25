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
import Localization
import UIKit
import WidgetKit

@MainActor
@Observable
public final class DrinkWaterViewModel {
    // MARK: - Published State
    private(set) var drinkWaterCount: Int
    private(set) var offset: CGFloat = 0
    private(set) var mainIcon: MainIcon
    private(set) var currentDailyLimit: Double
    private(set) var healthKitAuthorizationStatus: HealthKitAuthorizationStatus
    var showHealthKitPermissionAlert = false
    
    private let waterUseCase: DrinkWaterUseCase
    private let healthKitUseCase: HealthKitUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var mililiters: String {
        L10n.tr("commonMilliliterFormat", Int(currentWaterIntakeInMl.rounded()))
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

        self.drinkWaterCount = 0
        self.mainIcon = userPreferencesUseCase.getMainIcon()
        self.currentDailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        self.healthKitAuthorizationStatus = healthKitUseCase.authorisationStatus
        
        setupUserPreferencesObservation()
    }
    
    private func setupUserPreferencesObservation() {
        // Observe any UserDefaults changes, not just from specific instance
        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in
                    await self?.refreshState()
                }
            }
            .store(in: &cancellables)
        
        // Also observe when app becomes active to catch Widget changes
        NotificationCenter.default
            .publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                Task { @MainActor [weak self] in
                    await self?.refreshState()
                }
            }
            .store(in: &cancellables)
    }
    
    private func updateMainIcon() {
        let newAppearance = userPreferencesUseCase.getMainIcon()
        if mainIcon != newAppearance {
            mainIcon = newAppearance
        }
    }
    
    private func updateWaterCount() async {
        let newCount = await waterUseCase.currentWater
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

    private func updateHealthKitAuthorizationStatus() {
        let newStatus = healthKitUseCase.authorisationStatus
        if healthKitAuthorizationStatus != newStatus {
            healthKitAuthorizationStatus = newStatus
        }
    }

    private func ensureHealthKitAuthorization() async -> Bool {
        updateHealthKitAuthorizationStatus()

        switch healthKitAuthorizationStatus {
        case .sharingAuthorized:
            showHealthKitPermissionAlert = false
            return true
        case .notDetermined:
            do {
                try await healthKitUseCase.requestAuthorization()
            } catch {
                updateHealthKitAuthorizationStatus()
                showHealthKitPermissionAlert = true
                return false
            }

            updateHealthKitAuthorizationStatus()
            let isAuthorized = healthKitAuthorizationStatus == .sharingAuthorized
            showHealthKitPermissionAlert = !isAuthorized
            return isAuthorized
        case .sharingDenied:
            showHealthKitPermissionAlert = true
            return false
        }
    }
    
    public func loadInitialState() async {
        await waterUseCase.migrateLegacyDataIfNeeded()
        await refreshState()
    }

    func drinkWater() async {
        guard await ensureHealthKitAuthorization() else {
            return
        }

        // Check if adding one more glass would exceed daily limit
        let nextIntake = currentWaterIntakeInMl + 250.0

        // Use rounded comparison to avoid floating point precision issues
        if nextIntake.rounded() > dailyLimit.rounded() {
            return // Do not allow drinking more than daily limit
        }
        
        await waterUseCase.drinkWater()
        await refreshState()
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func reset() async {
        guard await ensureHealthKitAuthorization() else {
            return
        }

        await waterUseCase.reset()
        await refreshState()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func resetAnimation() {
        offset = 0
    }
    
    func startAnimation() {
        offset = 360
    }

    func dismissHealthKitPermissionAlert() {
        showHealthKitPermissionAlert = false
    }
    
    public func refreshState() async {
        // Refresh from persistence and user preferences.
        updateMainIcon()
        await updateWaterCount()
        updateDailyLimit()
        updateHealthKitAuthorizationStatus()
    }
}
