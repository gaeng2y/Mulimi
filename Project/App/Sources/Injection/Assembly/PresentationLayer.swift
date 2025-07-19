//
//  PresentationLayer.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import PresentationLayer
import Swinject

final class PresentationLayer: Assembly {
    func assemble(container: Container) {
        // MARK: - DrinkWater
        container.register(DrinkWaterViewModel.self) { resolver in
            DrinkWaterViewModel(
                waterUseCase: resolver.resolve(DrinkWaterUseCase.self)!,
                healthKitUseCase: resolver.resolve(HealthKitUseCase.self)!
            )
        }
        
        // MARK: - HealthKit
        container.register(RecordListViewModel.self) { resolver in
            RecordListViewModel(
                useCase: resolver.resolve(HealthKitUseCase.self)!
            )
        }
    }
}
