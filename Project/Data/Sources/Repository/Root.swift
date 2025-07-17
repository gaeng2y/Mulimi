//
//  Root.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//


//@Reducer
//struct Root {
//    @ObservableState
//    struct State {
//        var drinkWater = DrinkWater.State()
//        var drinkHistory = HistoryFeature.State()
//    }
//    
//    enum Action {
//        case drinkWater(DrinkWater.Action)
//        case drinkHistory(HistoryFeature.Action)
//    }
//    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case .drinkWater:
//                return .none
//                
//            case .drinkHistory:
//                return .none
//            }
//        }
//        
//        Scope(state: \.drinkWater, action: \.drinkWater) {
//            DrinkWater()
//        }
//        Scope(state: \.drinkHistory, action: \.drinkHistory) {
//            HistoryFeature()
//        }
//    }
//}
//
