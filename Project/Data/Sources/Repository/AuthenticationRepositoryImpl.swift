//
//  AuthenticationRepositoryImpl.swift
//  DataLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import AuthenticationServices
import DomainLayerInterface
import Foundation

public struct AuthenticationRepositoryImpl: AuthenticationRepository {
    private let keyChainDataSource: KeyChainDataSource

    public init(keyChainDataSource: KeyChainDataSource) {
        self.keyChainDataSource = keyChainDataSource
    }

    public func isAuthenticated() -> Bool {
        keyChainDataSource.validateToken()
    }

    public func signInWithApple() async throws -> String {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        let delegate = AppleSignInDelegate()
        controller.delegate = delegate

        return try await withCheckedThrowingContinuation { continuation in
            delegate.continuation = continuation
            controller.performRequests()
        }
    }

    public func signOut() {
        keyChainDataSource.delete(property: .accessToken)
        keyChainDataSource.delete(property: .refreshToken)
        keyChainDataSource.delete(property: .userIdentifier)
        keyChainDataSource.delete(property: .nickname)
        keyChainDataSource.delete(property: .email)
    }
}

private class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
    var continuation: CheckedContinuation<String, Error>?

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: NSError(
                domain: "AuthenticationError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid credential type"]
            ))
            return
        }

        let userIdentifier = appleIDCredential.user

        // KeyChain에 사용자 정보 저장
        let keyChain = KeyChainDataSourceImpl()
        keyChain.save(property: .userIdentifier, value: userIdentifier)
        keyChain.save(property: .accessToken, value: userIdentifier) // 임시로 userIdentifier를 토큰으로 사용

        if let fullName = appleIDCredential.fullName {
            let name = [fullName.givenName, fullName.familyName]
                .compactMap { $0 }
                .joined(separator: " ")
            if !name.isEmpty {
                keyChain.save(property: .nickname, value: name)
            }
        }

        if let email = appleIDCredential.email {
            keyChain.save(property: .email, value: email)
        }

        continuation?.resume(returning: userIdentifier)
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        continuation?.resume(throwing: error)
    }
}
