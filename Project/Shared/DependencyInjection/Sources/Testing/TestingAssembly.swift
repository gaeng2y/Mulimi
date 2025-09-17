//
//  TestingAssembly.swift
//  DependencyInjectionTesting
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Swinject

public final class TestingAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        // MARK: - Mock UseCases for Testing
        container.register(DrinkWaterUseCase.self) { _ in
            MockDrinkWaterUseCaseForTesting()
        }

        container.register(HealthKitUseCase.self) { _ in
            MockHealthKitUseCaseForTesting()
        }
    }
}