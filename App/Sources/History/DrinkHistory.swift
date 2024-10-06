//
//  DrinkHistory.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/6/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct DrinkHistory {
    @ObservableState
    struct State {
        var histories: [History] = []
    }
}
