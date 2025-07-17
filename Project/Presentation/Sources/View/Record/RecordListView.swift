//
//  HistoryView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import SwiftUI

public struct RecordListView: View {
    public var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea(edges: [.top])
            
            VStack {
                HStack {
                    Text("")
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    RecordListView()
}
