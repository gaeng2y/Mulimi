//
//  ContentView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("물", systemImage: "waterbottle") {
                EmptyView()
            }
            
            Tab("기록", systemImage: "calendar") {
                EmptyView()
            }
        }
    }
}

#Preview {
    ContentView()
}
