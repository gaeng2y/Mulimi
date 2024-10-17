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
import Utils

@DependencyClient
struct DrinkWaterClient {
    var water: @Sendable () -> AnyPublisher<Int, Never> = { CurrentValueSubject(0).eraseToAnyPublisher() }
    var drinkWater: @Sendable () async throws -> Void
    var reset: @Sendable () async throws -> Void
}

extension DrinkWaterClient: TestDependencyKey {
    static var previewValue = Self(
        water: {
            CurrentValueSubject(0).eraseToAnyPublisher()
        },
        drinkWater: {
            return
        }, reset: {
            return
        }
    )
}

extension DrinkWaterClient: DependencyKey {
    private static let healthStore = HealthKitStore()
    
    static let liveValue = Self(
        water : {
            UserDefaults.appGroup.publisher(for: \.glassesOfToday).eraseToAnyPublisher()
        },
        drinkWater: {
            UserDefaults.appGroup.glassesOfToday += 1
            WidgetCenter.shared.reloadTimelines(ofKind: .widgetKind)
            try await healthStore.setAGlassOfWater()
        },
        reset: {
            UserDefaults.appGroup.glassesOfToday = .zero
            WidgetCenter.shared.reloadTimelines(ofKind: .widgetKind)
            try await healthStore.resetWaterInTakeInToday()
        }
    )
}

extension DependencyValues {
    var drinkWaterClient: DrinkWaterClient {
        get { self[DrinkWaterClient.self] }
        set { self[DrinkWaterClient.self] = newValue }
    }
}
