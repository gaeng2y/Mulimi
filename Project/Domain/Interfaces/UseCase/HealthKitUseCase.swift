//
//  HealthKitUseCase.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 7/19/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol HealthKitUseCase: Sendable {
    var authorisationStatus: HealthKitAuthorizationStatus { get }
    
    func requestAuthorization() async throws
    func drinkWater() async throws
    func reset() async throws
    func fetchHistory(from startDate: Date, to endDate: Date) async throws -> [HydrationRecord]
    func fetchBodyProfile() async throws -> BodyProfile
}
