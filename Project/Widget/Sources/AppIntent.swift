//
//  AppIntent.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//

import WidgetKit
import AppIntents
import Utils
import HealthKit
import DependencyInjection
import DomainLayerInterface

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Configuration"
    static let description = IntentDescription("This is an example widget.")
    
    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
    
    public func perform() async throws -> some IntentResult {
        let userPreferencesUseCase = DIContainer.shared.resolve(UserPreferencesUseCase.self)
        let healthKitUseCase = DIContainer.shared.resolve(HealthKitUseCase.self)
        
        let userDefaults = UserDefaults.appGroup
        let currentGlasses = userDefaults.glassesOfToday
        let currentMl = Double(currentGlasses * 250)
        
        // Get daily limit from UseCase
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        
        // Check if adding one more glass would exceed daily limit
        let nextMl = currentMl + 250.0
        if nextMl <= dailyLimit {
            userDefaults.glassesOfToday += 1
            userDefaults.synchronize() // Force synchronization
            
            // Log to HealthKit via UseCase
            do {
                try await healthKitUseCase.drinkWater()
            } catch {
                // Silent fail - Widget should not show errors to user
                print("Failed to log water to HealthKit from Widget: \(error)")
            }
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
