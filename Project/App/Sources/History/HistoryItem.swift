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
    
    private var dateString: String {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: history.date)
        
        guard let year = dateComponents.year,
              let month = dateComponents.month,
              let day = dateComponents.day else {
            return ""
        }
        return "\(year)-\(month)-\(day)"
    }
    
    var body: some View {
        HStack {
            Text(dateString)
                .font(.subheadline)
            
            Spacer()
            
            HStack {
                Spacer()
                Text(String(format: "%.0fml", history.mililiter))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .cornerRadius(5)
        .shadow(radius: 2)
    }
}

#Preview {
    HistoryItem(
        history: .init(
            id: UUID(),
            date: .now,
            mililiter: 200
        )
    )
}
