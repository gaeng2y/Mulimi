//
//  AuthenticationRepository.swift
//  DomainLayerInterface
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

public protocol AuthenticationRepository: Sendable {
    var isAuthenticated: Bool { get }

    func signInWithApple() async throws -> UserCredential
    func signOut()
    func deleteAccount() async throws
}
