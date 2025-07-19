//
//  DataAssembly.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DataLayer
import DomainLayerInterface
import Swinject

final class DataAssembly: Assembly {
    func assemble(container: Container) {
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
    }
}
