//
//  RootView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    let store: StoreOf<Root>
    
    var body: some View {
        TabView {
            DrinkWaterView(
                store: store.scope(
                    state: \.drinkWater,
                    action: \.drinkWater
                )
            )
            .tabItem {
                Image(systemName: "drop")
                Text("수분")
            }
            
            DrinkHistoryView(
                store: store.scope(
                    state: \.drinkHistory,
                    action: \.drinkHistory
                )
            )
            .tabItem {
                Image(systemName: "calendar")
                Text("기록")
            }
        }
        .tint(.teal)
    }
}

#Preview {
    RootView(store: .init(initialState: Root.State()) {
        Root()
    })
}
