//
//  AuthenticationRepositoryImpl.swift
//  DataLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Foundation

public struct AuthenticationRepositoryImpl: AuthenticationRepository {
    // MARK: - Dependencies
    private let appleSignInDataSource: AppleSignInDataSource
    private let keyChainDataSource: KeyChainDataSource
    // 향후 서버 통신 시 추가
    // private let networkDataSource: AuthenticationNetworkDataSource

    // MARK: - Initializer
    public init(
        appleSignInDataSource: AppleSignInDataSource,
        keyChainDataSource: KeyChainDataSource
    ) {
        self.appleSignInDataSource = appleSignInDataSource
        self.keyChainDataSource = keyChainDataSource
    }

    // MARK: - Authentication Status
    public var isAuthenticated: Bool {
        keyChainDataSource.validateToken()
    }

    // MARK: - Sign In with Apple
    public func signInWithApple() async throws -> UserCredential {
        // 1. Apple 로그인 수행
        let appleCredential = try await appleSignInDataSource.signIn(
            scopes: ["email", "fullName"]
        )

        // 2. 도메인 Entity로 변환
        let userCredential = UserCredential(
            userIdentifier: appleCredential.userIdentifier,
            email: appleCredential.email,
            name: formatName(from: appleCredential.fullName)
        )

        // 3. KeyChain에 저장
        keyChainDataSource.save(
            property: .userIdentifier,
            value: appleCredential.userIdentifier
        )
        keyChainDataSource.save(
            property: .accessToken,
            value: appleCredential.userIdentifier  // 임시로 userIdentifier 사용
        )

        if let email = appleCredential.email {
            keyChainDataSource.save(property: .email, value: email)
        }

        if let name = userCredential.name, !name.isEmpty {
            keyChainDataSource.save(property: .nickname, value: name)
        }

        // 향후 서버 통신 추가 시:
        // 4. 서버로 Identity Token 전송하여 JWT 획득
        // if let identityToken = appleCredential.identityToken {
        //     let tokens = try await networkDataSource.authenticateWithApple(
        //         identityToken: identityToken
        //     )
        //     keyChainDataSource.save(property: .accessToken, value: tokens.accessToken)
        //     keyChainDataSource.save(property: .refreshToken, value: tokens.refreshToken)
        // }

        return userCredential
    }

    // MARK: - Sign Out
    public func signOut() {
        keyChainDataSource.delete(property: .accessToken)
        keyChainDataSource.delete(property: .refreshToken)
        keyChainDataSource.delete(property: .userIdentifier)
        keyChainDataSource.delete(property: .nickname)
        keyChainDataSource.delete(property: .email)
    }

    // MARK: - Delete Account
    public func deleteAccount() async throws {
        // 1. 서버에 계정 삭제 요청 (향후 구현)
        // try await networkDataSource.deleteAccount()

        // 2. KeyChain에서 모든 인증 정보 삭제
        keyChainDataSource.delete(property: .accessToken)
        keyChainDataSource.delete(property: .refreshToken)
        keyChainDataSource.delete(property: .userIdentifier)
        keyChainDataSource.delete(property: .nickname)
        keyChainDataSource.delete(property: .email)

        // 3. Apple Sign In 자격 증명 해제 (필요 시)
        // Apple은 서버 측에서 처리하는 것이 일반적
    }

    // MARK: - Helper
    private func formatName(from fullName: (givenName: String?, familyName: String?)?) -> String? {
        guard let fullName = fullName else { return nil }
        let name = [fullName.givenName, fullName.familyName]
            .compactMap { $0 }
            .joined(separator: " ")
        return name.isEmpty ? nil : name
    }
}
