//
//  DIContainer+Testing.swift
//  DependencyInjectionTesting
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DependencyInjection

public extension DIContainer {
    static let testing: DIContainer = {
        DIContainer(assemblies: [TestingAssembly()])
    }()

    static func testingContainer(with assemblies: [Assembly] = []) -> DIContainer {
        let allAssemblies = [TestingAssembly()] + assemblies
        return DIContainer(assemblies: allAssemblies)
    }
}