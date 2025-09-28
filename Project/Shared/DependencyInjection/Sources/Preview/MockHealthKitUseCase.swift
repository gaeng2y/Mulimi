//
//  MockHealthKitUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockHealthKitUseCase: HealthKitUseCase {
    public init() {}
    
    public func requestAuthorization() async throws -> HealthKitAuthorizationStatus {
        return .authorized
    }
    
    public func drinkWater() {
        // Mock implementation - no actual HealthKit operation
    }
    
    public func reset() {
        // Mock implementation - no actual HealthKit operation
    }
    
    public func fetchRecords() async throws -> [HydrationRecord] {
        // Return sample data for preview
        let calendar = Calendar.current
        let today = Date()
        
        return [
            HydrationRecord(
                id: UUID(),
                amount: 250.0,
                date: calendar.date(byAdding: .hour, value: -1, to: today) ?? today
            ),
            HydrationRecord(
                id: UUID(),
                amount: 250.0,
                date: calendar.date(byAdding: .hour, value: -3, to: today) ?? today
            ),
            HydrationRecord(
                id: UUID(),
                amount: 250.0,
                date: calendar.date(byAdding: .hour, value: -5, to: today) ?? today
            )
        ]
    }
}
