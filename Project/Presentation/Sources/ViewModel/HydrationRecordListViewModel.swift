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
    var authorizationStatus: HealthKitAuthorizationStatus {
        useCase.authorisationStatus
    }
    
    public init(
        useCase: HealthKitUseCase
    ) {
        self.useCase = useCase
    }
    
    func requestAuthorization() async {
        do {
            try await useCase.requestAuthorization()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
