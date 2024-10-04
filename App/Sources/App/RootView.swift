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
            .transition(.opacity)
            .tabItem {
                Image(systemName: "drop")
                Text("수분")
            }
        }
        .tint(.teal)
        .onAppear {
            store.send(.drinkWater(.subscribeWater))
        }
    }
}

#Preview {
    RootView(store: .init(initialState: Root.State()) {
        Root()
    })
}
