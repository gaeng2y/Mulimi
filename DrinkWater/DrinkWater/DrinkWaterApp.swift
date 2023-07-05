//
//  DrinkWaterApp.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import SwiftUI

@main
struct DrinkWaterApp: App {
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

var key: String {
    let now = Date()
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    return dateFormatter.string(from: now)
}
