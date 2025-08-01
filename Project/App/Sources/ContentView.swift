//
//  ContentView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import PresentationLayer

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("물", systemImage: "waterbottle") {
                DrinkWaterView(
                    viewModel: DIContainer.shared.resolve(DrinkWaterViewModel.self)
                )
            }
            
            Tab("기록", systemImage: "calendar") {
                HydrationRecordListView(
                    viewModel: DIContainer.shared.resolve(HydrationRecordListViewModel.self)
                )
            }
        }
        .tint(.accent)
    }
}

#Preview {
    ContentView()
}
