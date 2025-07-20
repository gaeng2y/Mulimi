//
//  RecordListViewModel.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Combine
import DomainLayerInterface
import Foundation

public final class RecordListViewModel: ObservableObject {
    @Published private(set) var records: [HydrationRecord] = []
    @Published private(set) var date: Date = .now
    @Published var isPresentedAlert: Bool = false
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
