//
//  AppIntent.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//

import WidgetKit
import AppIntents
import Utils

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
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
