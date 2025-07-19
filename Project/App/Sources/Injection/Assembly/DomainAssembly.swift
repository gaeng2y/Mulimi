//
//  DomainAssembly.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayer
import DomainLayerInterface
import Swinject

final class DomainAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - DrinkWater
        container.register(DrinkWaterUseCase.self) { resolver in
            DrinkWaterUseCaseImpl(
                repository: resolver.resolve(DrinkWaterRepository.self)!
            )
        }
        
        // MARK: - HealthKit
        container.register(HealthKitUseCase.self) { resolver in
            HealthKitUseCaseImpl(
                repository: resolver.resolve(HealthKitRepository.self)!
            )
        }
    }
}
