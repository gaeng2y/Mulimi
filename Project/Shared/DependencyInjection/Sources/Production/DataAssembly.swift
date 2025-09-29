//
//  DataAssembly.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DataLayer
import DomainLayerInterface
import Swinject

public final class DataAssembly: Assembly {
    public func assemble(container: Container) {
        // MARK: - DrinkWater
        container.register(DrinkWaterDataSource.self) { resolver in
            DrinkWaterUserDefaultsDataSource(userDefaults: .appGroup)
        }
        
        container.register(DrinkWaterRepository.self) { resolver in
            DrinkWaterRepositoryImpl(
                dataSource: resolver.resolve(DrinkWaterDataSource.self)!
            )
        }
        
        // MARK: - HealthKit
        container.register(HealthKitDataSource.self) { resolver in
            HealthKitDataSourceImpl()
        }
        
        container.register(HealthKitRepository.self) { resolver in
            HealthKitRepositoryImpl(
                dataSource: resolver.resolve(HealthKitDataSource.self)!
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
    }
}
