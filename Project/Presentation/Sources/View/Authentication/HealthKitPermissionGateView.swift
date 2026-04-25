//
//  HealthKitPermissionGateView.swift
//  PresentationLayer
//
//  Created by Codex on 3/25/26.
//

import DomainLayerInterface
import Foundation
import Localization
import SwiftUI

public struct HealthKitPermissionGateView<Content: View>: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
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
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else {
                return
            }

            viewModel.refreshStatus()
        }
    }

    private var permissionView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 24)

                headerSection
                accessCard

                if viewModel.authorizationStatus == .sharingDenied {
                    recoveryCard
                }

                if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
                        primaryButtonLabel
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
                                .background(Color.secondary.opacity(0.12))
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        }
                    }
                }
                .padding(.horizontal, 24)

                Text(footnoteText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Spacer(minLength: 24)
            }
            .padding(.vertical, 24)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: headerSystemImage)
                .font(.system(size: 72))
                .foregroundStyle(headerColor)

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
    }

    private var accessCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.tr("healthKitPermissionAccessSectionTitle"))
                .font(.headline)

            permissionDetailRow(
                title: L10n.tr("healthKitPermissionWaterAccessTitle"),
                description: L10n.tr("healthKitPermissionWaterAccessDescription"),
                systemImage: "drop.fill",
                tint: .teal
            )

            permissionDetailRow(
                title: L10n.tr("healthKitPermissionBodyAccessTitle"),
                description: L10n.tr("healthKitPermissionBodyAccessDescription"),
                systemImage: "figure",
                tint: .blue
            )
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 24)
    }

    private var recoveryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L10n.tr("healthKitPermissionRecoverySectionTitle"))
                .font(.headline)

            permissionDetailRow(
                title: L10n.tr("healthKitPermissionRecoveryOpenSettingsTitle"),
                description: L10n.tr("healthKitPermissionRecoveryOpenSettingsDescription"),
                systemImage: "gearshape.fill",
                tint: .orange
            )

            permissionDetailRow(
                title: L10n.tr("healthKitPermissionRecoveryRefreshTitle"),
                description: L10n.tr("healthKitPermissionRecoveryRefreshDescription"),
                systemImage: "arrow.clockwise.circle.fill",
                tint: .green
            )
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 24)
    }

    private var primaryButtonLabel: some View {
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
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func permissionDetailRow(
        title: String,
        description: String,
        systemImage: String,
        tint: Color
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.headline)
                .foregroundStyle(tint)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.primary)

                Text(description)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var primaryButtonTitle: String {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            return L10n.tr("healthKitPermissionAllowTitle")
        case .sharingDenied:
            return L10n.tr("healthKitPermissionOpenSettingsTitle")
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

    private var footnoteText: String {
        switch viewModel.authorizationStatus {
        case .sharingDenied:
            return L10n.tr("healthKitPermissionSettingsFootnote")
        case .notDetermined, .sharingAuthorized:
            return L10n.tr("healthKitPermissionPrivacyFootnote")
        }
    }

    private var headerSystemImage: String {
        switch viewModel.authorizationStatus {
        case .sharingDenied:
            return "heart.slash"
        case .notDetermined, .sharingAuthorized:
            return "heart.text.square.fill"
        }
    }

    private var headerColor: Color {
        switch viewModel.authorizationStatus {
        case .sharingDenied:
            return .orange
        case .notDetermined, .sharingAuthorized:
            return .teal
        }
    }

    private func openSettings() {
        guard let settingsURL = URL(string: "app-settings:") else {
            return
        }

        openURL(settingsURL)
    }
}
