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
        container.register(AppSession.self) { _ in
            AppSession()
        }
        .inObjectScope(.container)
        container.register(AppCoordinator.self) { _ in
            AppCoordinator()
        }
        .inObjectScope(.container)

        container.register((any WidgetTimelineReloading).self) { _ in
            SystemWidgetTimelineReloader()
        }
        .inObjectScope(.container)

        container.register((any AppInfoProviding).self) { _ in
            BundleAppInfoProvider()
        }
        .inObjectScope(.container)

        // MARK: - DrinkWater
        container.register(DrinkWaterViewModel.self) { resolver in
            let waterUseCase = resolver.resolve(DrinkWaterUseCase.self)!
            let userPreferencesUseCase = resolver.resolve(UserPreferencesUseCase.self)!
            let nextActionGuideUseCase = resolver.resolve(HydrationNextActionGuideUseCase.self)!
            let widgetTimelineReloader = resolver.resolve((any WidgetTimelineReloading).self)!

            return MainActor.assumeIsolated {
                DrinkWaterViewModel(
                    waterUseCase: waterUseCase,
                    userPreferencesUseCase: userPreferencesUseCase,
                    nextActionGuideUseCase: nextActionGuideUseCase,
                    widgetTimelineReloader: widgetTimelineReloader
                )
            }
        }
        .inObjectScope(.container)

        // MARK: - HealthKit
        container.register(HydrationRecordListViewModel.self) { resolver in
            HydrationRecordListViewModel(
                useCase: resolver.resolve(DrinkWaterUseCase.self)!
            )
        }

        container.register(HydrationInsightViewModel.self) { resolver in
            let waterUseCase = resolver.resolve(DrinkWaterUseCase.self)!
            let progressUseCase = resolver.resolve(HydrationProgressUseCase.self)!
            let routineAdherenceUseCase = resolver.resolve(HydrationRoutineAdherenceUseCase.self)!

            return MainActor.assumeIsolated {
                HydrationInsightViewModel(
                    waterUseCase: waterUseCase,
                    progressUseCase: progressUseCase,
                    routineAdherenceUseCase: routineAdherenceUseCase
                )
            }
        }
        .inObjectScope(.container)

        container.register(ChallengeViewModel.self) { resolver in
            let challengeUseCase = resolver.resolve(ChallengeUseCase.self)!
            let personalizedChallengeUseCase = resolver.resolve(PersonalizedChallengeUseCase.self)!
            let progressUseCase = resolver.resolve(HydrationProgressUseCase.self)!

            return MainActor.assumeIsolated {
                ChallengeViewModel(
                    challengeUseCase: challengeUseCase,
                    personalizedChallengeUseCase: personalizedChallengeUseCase,
                    progressUseCase: progressUseCase
                )
            }
        }
        .inObjectScope(.container)

        container.register(ProfileRoutineViewModel.self) { resolver in
            let routineUseCase = resolver.resolve(RoutineUseCase.self)!
            let routineRecommendationUseCase = resolver.resolve(RoutineRecommendationUseCase.self)!
            let drinkWaterUseCase = resolver.resolve(DrinkWaterUseCase.self)!
            let userPreferencesUseCase = resolver.resolve(UserPreferencesUseCase.self)!

            return MainActor.assumeIsolated {
                ProfileRoutineViewModel(
                    routineUseCase: routineUseCase,
                    routineRecommendationUseCase: routineRecommendationUseCase,
                    drinkWaterUseCase: drinkWaterUseCase,
                    userPreferencesUseCase: userPreferencesUseCase
                )
            }
        }
        .inObjectScope(.container)

        // MARK: - Authentication
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

            return MainActor.assumeIsolated {
                HealthKitPermissionViewModel(
                    healthKitUseCase: healthKitUseCase
                )
            }
        }
        .inObjectScope(.container)

        container.register(BodyProfileViewModel.self) { resolver in
            let bodyProfileUseCase = resolver.resolve(BodyProfileUseCase.self)!

            return MainActor.assumeIsolated {
                BodyProfileViewModel(
                    bodyProfileUseCase: bodyProfileUseCase
                )
            }
        }
        .inObjectScope(.container)

        container.register(HydrationGoalRecommendationViewModel.self) { resolver in
            let useCase = resolver.resolve(HydrationGoalRecommendationUseCase.self)!

            return MainActor.assumeIsolated {
                HydrationGoalRecommendationViewModel(useCase: useCase)
            }
        }
        .inObjectScope(.container)

        // MARK: - Settings
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
