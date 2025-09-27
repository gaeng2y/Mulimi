//
//  HydrationRecordListView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import SwiftUI

public struct HydrationRecordListView: View {
    private var viewModel: HydrationRecordListViewModel
    @State private var isPresentedAlert: Bool = false
    
    public init(viewModel: HydrationRecordListViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            switch viewModel.authorizationStatus {
            case .notDetermined:
                Text("권한을 설정해주세요.")
            case .sharingDenied:
                AuthorizationDeniedView()
            case .sharingAuthorized:
                RecordCalendarView(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.requestAuthorization()
        }
        .alert(
            viewModel.errorMessage,
            isPresented: $isPresentedAlert
        ) {
            
        }
    }
    
    private struct AuthorizationDeniedView: View {
        var body: some View {
            Text("설정에서 원한을 허용해주세요.")
        }
    }
    
    private struct RowListView: View {
        private var viewModel: HydrationRecordListViewModel
        
        init(viewModel: HydrationRecordListViewModel) {
            self.viewModel = viewModel
        }
        
        var body: some View {
            NavigationStack {
                List(viewModel.records) { record in
                    HydrationRecordRow(record: record)
                }
                .navigationTitle(viewModel.date.formatted(.dateTime.year().month()))
            }
        }
    }
    
    private struct HydrationRecordRow: View {
        let record: HydrationRecord
        
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
