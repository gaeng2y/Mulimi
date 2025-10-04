//
//  PresentationAssembly.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import PresentationLayer
import Swinject

public final class PresentationAssembly: Assembly {
    public func assemble(container: Container) {
        // MARK: - Navigation
        container.register(NavigationRouter.self) { _ in
            NavigationRouter()
        }
        .inObjectScope(.container)
        
        // MARK: - DrinkWater
        container.register(DrinkWaterViewModel.self) { resolver in
            DrinkWaterViewModel(
                waterUseCase: resolver.resolve(DrinkWaterUseCase.self)!,
                healthKitUseCase: resolver.resolve(HealthKitUseCase.self)!,
                userPreferencesUseCase: resolver.resolve(UserPreferencesUseCase.self)!
            )
        }
        
        // MARK: - HealthKit
        container.register(HydrationRecordListViewModel.self) { resolver in
            HydrationRecordListViewModel(
                useCase: resolver.resolve(HealthKitUseCase.self)!
            )
        }
        
        // MARK: - Settings
        container.register(SettingsViewModel.self) { resolver in
            SettingsViewModel(
                navigationRouter: resolver.resolve(NavigationRouter.self)!,
                userPreferencesUseCase: resolver.resolve(UserPreferencesUseCase.self)!
            )
        }
    }
}
