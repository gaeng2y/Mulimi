//
//  DIContainer+Preview.swift
//  DependencyInjectionPreview
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import DependencyInjection

public extension DIContainer {
    static let preview: DIContainer = {
        DIContainer(assemblies: [PreviewAssembly()])
    }()
}