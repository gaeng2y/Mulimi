//
//  HydrationRecordListView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Localization
import SwiftUI

public struct HydrationRecordListView: View {
    private var viewModel: HydrationRecordListViewModel
    @State private var isPresentedAlert: Bool = false
    
    public init(viewModel: HydrationRecordListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            RecordCalendarView(viewModel: viewModel)
            .navigationTitle(L10n.tr("historyTitle"))
            .navigationBarTitleDisplayMode(.large)
            .background(
                Color.background
                    .ignoresSafeArea()
            )
        }
        .task {
            await viewModel.onAppear()
        }
        .alert(
            viewModel.errorMessage,
            isPresented: $isPresentedAlert
        ) {
            
        }
    }
    
    private struct RowListView: View {
        private var viewModel: HydrationRecordListViewModel
        
        init(viewModel: HydrationRecordListViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            List(viewModel.records) { record in
                HydrationRecordRow(record: record)
            }
        }
    }
    
    private struct HydrationRecordRow: View {
        let record: HydrationRecord
        
        private var dateString: String {
            record.date.formatted(.dateTime.year().month().day())
        }
        
        var body: some View {
            HStack {
                Text(dateString)
                    .font(.subheadline)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(L10n.tr("commonMilliliterFormat", Int(record.mililiter.rounded())))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }
            .cornerRadius(5)
            .shadow(radius: 2)
        }
    }
}
