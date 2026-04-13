//
//  AppleSignInDataSource.swift
//  DataLayer
//
//  Created by Claude on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import AuthenticationServices
import Foundation

// MARK: - DTO
public struct AppleSignInCredential: Sendable {
    public let userIdentifier: String
    public let identityToken: String?
    public let authorizationCode: String?
    public let email: String?
    public let fullName: (givenName: String?, familyName: String?)?

    public init(
        userIdentifier: String,
        identityToken: String?,
        authorizationCode: String?,
        email: String?,
        fullName: (givenName: String?, familyName: String?)?
    ) {
        self.userIdentifier = userIdentifier
        self.identityToken = identityToken
        self.authorizationCode = authorizationCode
        self.email = email
        self.fullName = fullName
    }
}

// MARK: - DataSource Protocol
public protocol AppleSignInDataSource: Sendable {
    @MainActor
    func signIn(scopes: [String]) async throws -> AppleSignInCredential
}

// MARK: - Implementation
public final class AppleSignInDataSourceImpl: AppleSignInDataSource, @unchecked Sendable {
    public init() {}

    @MainActor
    public func signIn(scopes: [String]) async throws -> AppleSignInCredential {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()

        // String → ASAuthorization.Scope 변환
        request.requestedScopes = scopes.compactMap { scope in
            switch scope {
            case "email": return .email
            case "fullName": return .fullName
            default: return nil
            }
        }

        let controller = ASAuthorizationController(authorizationRequests: [request])
        let delegate = AppleSignInDelegate()
        controller.delegate = delegate

        return try await withCheckedThrowingContinuation { continuation in
            delegate.continuation = continuation
            controller.performRequests()
        }
    }
}

// MARK: - Delegate
private final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    var continuation: CheckedContinuation<AppleSignInCredential, Error>?

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: NSError(
                domain: "AppleSignInDataSource",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid credential type"]
            ))
            return
        }

        let credential = AppleSignInCredential(
            userIdentifier: appleIDCredential.user,
            identityToken: appleIDCredential.identityToken.flatMap {
                String(data: $0, encoding: .utf8)
            },
            authorizationCode: appleIDCredential.authorizationCode.flatMap {
                String(data: $0, encoding: .utf8)
            },
            email: appleIDCredential.email,
            fullName: appleIDCredential.fullName.map {
                ($0.givenName, $0.familyName)
            }
        )

        continuation?.resume(returning: credential)
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        continuation?.resume(throwing: error)
    }
}
