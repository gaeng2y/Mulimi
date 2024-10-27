//
//  HistoryView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct HistoryView: View {
    @Bindable var store: StoreOf<HistoryFeature>
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea(edges: [.top])
            
            VStack {
                HStack {
                    Text(store.dateString)
                        .font(.title)
                        .fontWeight(.heavy)
                    
                    Spacer()
                }
                .padding()
                
                switch store.status {
                case .notDetermined:
                    Text("건강 데이터 권한을 허용해주세요.")
                        .font(.title)
                        .task {
                            store.send(.requestAuthorization)
                        }
                    
                case .sharingDenied:
                    VStack {
                        Image(systemName: "heart.circle.fill")
                            .resizable()
                            .frame(width: 250, height: 250)
                            .foregroundStyle(.teal)
                            .padding()
                            
                        Text("설정 - 건강 - 데이터 접근 및 기기 - 물리미 - 모두 켜기를 설정해주세요.")
                            .padding()
                    }
                    
                case .sharingAuthorized:
                    List(store.histories) { history in
                        HistoryItem(history: history)
                    }
                    .listStyle(.plain)
                    .task {
                        store.send(.fetchHistories)
                    }
                }
                
                Spacer()
            }
        }
//        .alert(
//            store.errorMessage,
//            isPresented: store.isPresentAlert
//        ) {
//            Button("확인", role: .cancel, action: {})
//        }
    }
}

#Preview {
    HistoryView(store: Store(initialState: HistoryFeature.State()) {
        HistoryFeature()
    })
}
