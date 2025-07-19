//
//  HistoryView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import SwiftUI

public struct RecordListView: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea(edges: [.top, .horizontal])
            
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
    
    private struct RecordRow: View {
        let record: Record
        
        private var dateString: String {
            let dateComponents = Calendar.current.dateComponents(
                [.year, .month, .day],
                from: record.date
            )
            
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
                    Text(String(format: "%.0fml", record.mililiter))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .cornerRadius(5)
            .shadow(radius: 2)
        }
    }
}

#Preview {
    RecordListView()
}
