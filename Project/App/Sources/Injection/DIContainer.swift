//
//  DIContainer.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Swinject

final class DIContainer {
    static let shared = DIContainer()
    
    private let assembler: Assembler
    
    var resolver: Resolver {
        assembler.resolver
    }
    
    private init() {
        self.assembler = Assembler([
            DataAssembly(),
            DomainAssembly(),
            PresentationLayer()
        ])
    }
}
