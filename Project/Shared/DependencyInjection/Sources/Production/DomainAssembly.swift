//
//  DomainAssembly.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayer
import DomainLayerInterface
import Swinject

public final class DomainAssembly: Assembly {
    public func assemble(container: Container) {
        // MARK: - DrinkWater
        container.register(DrinkWaterUseCase.self) { resolver in
            DrinkWaterUseCaseImpl(
                repository: resolver.resolve(DrinkWaterRepository.self)!
            )
        }
        
        // MARK: - HealthKit
        container.register(HealthKitUseCase.self) { resolver in
            HealthKitUseCaseImpl(
                repository: resolver.resolve(HealthKitRepository.self)!
            )
        }
        
        // MARK: - UserPreferences
        container.register(UserPreferencesUseCase.self) { resolver in
            UserPreferencesUseCaseImpl(
                repository: resolver.resolve(UserPreferencesRepository.self)!
            )
        }
    }
}
