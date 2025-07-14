//
//  DrinkWater.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 8/12/24.
//

import Combine
import ComposableArchitecture
import Dependencies
import SwiftUI

@Reducer
struct DrinkWater {
    @ObservableState
    struct State {
        var numberOfGlasses = 0
        var offset: CGFloat = 0
        var errorMessage = ""
        
        var glassString: String {
            "\(numberOfGlasses)잔"
        }
        var liter: String {
            String(format: "%.2fL", 0.25 * Double(numberOfGlasses))
        }
        
        var progress: CGFloat {
            0.125 * CGFloat(numberOfGlasses)
        }
        
        var isDisableDrinkButton: Bool {
            numberOfGlasses >= 8
        }
        
        var drinkButtonTtile: String {
            numberOfGlasses < 8 ? "마시기" : "다마심"
        }
        
        var drinkButtonBackgroundColor: Color {
            numberOfGlasses < 8 ? .teal : .gray
        }
    }
    
    enum Action {
        case subscribeWater
        case receivedWater(Int)
        case drinkButtonTapped
        case resetButtonTapped
        case startAnimation
    }
    
    @Dependency(\.drinkWaterClient) var drinkWaterClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .subscribeWater:
                return .publisher {
                    drinkWaterClient.water().map { .receivedWater($0) }
                }
                
            case let .receivedWater(glassOfWater):
                state.numberOfGlasses = glassOfWater
                return .none
                
            case .drinkButtonTapped:
                guard state.numberOfGlasses < 8 else {
                    return .none
                }
                return .run { send in
                    try await drinkWaterClient.drinkWater()
                }
                
            case .resetButtonTapped:
                return .run { send in
                    try await drinkWaterClient.reset()
                }
                
            case .startAnimation:
                state.offset = 360
                return .none
            }
        }
    }
}
