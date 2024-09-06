//
//  DrinkWaterIntent.swift
//  DrinkWater
//
//  Created by 강동영 on 6/9/24.
//

import AppIntents
import ComposableArchitecture
import WidgetKit

struct DrinkWaterIntent: AppIntent {
    static var title: LocalizedStringResource = "Drink Water"
    static var description = IntentDescription("Glasses of Today counter")
    
    func perform() async throws -> some IntentResult {
        UserDefaults.appGroup.glassesOfToday += 1
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
