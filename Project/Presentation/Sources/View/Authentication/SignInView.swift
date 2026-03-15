//
//  SignInView.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 11/23/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Localization
import SwiftUI

public struct SignInView: View {
    @Bindable var viewModel: AuthenticationViewModel

    public init(viewModel: AuthenticationViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // 앱 로고 및 타이틀
            VStack(spacing: 16) {
                Image(systemName: "drop.degreesign.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Text(L10n.tr("signInTitle"))
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(L10n.tr("signInSubtitle"))
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

            // 커스텀 Apple 로그인 버튼
            Button {
                Task {
                    await viewModel.signInWithApple()
                }
            } label: {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        HStack {
                            Image(systemName: "applelogo")
                                .font(.title3)
                                .fontWeight(.medium)

                            Text(L10n.tr("signInWithAppleTitle"))
                                .font(.body)
                                .fontWeight(.medium)
                        }
                    }
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.black)
                .cornerRadius(8)
            }
            .padding(.horizontal, 32)
            .disabled(viewModel.isLoading)

            Spacer()
                .frame(height: 60)
        }
        .padding()
    }
}
