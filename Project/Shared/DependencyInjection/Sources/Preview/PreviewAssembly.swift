//
//  PreviewAssembly.swift
//  DependencyInjectionPreview
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import PresentationLayer
import Swinject

public final class PreviewAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        // MARK: - Mock UseCases
        container.register(DrinkWaterUseCase.self) { _ in
            MockDrinkWaterUseCase()
        }
        
        container.register(HealthKitUseCase.self) { _ in
            MockHealthKitUseCase()
        }

        container.register(UserPreferencesUseCase.self) { _ in
            MockUserPreferencesUseCase()
        }
        container.register(HydrationProgressUseCase.self) { _ in
            MockHydrationProgressUseCase()
        }
        container.register(ChallengeUseCase.self) { _ in
            MockChallengeUseCase()
        }
        container.register(PersonalizedChallengeUseCase.self) { _ in
            MockPersonalizedChallengeUseCase()
        }

        container.register(SignInUseCase.self) { _ in
            MockSignInUseCase()
        }

        container.register(RoutineUseCase.self) { _ in
            MockRoutineUseCase()
        }

        // MARK: - ViewModels
        container.register(DrinkWaterViewModel.self) { resolver in
            DrinkWaterViewModel(
                waterUseCase: resolver.resolve(DrinkWaterUseCase.self)!,
                healthKitUseCase: resolver.resolve(HealthKitUseCase.self)!,
                userPreferencesUseCase: resolver.resolve(UserPreferencesUseCase.self)!
            )
        }
        .inObjectScope(.container)
        
        container.register(HydrationRecordListViewModel.self) { resolver in
            HydrationRecordListViewModel(
                useCase: resolver.resolve(DrinkWaterUseCase.self)!,
                recordRouting: resolver.resolve((any RecordRouting).self)!
            )
        }

        container.register(HydrationInsightViewModel.self) { resolver in
            HydrationInsightViewModel(
                waterUseCase: resolver.resolve(DrinkWaterUseCase.self)!,
                progressUseCase: resolver.resolve(HydrationProgressUseCase.self)!
            )
        }
        .inObjectScope(.container)

        container.register(ChallengeViewModel.self) { resolver in
            ChallengeViewModel(
                challengeUseCase: resolver.resolve(ChallengeUseCase.self)!,
                personalizedChallengeUseCase: resolver.resolve(PersonalizedChallengeUseCase.self)!,
                progressUseCase: resolver.resolve(HydrationProgressUseCase.self)!
            )
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
        
        // MARK: - Navigation (Preview)
        container.register(RecordCoordinator.self) { _ in
            MockRecordCoordinator()
        }
        .inObjectScope(.container)
        container.register((any RecordRouting).self) { resolver in
            resolver.resolve(RecordCoordinator.self)!
        }

        // MARK: - Authentication (Preview)
        container.register(AuthenticationViewModel.self) { resolver in
            AuthenticationViewModel(
                signInUseCase: resolver.resolve(SignInUseCase.self)!
            )
        }
        .inObjectScope(.container)

        // MARK: - Settings (Preview)
        container.register(SettingsViewModel.self) { resolver in
            SettingsViewModel(
                userPreferencesUseCase: resolver.resolve(UserPreferencesUseCase.self)!,
                signInUseCase: resolver.resolve(SignInUseCase.self)!,
                authenticationViewModel: resolver.resolve(AuthenticationViewModel.self)!
            )
        }
    }
}
