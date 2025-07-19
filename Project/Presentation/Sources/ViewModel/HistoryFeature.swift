//
//  HistoryFeature.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 10/6/24.
//  Copyright © 2024 gaeng2y. All rights reserved.
//

import Foundation

//struct HistoryFeature {
//    struct State {
//        var date: Date = .now
//        var histories: [Record] = []
////        var status: HealthKitAuthorizationStatus = .notDetermined
//        var errorMessage: String?
//        var isPresentAlert: Bool = false
//        
//        fileprivate var year: Int {
//            Calendar.current.component(.year, from: date)
//        }
//        fileprivate var month: Int {
//            Calendar.current.component(.month, from: date)
//        }
//        var dateString: String {
//            "\(year)년 \(month)월"
//        }
//    }
//    
//    enum Action {
//        case requestAuthorization
//        case changeStatus
//        case fetchHistories
//        case setHistories([History])
//    }
    
//    var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case .requestAuthorization:
//                return .run { send in
//                    try await drinkHistoryClient.requestAuthorization()
//                    await send(.changeStatus)
//                }
//                
//            case .changeStatus:
//                state.status = drinkHistoryClient.authroization()
//                return .none
//                
//            case .fetchHistories:
//                let (start, end) = getStartAndEndDate(state: state)
//                guard let start, let end else {
//                    return .none
//                }
//                
//                return .run { send in
//                    let histories = try await drinkHistoryClient.histories(start, end)
//                    await send(.setHistories(histories))
//                }
//                
//            case let .setHistories(histories):
//                state.histories = histories
//                return .none
//            }
//        }
//    }
//    
//    private func getStartAndEndDate(state: State) -> (startDate: Date?, endDate: Date?) {
//        let startDateComponents = DateComponents(year: state.year, month: state.month, day: 1)
//        
//        guard let startDate = Calendar.current.date(from: startDateComponents),
//              let range = Calendar.current.range(of: .day, in: .month, for: startDate) else {
//            return (nil, nil)
//        }
//        let endDateComponents = DateComponents(year: state.year, month: state.month, day: range.count)
//        let endDate = Calendar.current.date(from: endDateComponents)
//        
//        return (startDate, endDate)
//    }
//}
