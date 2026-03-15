//
//  HydrationRecordListViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation
import Localization
import SwiftUI

@Observable
public final class HydrationRecordListViewModel {
    private(set) var records: [HydrationRecord] = []
    private(set) var date: Date = .now
    
    private(set) var errorMessage: String = ""
    private let useCase: DrinkWaterUseCase
    private let recordRouting: any RecordRouting
    
    public init(
        useCase: DrinkWaterUseCase,
        recordRouting: any RecordRouting
    ) {
        self.useCase = useCase
        self.recordRouting = recordRouting
    }

    public var navigationPath: NavigationPath {
        get { recordRouting.path }
        set { recordRouting.path = newValue }
    }

    public var presentedRoute: RecordRoute? {
        get { recordRouting.presentedRoute }
        set { recordRouting.presentedRoute = newValue }
    }
    
    @MainActor
    func onAppear() async {
        await fetchHydrationRecord()
    }

    public func showMonthPicker() {
        recordRouting.present(.monthPicker)
    }

    public func dismissPresentedRoute() {
        recordRouting.dismissPresentedRoute()
    }
    
    @MainActor
    func fetchHydrationRecord() async {
        let monthDates = monthDates(for: date)
        var fetchedRecords: [HydrationRecord] = []

        for day in monthDates {
            let events = await useCase.hydrationEvents(on: day)
            let total = events.reduce(0) { partialResult, event in
                partialResult + event.volumeML
            }

            guard total > 0 else {
                continue
            }

            fetchedRecords.append(
                HydrationRecord(
                id: UUID(),
                date: day,
                mililiter: Double(total)
            )
            )
        }

        records = fetchedRecords.sorted { $0.date < $1.date }
    }

    @MainActor
    func updateDisplayedMonth(year: Int, month: Int) async {
        guard (1...12).contains(month),
              let newDate = Calendar.current.date(
                from: DateComponents(year: year, month: month, day: 1)
              ) else {
            errorMessage = L10n.tr("historyInvalidDateSelectionError")
            return
        }

        guard !Calendar.current.isDate(newDate, equalTo: date, toGranularity: .month) else {
            return
        }

        date = newDate
        await fetchHydrationRecord()
    }
    
    private func monthDates(for date: Date) -> [Date] {
        guard let startDate = Calendar.current.date(
            from: Calendar.current.dateComponents([.year, .month], from: date)
        ),
        let range = Calendar.current.range(of: .day, in: .month, for: startDate) else {
            errorMessage = L10n.tr("historyFailedDateRangeError")
            return []
        }

        return range.compactMap { day in
            Calendar.current.date(byAdding: .day, value: day - 1, to: startDate)
        }
    }
}
