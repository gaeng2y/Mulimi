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
        container.register(AppSession.self) { _ in
            AppSession(isAuthenticated: true)
        }
        .inObjectScope(.container)

        container.register(DrinkWaterUseCase.self) { _ in
            MockDrinkWaterUseCase()
        }

        container.register(HealthKitUseCase.self) { _ in
            MockHealthKitUseCase()
        }

        container.register(BodyProfileUseCase.self) { _ in
            MockBodyProfileUseCase()
        }

        container.register(HydrationGoalRecommendationUseCase.self) { _ in
            MockHydrationGoalRecommendationUseCase()
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

        container.register((any WidgetTimelineReloading).self) { _ in
            NoOpWidgetTimelineReloader()
        }
        .inObjectScope(.container)

        container.register((any AppInfoProviding).self) { _ in
            StaticAppInfoProvider(appVersion: "2.0.0", appBuildNumber: "22")
        }
        .inObjectScope(.container)

        // MARK: - ViewModels
        container.register(DrinkWaterViewModel.self) { resolver in
            DrinkWaterViewModel(
                waterUseCase: resolver.resolve(DrinkWaterUseCase.self)!,
                userPreferencesUseCase: resolver.resolve(UserPreferencesUseCase.self)!,
                widgetTimelineReloader: resolver.resolve((any WidgetTimelineReloading).self)!
            )
        }
        .inObjectScope(.container)

        container.register(HydrationRecordListViewModel.self) { resolver in
            HydrationRecordListViewModel(
                useCase: resolver.resolve(DrinkWaterUseCase.self)!
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
        container.register(AppCoordinator.self) { _ in
            AppCoordinator()
        }
        .inObjectScope(.container)

        // MARK: - Authentication (Preview)
        container.register(AuthenticationViewModel.self) { resolver in
            AuthenticationViewModel(
                signInUseCase: resolver.resolve(SignInUseCase.self)!,
                appSession: resolver.resolve(AppSession.self)!
            )
        }
        .inObjectScope(.container)

        container.register(OnboardingViewModel.self) { resolver in
            let userPreferencesUseCase = resolver.resolve(UserPreferencesUseCase.self)!

            return MainActor.assumeIsolated {
                OnboardingViewModel(userPreferencesUseCase: userPreferencesUseCase)
            }
        }

        container.register(HealthKitPermissionViewModel.self) { resolver in
            let healthKitUseCase = resolver.resolve(HealthKitUseCase.self)!

            HealthKitPermissionViewModel(
                healthKitUseCase: healthKitUseCase
            )
        }
        .inObjectScope(.container)

        container.register(BodyProfileViewModel.self) { resolver in
            MainActor.assumeIsolated {
                BodyProfileViewModel(
                    bodyProfileUseCase: resolver.resolve(BodyProfileUseCase.self)!
                )
            }
        }
        .inObjectScope(.container)

        container.register(HydrationGoalRecommendationViewModel.self) { resolver in
            MainActor.assumeIsolated {
                HydrationGoalRecommendationViewModel(
                    useCase: resolver.resolve(HydrationGoalRecommendationUseCase.self)!
                )
            }
        }
        .inObjectScope(.container)

        // MARK: - Settings (Preview)
        container.register(SettingsViewModel.self) { resolver in
            SettingsViewModel(
                userPreferencesUseCase: resolver.resolve(UserPreferencesUseCase.self)!,
                signInUseCase: resolver.resolve(SignInUseCase.self)!,
                appSession: resolver.resolve(AppSession.self)!,
                widgetTimelineReloader: resolver.resolve((any WidgetTimelineReloading).self)!,
                appInfoProvider: resolver.resolve((any AppInfoProviding).self)!
            )
        }
    }
}
