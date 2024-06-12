//
//  GlassesCounter.swift
//  DrinkWater
//
//  Created by 강동영 on 6/9/24.
//

import WidgetKit

struct GlassesCounter {
    static func countUp(isUpdateTimeLine: Bool = true) {
        let count = UserDefaults.shared.integer(forKey: String.glassesOfToday)
        UserDefaults.shared.set(count + 1, forKey: String.glassesOfToday)
        if isUpdateTimeLine {
            updateTimeLine()
        }
    }
    
    static func countUp(with count: Int, isUpdateTimeLine: Bool = true) {
        UserDefaults.shared.set(count, forKey: String.glassesOfToday)
        if isUpdateTimeLine {
            updateTimeLine()
        }
    }
    
    static func clearGlassesCount(isUpdateTimeLine: Bool = true) {
        UserDefaults.shared.set(0, forKey: String.glassesOfToday)
        if isUpdateTimeLine {
            updateTimeLine()
        }
    }
    
    static func clearCount() {
        UserDefaults.shared.set(0, forKey: String.glassesOfToday)
    }
    
    static func updateTimeLine() {
        WidgetCenter.shared.reloadTimelines(ofKind: "DrinkWaterWidget")
    }
}
