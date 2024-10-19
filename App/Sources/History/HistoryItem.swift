//
//  HistoryItem.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import SwiftUI

struct HistoryItem: View {
    let history: History
    
    private var dayString: String {
        let day = Calendar.current.component(.day, from: history.date)
        return "\(day)"
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(dayString)
                    .font(.title2)
                Spacer()
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Text(String(format: "%.0fml", history.mililiter))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(5)
        .shadow(radius: 2)
    }
}

#Preview {
    HistoryItem(history: .init(date: .now, mililiter: 200))
}
