//
//  SignInUseCaseTests.swift
//  DomainLayerTests
//
//  Created by Codex on 3/11/26.
//

import DomainLayer
import Foundation
import Testing

@testable import DomainLayer

@Suite("SignInUseCase Tests")
struct SignInUseCaseTests {
    private enum MockSignInError: Error {
        case signInFailed
        case deleteAccountFailed
    }

    @Test("초기 인증 상태 조회 테스트")
    func initialAuthenticationState() {
        let mockRepository = MockAuthenticationRepository()
        mockRepository.isAuthenticatedValue = false
        let useCase = SignInUseCaseImpl(repository: mockRepository)

        #expect(useCase.isAuthenticated == false)
    }

    @Test("인증 상태는 Repository 값을 그대로 반영한다")
    func authenticationStateReflectsRepository() {
        let mockRepository = MockAuthenticationRepository()
        mockRepository.isAuthenticatedValue = true
        let useCase = SignInUseCaseImpl(repository: mockRepository)

        #expect(useCase.isAuthenticated == true)
    }

    @Test("Apple 로그인 성공 시 Repository 메소드를 위임 호출한다")
    func signInWithAppleSuccess() async throws {
        let mockRepository = MockAuthenticationRepository()
        let useCase = SignInUseCaseImpl(repository: mockRepository)

        try await useCase.signInWithApple()

        #expect(mockRepository.signInWithAppleCallCount == 1)
        #expect(useCase.isAuthenticated == true)
    }

    @Test("Apple 로그인 실패 시 에러를 그대로 전달한다")
    func signInWithAppleFailure() async {
        let mockRepository = MockAuthenticationRepository()
        mockRepository.signInError = MockSignInError.signInFailed
        let useCase = SignInUseCaseImpl(repository: mockRepository)

        await #expect(throws: MockSignInError.signInFailed) {
            try await useCase.signInWithApple()
        }
        #expect(mockRepository.signInWithAppleCallCount == 1)
    }

    @Test("로그아웃 시 Repository 메소드를 위임 호출한다")
    func signOut() {
        let mockRepository = MockAuthenticationRepository()
        mockRepository.isAuthenticatedValue = true
        let useCase = SignInUseCaseImpl(repository: mockRepository)

        useCase.signOut()

        #expect(mockRepository.signOutCallCount == 1)
        #expect(useCase.isAuthenticated == false)
    }

    @Test("회원 탈퇴 성공 시 Repository 메소드를 위임 호출한다")
    func deleteAccountSuccess() async throws {
        let mockRepository = MockAuthenticationRepository()
        mockRepository.isAuthenticatedValue = true
        let useCase = SignInUseCaseImpl(repository: mockRepository)

        try await useCase.deleteAccount()

        #expect(mockRepository.deleteAccountCallCount == 1)
        #expect(useCase.isAuthenticated == false)
    }

    @Test("회원 탈퇴 실패 시 에러를 그대로 전달한다")
    func deleteAccountFailure() async {
        let mockRepository = MockAuthenticationRepository()
        mockRepository.deleteAccountError = MockSignInError.deleteAccountFailed
        let useCase = SignInUseCaseImpl(repository: mockRepository)

        await #expect(throws: MockSignInError.deleteAccountFailed) {
            try await useCase.deleteAccount()
        }
        #expect(mockRepository.deleteAccountCallCount == 1)
    }
}
