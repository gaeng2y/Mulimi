//
//  HealthKitPermissionGateView.swift
//  PresentationLayer
//
//  Created by Codex on 3/25/26.
//

import DomainLayerInterface
import SwiftUI
import UIKit

public struct HealthKitPermissionGateView<Content: View>: View {
    @Bindable private var viewModel: HealthKitPermissionViewModel
    private let content: () -> Content

    public init(
        viewModel: HealthKitPermissionViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }

    public var body: some View {
        Group {
            if viewModel.isAuthorized {
                content()
            } else {
                permissionView
            }
        }
        .task {
            await viewModel.prepareIfNeeded()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            viewModel.refreshStatus()
        }
    }

    private var permissionView: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "heart.text.square.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(.teal)

                Text(titleText)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(descriptionText)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 24)
            }

            VStack(spacing: 12) {
                Button {
                    if viewModel.authorizationStatus == .sharingDenied {
                        openSettings()
                    } else {
                        Task {
                            await viewModel.requestAuthorization()
                        }
                    }
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Text(primaryButtonTitle)
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .foregroundColor(.white)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(viewModel.isLoading)

                if viewModel.authorizationStatus == .sharingDenied {
                    Button {
                        viewModel.refreshStatus()
                    } label: {
                        Text("다시 확인하기")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .foregroundColor(.primary)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding(.horizontal, 24)

            if viewModel.authorizationStatus == .sharingDenied {
                Text("설정 앱에서 건강 > 데이터 접근 및 기기 > 물리미 경로로 들어가 권한을 다시 켤 수 있어요.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            Spacer()
        }
        .padding()
    }

    private var primaryButtonTitle: String {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            return "건강 권한 허용하기"
        case .sharingDenied:
            return "설정 열기"
        case .sharingAuthorized:
            return "계속하기"
        }
    }

    private var titleText: String {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            return "건강 접근 권한이 필요해요"
        case .sharingDenied:
            return "건강 권한이 꺼져 있어요"
        case .sharingAuthorized:
            return "건강 접근 권한이 필요해요"
        }
    }

    private var descriptionText: String {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            return "물리미는 물 섭취 기록을 저장하고 불러오기 위해 건강 앱 권한이 필요합니다."
        case .sharingDenied:
            return "한 번 거부한 권한은 앱에서 다시 요청할 수 없어요. 설정에서 건강 권한을 허용한 뒤 다시 돌아와 주세요."
        case .sharingAuthorized:
            return "물리미는 물 섭취 기록을 저장하고 불러오기 위해 건강 앱 권한이 필요합니다."
        }
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        UIApplication.shared.open(settingsURL)
    }
}
