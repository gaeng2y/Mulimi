//
//  AuthenticationRepository.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol AuthenticationRepository {
    func isAuthenticated() -> Bool
    func signInWithApple() async throws -> String
    func signOut()
}
