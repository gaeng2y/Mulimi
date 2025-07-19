//
//  HealthKitUseCaseImpl.swift
//  DomainLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

public struct HealthKitUseCaseImpl: HealthKitUseCase {
    private let repository: HealthKitRepository
    
    public init(repository: HealthKitRepository) {
        self.repository = repository
    }
    
    public var authorisationStatus: HealthKitAuthorizationStatus {
        repository.authorisationStatus
    }
    
    public func requestAuthorization() async throws {
        try await repository.requestAuthorization()
    }
    
    public func drinkWater() async throws {
        try await repository.drinkWater()
    }
    
    public func reset() async throws {
        try await repository.reset()
    }
}
