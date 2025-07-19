//
//  HealthKitRepositoryImpl.swift
//  DataLayer
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

public struct HealthKitRepositoryImpl: HealthKitRepository {
    private let dataSource: HealthKitDataSource
    
    public init(dataSource: HealthKitDataSource) {
        self.dataSource = dataSource
    }
    
    public var authorisationStatus: HealthKitAuthorizationStatus {
        dataSource.healthKitAuthorizationStatus
    }
    
    public func requestAuthorization() async throws {
        try await dataSource.requestAuthorization()
    }
    
    public func drinkWater() async throws {
        try await dataSource.setAGlassOfWater()
    }
    
    public func reset() async throws {
        try await dataSource.resetWaterInTakeInToday()
    }
}
