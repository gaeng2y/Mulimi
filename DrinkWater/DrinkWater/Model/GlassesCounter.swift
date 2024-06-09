//
//  GlassesCounter.swift
//  DrinkWater
//
//  Created by 강동영 on 6/9/24.
//

import Foundation
import WidgetKit

struct GlassesCounter {
    static func countUp() {
        let count = UserDefaults.shared.integer(forKey: String.glassesOfToday)
        UserDefaults.shared.set(count + 1, forKey: String.glassesOfToday)
    }
    
    static func countUp(with counter: Int) {
        UserDefaults.shared.set(counter, forKey: String.glassesOfToday)
    }
    
    static func updateTimeLine() {
        WidgetCenter.shared.reloadTimelines(ofKind: "DrinkWaterWidget")
    }
}
