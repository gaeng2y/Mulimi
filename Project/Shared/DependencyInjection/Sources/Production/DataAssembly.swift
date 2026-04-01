//
//  DataAssembly.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DataLayer
import DomainLayerInterface
import Swinject
import Utils

public final class DataAssembly: Assembly {
    public func assemble(container: Container) {
        // MARK: - DrinkWater
        container.register(DrinkWaterDataSource.self) { resolver in
            DrinkWaterHealthKitDataSource(
                healthKitDataSource: resolver.resolve(HealthKitDataSource.self)!
            )
        }
        .inObjectScope(.container)

        // MARK: - HealthKit
        container.register(HealthKitDataSource.self) { resolver in
            HealthKitDataSourceImpl()
        }
        
        container.register(HealthKitRepository.self) { resolver in
            HealthKitRepositoryImpl(
                dataSource: resolver.resolve(HealthKitDataSource.self)!
            )
        }

        container.register(DrinkWaterRepository.self) { resolver in
            DrinkWaterRepositoryImpl(
                dataSource: resolver.resolve(DrinkWaterDataSource.self)!
            )
        }
        
        // MARK: - UserPreferences
        container.register(UserPreferencesDataSource.self) { resolver in
            UserPreferencesDataSourceImpl(userDefaults: .appGroup)
        }
        
        container.register(UserPreferencesRepository.self) { resolver in
            UserPreferencesRepositoryImpl(
                dataSource: resolver.resolve(UserPreferencesDataSource.self)!
            )
        }

        container.register(HydrationGoalRecommendationDataSource.self) { _ in
            FoundationModelsHydrationGoalRecommendationDataSource()
        }

        container.register(HydrationGoalRecommendationRepository.self) { resolver in
            HydrationGoalRecommendationRepositoryImpl(
                dataSource: resolver.resolve(HydrationGoalRecommendationDataSource.self)!
            )
        }

        // MARK: - Routine
        container.register(RoutineStorageDataSource.self) { _ in
            RoutineStorageDataSourceImpl(userDefaults: .appGroup)
        }

        container.register(RoutineNotificationDataSource.self) { _ in
            RoutineNotificationDataSourceImpl()
        }

        container.register(RoutineRepository.self) { resolver in
            RoutineRepositoryImpl(
                storageDataSource: resolver.resolve(RoutineStorageDataSource.self)!,
                notificationDataSource: resolver.resolve(RoutineNotificationDataSource.self)!
            )
        }

        // MARK: - Challenge
        container.register(ChallengeStorageDataSource.self) { _ in
            ChallengeStorageDataSourceImpl(userDefaults: .appGroup)
        }

        container.register(ChallengeRepository.self) { resolver in
            ChallengeRepositoryImpl(
                storageDataSource: resolver.resolve(ChallengeStorageDataSource.self)!
            )
        }

        // MARK: - Authentication
        container.register(KeyChainDataSource.self) { resolver in
            KeyChainDataSourceImpl()
        }

        container.register(AppleSignInDataSource.self) { resolver in
            AppleSignInDataSourceImpl()
        }

        // 향후 서버 통신 시 추가:
        // container.register(AuthenticationNetworkDataSource.self) { resolver in
        //     AuthenticationNetworkDataSourceImpl()
        // }

        container.register(AuthenticationRepository.self) { resolver in
            AuthenticationRepositoryImpl(
                appleSignInDataSource: resolver.resolve(AppleSignInDataSource.self)!,
                keyChainDataSource: resolver.resolve(KeyChainDataSource.self)!
            )
        }
    }
}
