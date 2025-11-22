//
//  HydrationRecordListViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

@Observable
public final class HydrationRecordListViewModel {
    private(set) var records: [HydrationRecord] = []
    private(set) var date: Date = .now
    
    private(set) var errorMessage: String = ""
    
    private let useCase: HealthKitUseCase
    private(set) var authorizationStatus: HealthKitAuthorizationStatus = .notDetermined
    
    public init(
        useCase: HealthKitUseCase
    ) {
        self.useCase = useCase
    }
    
    func onAppear() async {
        await requestAuthorization()
        authorizationStatus = useCase.authorisationStatus
    }
    
    private func requestAuthorization() async {
        do {
            try await useCase.requestAuthorization()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func fetchHydrationRecord() async {
        let (startDate, endDate) = getStartAndEndDate()
        
        guard let startDate, let endDate else {
            errorMessage = "Failed to calculate date range"
            return
        }
        
        do {
            let fetchedRecords = try await useCase.fetchHistory(from: startDate, to: endDate)
            records = fetchedRecords
        } catch {
            return
        }
    }
    
    private func getStartAndEndDate() -> (startDate: Date?, endDate: Date?) {
        let year = date.getComponents(for: .year)
        let month = date.getComponents(for: .month)
        let startDateComponents = DateComponents(year: year, month: month, day: 1)
        
        guard let startDate = Calendar.current.date(from: startDateComponents),
              let range = Calendar.current.range(of: .day, in: .month, for: startDate) else {
            return (nil, nil)
        }
        let endDateComponents = DateComponents(year: year, month: month, day: range.count)
        let endDate = Calendar.current.date(from: endDateComponents)
        
        return (startDate, endDate)
    }
}

fileprivate extension Date {
    func getComponents(for component: Calendar.Component) -> Int? {
        Calendar.autoupdatingCurrent.dateComponents([component], from: self).value(for: component) ?? 0
    }
}
