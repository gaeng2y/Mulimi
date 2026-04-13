//
//  HealthKitPermissionGateView.swift
//  PresentationLayer
//
//  Created by Codex on 3/25/26.
//

import DomainLayerInterface
import Localization
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
                        Text(L10n.tr("healthKitPermissionRefreshTitle"))
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
                Text(L10n.tr("healthKitPermissionSettingsFootnote"))
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
            return L10n.tr("healthKitPermissionAllowTitle")
        case .sharingDenied:
            return L10n.tr("bodyProfileOpenSettingsTitle")
        case .sharingAuthorized:
            return L10n.tr("commonConfirmTitle")
        }
    }

    private var titleText: String {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            return L10n.tr("healthKitPermissionNeededTitle")
        case .sharingDenied:
            return L10n.tr("healthKitPermissionDeniedTitle")
        case .sharingAuthorized:
            return L10n.tr("healthKitPermissionNeededTitle")
        }
    }

    private var descriptionText: String {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            return L10n.tr("healthKitPermissionNeededDescription")
        case .sharingDenied:
            return L10n.tr("healthKitPermissionDeniedDescription")
        case .sharingAuthorized:
            return L10n.tr("healthKitPermissionNeededDescription")
        }
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        UIApplication.shared.open(settingsURL)
    }
}
