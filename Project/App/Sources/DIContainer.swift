//
//  DIContainer.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation
import PresentationLayer
import Swinject

// MARK: - Mock Implementations (Replace with your actual implementations)

/// Mock implementation of DrinkWaterUseCase for demonstration
private final class MockDrinkWaterUseCase: DrinkWaterUseCase {
    var currentWater: Int = 0
    
    func drinkWater() {
        currentWater += 1
    }
    
    func reset() {
        currentWater = 0
    }
}

/// Mock implementation of HealthKitUseCase for demonstration  
private final class MockHealthKitUseCase: HealthKitUseCase {
    var authorisationStatus: HealthKitAuthorizationStatus = .notDetermined
    
    func requestAuthorization() async throws {
        // Mock authorization - in real implementation this would request HealthKit permissions
        authorisationStatus = .sharingAuthorized
    }
    
    func drinkWater() async throws {
        
    }
    
    func reset() async throws {
        
    }
}

// MARK: - DIContainer

/// Dependency Injection Container wrapper for Swinject
final class DIContainer {
    static let shared = DIContainer()
    
    private let container: Container
    private let assembler: Assembler
    
    private init() {
        container = Container()
        assembler = Assembler(container: container)
        
        // Register dependencies here
        registerDependencies()
    }
    
    private func registerDependencies() {
        // Register Use Cases
        // TODO: Replace these mock implementations with your actual implementations
        container.register(DrinkWaterUseCase.self) { _ in
            MockDrinkWaterUseCase()
        }
        
        container.register(HealthKitUseCase.self) { _ in
            MockHealthKitUseCase()
        }
        
        // Register ViewModels
        container.register(DrinkWaterViewModel.self) { resolver in
            DrinkWaterViewModel(
                waterUseCase: resolver.resolve(DrinkWaterUseCase.self)!,
                healthKitUseCase: resolver.resolve(HealthKitUseCase.self)!
            )
        }
        
        container.register(HydrationRecordListViewModel.self) { resolver in
            HydrationRecordListViewModel(
                useCase: resolver.resolve(HealthKitUseCase.self)!
            )
        }
    }
    
    /// Resolves a dependency of the specified type
    func resolve<T>(_ serviceType: T.Type) -> T {
        guard let service = container.resolve(serviceType) else {
            fatalError("Could not resolve dependency for type: \(serviceType)")
        }
        return service
    }
    
    /// Resolves a dependency of the specified type with a name
    func resolve<T>(_ serviceType: T.Type, name: String) -> T {
        guard let service = container.resolve(serviceType, name: name) else {
            fatalError("Could not resolve dependency for type: \(serviceType) with name: \(name)")
        }
        return service
    }
}
