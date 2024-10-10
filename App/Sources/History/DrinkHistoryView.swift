//
//  DrinkHistoryView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/7/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct DrinkHistoryView: View {
    @Bindable var store: StoreOf<DrinkHistory>
    
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
                    Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                        ForEach(0..<(store.histories.count + 4) / 5, id: \.self) { rowIndex in
                            GridRow {
                                ForEach(0..<5) { columnIndex in
                                    let index = rowIndex * 5 + columnIndex
                                    if index < store.histories.count {
                                        HistoryItem(history: store.histories[index])
                                            .aspectRatio(1, contentMode: .fit)
                                    } else {
                                        EmptyView()
                                    }
                                }
                            }
                        }
                    }
                    .padding(10)
                    .task {
                        store.send(.fetchHistories)
                    }
                }
                
                Spacer()
//                switch store. {
//                case .notDetermined:
//                    Text("건강 데이터 권한을 허용해주세요.")
//                        .task {
//                            await viewModel.requestAuthorization()
//                        }
//                case .sharingDenied:
//                    VStack {
//                        Image(systemName: "heart.circle.fill")
//                            .resizable()
//                            .frame(width: 250, height: 250)
//                            .foregroundStyle(.teal)
//                            .padding()
//                            
//                        Text("설정 - 건강 - 데이터 접근 및 기기 - 물리미 - 모두 켜기를 설정해주세요.")
//                            .padding()
//                    }
//                    .alert("HealthKit 권한 필요", isPresented: $viewModel.showAuthorizationAlert) {
//                        Button("설정으로 이동") {
//                            guard let url = URL(string: UIApplication.openSettingsURLString) else {
//                                return
//                            }
//                            UIApplication.shared.open(url)
//                        }
//                        Button("취소", role: .cancel) {}
//                    } message: {
//                        Text("이 앱의 기능을 사용하려면 HealthKit 권한이 필요합니다. 설정에서 권한을 변경해주세요.")
//                    }
//                case .sharingAuthorized:
//                    Grid(horizontalSpacing: 10, verticalSpacing: 10) {
//                        ForEach(0..<(viewModel.histories.count + 4) / 5, id: \.self) { rowIndex in
//                            GridRow {
//                                ForEach(0..<5) { columnIndex in
//                                    let index = rowIndex * 5 + columnIndex
//                                    if index < viewModel.histories.count {
//                                        HistoryItem(history: viewModel.histories[index])
//                                            .aspectRatio(1, contentMode: .fit)
//                                    } else {
//                                        EmptyView()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(10)
//                    .task {
//                        await viewModel.fetchHistores()
//                    }
//                }
//                
//                Spacer()
            }
        }
//        .alert(viewModel.errorMessage, isPresented: $viewModel.showErrorAlert) {
//            Button("확인", role: .cancel, action: {})
//        }
    }
}

#Preview {
    DrinkHistoryView(store: Store(initialState: DrinkHistory.State()) {
        DrinkHistory()
    })
}
