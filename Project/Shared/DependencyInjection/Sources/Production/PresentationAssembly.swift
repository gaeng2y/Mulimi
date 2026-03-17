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
        container.register(SettingsCoordinator.self) { _ in
            SettingsCoordinator()
        }
        .inObjectScope(.container)
        container.register((any SettingsRouting).self) { resolver in
            resolver.resolve(SettingsCoordinator.self)!
        }
        container.register(RecordCoordinator.self) { _ in
            RecordCoordinator()
        }
        .inObjectScope(.container)
        container.register((any RecordRouting).self) { resolver in
            resolver.resolve(RecordCoordinator.self)!
        }
        
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
        .inObjectScope(.container)
        
        // MARK: - HealthKit
        container.register(HydrationRecordListViewModel.self) { resolver in
            HydrationRecordListViewModel(
                useCase: resolver.resolve(DrinkWaterUseCase.self)!,
                recordRouting: resolver.resolve((any RecordRouting).self)!
            )
        }

        container.register(HydrationInsightViewModel.self) { resolver in
            let waterUseCase = resolver.resolve(DrinkWaterUseCase.self)!
            let userPreferencesUseCase = resolver.resolve(UserPreferencesUseCase.self)!

            return MainActor.assumeIsolated {
                HydrationInsightViewModel(
                    waterUseCase: waterUseCase,
                    userPreferencesUseCase: userPreferencesUseCase
                )
            }
        }
        .inObjectScope(.container)

        container.register(ChallengeViewModel.self) { resolver in
            let waterUseCase = resolver.resolve(DrinkWaterUseCase.self)!
            let userPreferencesUseCase = resolver.resolve(UserPreferencesUseCase.self)!

            return MainActor.assumeIsolated {
                ChallengeViewModel(
                    waterUseCase: waterUseCase,
                    userPreferencesUseCase: userPreferencesUseCase
                )
            }
        }
        .inObjectScope(.container)

        container.register(ProfileRoutineViewModel.self) { resolver in
            let routineUseCase = resolver.resolve(RoutineUseCase.self)!
            let drinkWaterUseCase = resolver.resolve(DrinkWaterUseCase.self)!
            let userPreferencesUseCase = resolver.resolve(UserPreferencesUseCase.self)!

            return MainActor.assumeIsolated {
                ProfileRoutineViewModel(
                    routineUseCase: routineUseCase,
                    drinkWaterUseCase: drinkWaterUseCase,
                    userPreferencesUseCase: userPreferencesUseCase
                )
            }
        }
        .inObjectScope(.container)
        
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
                settingsRouting: resolver.resolve((any SettingsRouting).self)!,
                userPreferencesUseCase: resolver.resolve(UserPreferencesUseCase.self)!,
                signInUseCase: resolver.resolve(SignInUseCase.self)!,
                authenticationViewModel: resolver.resolve(AuthenticationViewModel.self)!
            )
        }
    }
}
