//
//  SignInView.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import AuthenticationServices
import SwiftUI

public struct SignInView: View {
    @ObservedObject var viewModel: AuthenticationViewModel

    public init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // 앱 로고 및 타이틀
            VStack(spacing: 16) {
                Image(systemName: "waterbottle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text("물 마시기")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("건강한 수분 섭취를 위해\n로그인이 필요합니다")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            Spacer()

            // 에러 메시지
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }

            // Apple 로그인 버튼
            SignInWithAppleButton(
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    Task {
                        await viewModel.signInWithApple()
                    }
                }
            )
            .signInWithAppleButtonStyle(.black)
            .frame(height: 50)
            .cornerRadius(8)
            .padding(.horizontal, 32)
            .disabled(viewModel.isLoading)

            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 8)
            }

            Spacer()
                .frame(height: 60)
        }
        .padding()
    }
}
