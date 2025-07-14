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
            RootView(store: .init(initialState: Root.State()) {
                Root()
            })
        }
    }
}
