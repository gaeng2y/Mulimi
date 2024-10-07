//
//  DrinkHistory.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/6/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
struct DrinkHistory {
    @ObservableState
    struct State {
        var date: Date = .now
        var histories: [History] = []
        var status: HealthKitAuthorizationStatus = .notDetermined
        
        private var year: Int {
            Calendar.current.component(.year, from: date)
        }
        private var month: Int {
            Calendar.current.component(.month, from: date)
        }
        var dateString: String {
            "\(year)년 \(month)월"
        }
    }
    
    enum Action {
        case requestAuthorization
        case changeStatus
        case fetchHistories
    }
    
    @Dependency(\.drinkHistoryClient) var drinkHistoryClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .requestAuthorization:
                return .run { send in
                    try await drinkHistoryClient.requestAuthorization()
                    await send(.changeStatus)
                }
                
            case .changeStatus:
                state.status = drinkHistoryClient.authroization()
                return .none
                
            case .fetchHistories:
                state.histories = []
                return .none
            }
        }
    }
}
