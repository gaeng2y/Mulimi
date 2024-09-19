//
//  DrinkWaterClient.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 8/30/24.
//

import Combine
import ComposableArchitecture
import Foundation
import WidgetKit

@DependencyClient
struct DrinkWaterClient {
    var fetchNumberOfGlasses: @Sendable () -> Int = { 0 }
    var drinkWater: @Sendable () -> Void
    var reset: @Sendable () -> Void
}

extension DrinkWaterClient: TestDependencyKey {
    static var previewValue = Self(
        fetchNumberOfGlasses : {
            0
        },
        drinkWater: {
            return
        }, reset: {
            return
        }
    )
}

extension DrinkWaterClient: DependencyKey {
    static let liveValue = Self(
        fetchNumberOfGlasses: {
            UserDefaults.appGroup.glassesOfToday
        },
        drinkWater: {
            UserDefaults.appGroup.glassesOfToday += 1
            WidgetCenter.shared.reloadAllTimelines()
        }, reset: {
            UserDefaults.appGroup.glassesOfToday = .zero
            WidgetCenter.shared.reloadAllTimelines()
        }
    )
}

extension DependencyValues {
    var drinkWaterClient: DrinkWaterClient {
        get { self[DrinkWaterClient.self] }
        set { self[DrinkWaterClient.self] = newValue }
    }
}
