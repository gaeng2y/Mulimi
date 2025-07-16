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
        UserDefaults.appGroup.glassesOfToday += 1
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
