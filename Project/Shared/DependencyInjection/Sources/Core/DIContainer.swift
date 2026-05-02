//
//  DIContainer.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DomainLayerInterface
import Swinject

public final class DIContainer: @unchecked Sendable {
    public static let shared = DIContainer()

    private let assembler: Assembler

    public var resolver: Resolver {
        assembler.resolver
    }

    private init() {
        self.assembler = Assembler([
            DataAssembly(),
            DomainAssembly(),
            PresentationAssembly()
        ])
    }

    // Custom initializer for testing/preview
    public init(assemblies: [Assembly]) {
        self.assembler = Assembler(assemblies)
    }

    public func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = resolver.resolve(serviceType) else {
            fatalError("Service \(serviceType) is not registered")
        }
        return service
    }

    public func registerAnalyticsRepository(_ repository: AnalyticsRepository) {
        assembler.apply(
            assembly: AnalyticsRepositoryOverrideAssembly(repository: repository)
        )
    }
}

private final class AnalyticsRepositoryOverrideAssembly: Assembly {
    private let repository: AnalyticsRepository

    init(repository: AnalyticsRepository) {
        self.repository = repository
    }

    func assemble(container: Container) {
        container.register(AnalyticsRepository.self) { _ in
            self.repository
        }
        .inObjectScope(.container)
    }
}
