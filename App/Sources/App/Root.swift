//
//  Root.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//

import ComposableArchitecture

@Reducer
struct Root {
    @ObservableState
    struct State {
        var drinkWater = DrinkWater.State()
    }
    
    enum Action {
        case drinkWater(DrinkWater.Action)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .drinkWater:
                return .none
            }
        }
        
        Scope(state: \.drinkWater, action: \.drinkWater) {
            DrinkWater()
        }
    }
}

