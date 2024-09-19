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
        case onAppear
        case fetchNumberOfGlasses(Int)
        case drinkButtonTapped
        case drinkWater
        case resetButtonTapped
        case startAnimation
        case receivedError(DrinkWaterError)
    }
    
    @Dependency(\.drinkWaterClient) var drinkWaterClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let numberOfGlasses = self.drinkWaterClient.fetchNumberOfGlasses()
                    await send(.fetchNumberOfGlasses(numberOfGlasses))
                }
                
            case let .fetchNumberOfGlasses(numberOfGlasses):
                state.numberOfGlasses = numberOfGlasses
                return .none
                
            case .drinkButtonTapped:
                guard state.numberOfGlasses < 8 else {
                    return .none
                }
                return .run { send in
                    self.drinkWaterClient.drinkWater()
                    await send(.drinkWater)
                }
                
            case .drinkWater:
                state.numberOfGlasses += 1
                return .none
                
            case .resetButtonTapped:
                state.numberOfGlasses = .zero
                return .none
                
            case .startAnimation:
                state.offset = 360
                return .none
                
            case let .receivedError(drinkWaterError):
                switch drinkWaterError {
                case .failedFetchNumberOfGlasses:
                    state.errorMessage = "문제가 발생했어요!"
                }
                
                return .none
            }
        }
    }
}

enum DrinkWaterError: Error {
    case failedFetchNumberOfGlasses
}

