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
        // MARK: - Analytics
        container.register(AnalyticsUseCase.self) { resolver in
            AnalyticsUseCaseImpl(
                repository: resolver.resolve(AnalyticsRepository.self)!
            )
        }

        // MARK: - DrinkWater
        container.register(DrinkWaterUseCase.self) { resolver in
            DrinkWaterUseCaseImpl(
                repository: resolver.resolve(DrinkWaterRepository.self)!
            )
        }
        container.register(HydrationProgressUseCase.self) { resolver in
            HydrationProgressUseCaseImpl(
                drinkWaterRepository: resolver.resolve(DrinkWaterRepository.self)!,
                userPreferencesRepository: resolver.resolve(UserPreferencesRepository.self)!
            )
        }
        container.register(HydrationNextActionGuideUseCase.self) { resolver in
            HydrationNextActionGuideUseCaseImpl(
                drinkWaterRepository: resolver.resolve(DrinkWaterRepository.self)!,
                userPreferencesRepository: resolver.resolve(UserPreferencesRepository.self)!,
                routineUseCase: resolver.resolve(RoutineUseCase.self)!
            )
        }
        container.register(HydrationRoutineAdherenceUseCase.self) { resolver in
            HydrationRoutineAdherenceUseCaseImpl(
                routineUseCase: resolver.resolve(RoutineUseCase.self)!,
                drinkWaterRepository: resolver.resolve(DrinkWaterRepository.self)!
            )
        }
        container.register(ChallengeUseCase.self) { resolver in
            ChallengeUseCaseImpl(
                progressUseCase: resolver.resolve(HydrationProgressUseCase.self)!,
                challengeRepository: resolver.resolve(ChallengeRepository.self)!,
                drinkWaterRepository: resolver.resolve(DrinkWaterRepository.self)!
            )
        }
        container.register(PersonalizedChallengeUseCase.self) { resolver in
            PersonalizedChallengeUseCaseImpl(
                routineUseCase: resolver.resolve(RoutineUseCase.self)!,
                drinkWaterRepository: resolver.resolve(DrinkWaterRepository.self)!
            )
        }
        container.register(RoutineRecommendationUseCase.self) { resolver in
            RoutineRecommendationUseCaseImpl(
                routineUseCase: resolver.resolve(RoutineUseCase.self)!,
                drinkWaterRepository: resolver.resolve(DrinkWaterRepository.self)!
            )
        }

        // MARK: - HealthKit
        container.register(HealthKitUseCase.self) { resolver in
            HealthKitUseCaseImpl(
                repository: resolver.resolve(HealthKitRepository.self)!
            )
        }

        container.register(BodyProfileUseCase.self) { resolver in
            BodyProfileUseCaseImpl(
                healthKitRepository: resolver.resolve(HealthKitRepository.self)!
            )
        }

        container.register(HydrationGoalRecommendationUseCase.self) { resolver in
            HydrationGoalRecommendationUseCaseImpl(
                bodyProfileUseCase: resolver.resolve(BodyProfileUseCase.self)!,
                drinkWaterRepository: resolver.resolve(DrinkWaterRepository.self)!,
                userPreferencesRepository: resolver.resolve(UserPreferencesRepository.self)!,
                recommendationRepository: resolver.resolve(HydrationGoalRecommendationRepository.self)!
            )
        }

        // MARK: - UserPreferences
        container.register(UserPreferencesUseCase.self) { resolver in
            UserPreferencesUseCaseImpl(
                repository: resolver.resolve(UserPreferencesRepository.self)!
            )
        }

        // MARK: - Routine
        container.register(RoutineUseCase.self) { resolver in
            RoutineUseCaseImpl(
                repository: resolver.resolve(RoutineRepository.self)!
            )
        }

        // MARK: - Authentication
        container.register(SignInUseCase.self) { resolver in
            SignInUseCaseImpl(
                repository: resolver.resolve(AuthenticationRepository.self)!
            )
        }
    }
}
