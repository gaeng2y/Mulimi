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

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")
    
    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
    
    public func perform() async throws -> some IntentResult {
        let userDefaults = UserDefaults.appGroup
        let currentGlasses = userDefaults.glassesOfToday
        let currentMl = Double(currentGlasses * 250)
        
        // Get daily limit
        let dailyLimit = userDefaults.dailyLimit
        let limit = dailyLimit == 0 ? 2000 : dailyLimit
        
        // Check if adding one more glass would exceed daily limit
        let nextMl = currentMl + 250.0
        if nextMl <= limit {
            userDefaults.glassesOfToday += 1
            userDefaults.synchronize() // Force synchronization
            
            // Log to HealthKit
            await logWaterToHealthKit()
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
    
    private func logWaterToHealthKit() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let healthStore = HKHealthStore()
        let waterType = HKQuantityType(.dietaryWater)
        let waterQuantity = HKQuantity(unit: HKUnit.literUnit(with: .milli), doubleValue: 250.0)
        
        let waterSample = HKQuantitySample(
            type: waterType,
            quantity: waterQuantity,
            start: Date(),
            end: Date()
        )
        
        do {
            try await healthStore.save(waterSample)
        } catch {
            // Silent fail - Widget should not show errors to user
            print("Failed to log water to HealthKit from Widget: \(error)")
        }
    }
}
