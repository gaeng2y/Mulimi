//
//  AuthenticationNetworkDataSource.swift
//  DataLayer
//
//  Created by Claude on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation

// MARK: - DTO
public struct AuthTokens: Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresIn: Int

    public init(accessToken: String, refreshToken: String, expiresIn: Int) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
    }
}

// MARK: - DataSource Protocol
public protocol AuthenticationNetworkDataSource: Sendable {
    func authenticateWithApple(identityToken: String) async throws -> AuthTokens
    func authenticateWithGoogle(idToken: String) async throws -> AuthTokens
    func refreshToken(_ refreshToken: String) async throws -> AuthTokens
}

// MARK: - Implementation (향후 서버 통신 시 구현)
public final class AuthenticationNetworkDataSourceImpl: AuthenticationNetworkDataSource, @unchecked Sendable {
    public init() {}

    public func authenticateWithApple(identityToken: String) async throws -> AuthTokens {
        // TODO: 서버 API 호출
        // POST /auth/apple
        // Body: { "identity_token": identityToken }
        // Response: { "access_token": "...", "refresh_token": "...", "expires_in": 3600 }

        fatalError("Server authentication not implemented yet")
    }

    public func authenticateWithGoogle(idToken: String) async throws -> AuthTokens {
        // TODO: 서버 API 호출
        fatalError("Server authentication not implemented yet")
    }

    public func refreshToken(_ refreshToken: String) async throws -> AuthTokens {
        // TODO: 서버 API 호출
        fatalError("Server authentication not implemented yet")
    }
}
