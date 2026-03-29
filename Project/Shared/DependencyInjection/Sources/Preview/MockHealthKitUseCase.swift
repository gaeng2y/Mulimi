//
//  MockHealthKitUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Foundation

public final class MockHealthKitUseCase: HealthKitUseCase, @unchecked Sendable {
    public var authorisationStatus: HealthKitAuthorizationStatus = .sharingAuthorized
    public var bodyProfile: BodyProfile = .empty

    public init() {}
    
    public func requestAuthorization() async throws {
        authorisationStatus = .sharingAuthorized
    }
    
    public func drinkWater() async throws {
        // Mock implementation - no actual HealthKit operation
    }
    
    public func reset() async throws {
        // Mock implementation - no actual HealthKit operation
    }
    
    public func fetchHistory(from startDate: Date, to endDate: Date) async throws -> [HydrationRecord] {
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

    public func fetchBodyProfile() async throws -> BodyProfile {
        bodyProfile
    }
}
