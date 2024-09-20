//
//  DrinkWaterIntent.swift
//  DrinkWater
//
//  Created by 강동영 on 6/9/24.
//

import AppIntents
import WidgetKit

public struct DrinkWaterIntent: AppIntent {
    public static var title: LocalizedStringResource = "Drink Water"
    public static var description = IntentDescription("Glasses of Today counter")
    
    public init() {}
    
    public func perform() async throws -> some IntentResult {
        UserDefaults.appGroup.glassesOfToday += 1
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
