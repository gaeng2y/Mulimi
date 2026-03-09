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
            let waterUseCase = resolver.resolve(DrinkWaterUseCase.self)!
            let healthKitUseCase = resolver.resolve(HealthKitUseCase.self)!
            let userPreferencesUseCase = resolver.resolve(UserPreferencesUseCase.self)!

            return MainActor.assumeIsolated {
                DrinkWaterViewModel(
                    waterUseCase: waterUseCase,
                    healthKitUseCase: healthKitUseCase,
                    userPreferencesUseCase: userPreferencesUseCase
                )
            }
        }
        
        // MARK: - HealthKit
        container.register(HydrationRecordListViewModel.self) { resolver in
            HydrationRecordListViewModel(
                useCase: resolver.resolve(DrinkWaterUseCase.self)!
            )
        }
        
        // MARK: - Authentication
        container.register(AuthenticationViewModel.self) { resolver in
            AuthenticationViewModel(
                signInUseCase: resolver.resolve(SignInUseCase.self)!
            )
        }
        .inObjectScope(.container)

        // MARK: - Settings
        container.register(SettingsViewModel.self) { resolver in
            SettingsViewModel(
                navigationRouter: resolver.resolve(NavigationRouter.self)!,
                userPreferencesUseCase: resolver.resolve(UserPreferencesUseCase.self)!,
                signInUseCase: resolver.resolve(SignInUseCase.self)!,
                authenticationViewModel: resolver.resolve(AuthenticationViewModel.self)!
            )
        }
    }
}
