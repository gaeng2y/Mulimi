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

        // MARK: - ViewModels
        container.register(DrinkWaterViewModel.self) { resolver in
            DrinkWaterViewModel(
                waterUseCase: resolver.resolve(DrinkWaterUseCase.self)!,
                healthKitUseCase: resolver.resolve(HealthKitUseCase.self)!
            )
        }

        container.register(HydrationRecordListViewModel.self) { resolver in
            HydrationRecordListViewModel(
                useCase: resolver.resolve(HealthKitUseCase.self)!
            )
        }
    }
}