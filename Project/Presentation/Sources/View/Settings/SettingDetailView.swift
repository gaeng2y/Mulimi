//
//  SettingDetailView.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Localization
import SwiftUI
import UIKit

public struct SettingDetailView: View {
    let menu: SettingMenu
    private let viewModel: SettingsViewModel
    private let bodyProfileViewModel: BodyProfileViewModel?
    
    public init(
        menu: SettingMenu,
        viewModel: SettingsViewModel,
        bodyProfileViewModel: BodyProfileViewModel? = nil
    ) {
        self.menu = menu
        self.viewModel = viewModel
        self.bodyProfileViewModel = bodyProfileViewModel
    }
    
    public var body: some View {
        Group {
            switch menu {
            case .bodyProfile:
                if let bodyProfileViewModel {
                    BodyProfileSettingView(viewModel: bodyProfileViewModel)
                } else {
                    EmptyView()
                }
            case .dailyLimit:
                DailyLimitSettingView(viewModel: viewModel)
            case .mainIcon:
                MainIconSettingView(viewModel: viewModel)
            case .withdrawal:
                WithdrawalSettingView(viewModel: viewModel)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Setting Detail Views
private struct BodyProfileSettingView: View {
    @Bindable private var viewModel: BodyProfileViewModel
    @Environment(\.openURL) private var openURL

    init(viewModel: BodyProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                summaryCard
                healthSyncCard
                manualInputCard
            }
            .padding()
        }
        .navigationTitle(L10n.tr("settingBodyProfileTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.tr("bodyProfileSummaryCardTitle"))
                .font(.headline)

            profileMetricRow(
                title: L10n.tr("bodyProfileHeightTitle"),
                value: viewModel.resolvedHeightText ?? L10n.tr("bodyProfileMissingValue"),
                source: viewModel.heightSourceText
            )

            profileMetricRow(
                title: L10n.tr("bodyProfileWeightTitle"),
                value: viewModel.resolvedWeightText ?? L10n.tr("bodyProfileMissingValue"),
                source: viewModel.weightSourceText
            )

            Text(L10n.tr("bodyProfileSourcePriorityDescription"))
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .systemGray6))
        )
    }

    private var healthSyncCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L10n.tr("bodyProfileHealthKitSectionTitle"))
                .font(.headline)

            Text(viewModel.helperText)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundColor(.red)
            }

            switch viewModel.availabilityState {
            case .needsPermission:
                primaryButton(
                    title: L10n.tr("bodyProfileConnectHealthKitTitle"),
                    isLoading: viewModel.isLoading
                ) {
                    await viewModel.requestHealthKitBodyProfile()
                }
            case .permissionDenied:
                VStack(spacing: 10) {
                    primaryButton(
                        title: L10n.tr("bodyProfileOpenSettingsTitle"),
                        isLoading: false
                    ) {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            openURL(url)
                        }
                    }

                    secondaryAsyncButton(title: L10n.tr("bodyProfileRetryHealthSyncTitle")) {
                        await viewModel.requestHealthKitBodyProfile()
                    }
                }
            case .noData, .incomplete, .ready:
                primaryButton(
                    title: L10n.tr("bodyProfileRetryHealthSyncTitle"),
                    isLoading: viewModel.isLoading
                ) {
                    await viewModel.requestHealthKitBodyProfile()
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .systemGray6))
        )
    }

    private var manualInputCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(L10n.tr("bodyProfileManualSectionTitle"))
                .font(.headline)

            Text(L10n.tr("bodyProfileManualSectionDescription"))
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 12) {
                TextField(
                    L10n.tr("bodyProfileHeightPlaceholder"),
                    text: $viewModel.heightInput
                )
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .secondarySystemBackground))
                )

                TextField(
                    L10n.tr("bodyProfileWeightPlaceholder"),
                    text: $viewModel.weightInput
                )
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .secondarySystemBackground))
                )
            }

            secondaryButton(title: viewModel.manualSaveButtonTitle) {
                viewModel.saveManualBodyProfile()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(uiColor: .systemGray6))
        )
    }

    private func profileMetricRow(title: String, value: String, source: String?) -> some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
            }

            Spacer()

            if let source {
                Text(source)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
        }
    }

    private func primaryButton(
        title: String,
        isLoading: Bool,
        action: @escaping () async -> Void
    ) -> some View {
        Button {
            Task {
                await action()
            }
        } label: {
            HStack {
                Spacer()

                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }

                Spacer()
            }
            .padding()
            .background(Color.accentColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private func secondaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func secondaryAsyncButton(
        title: String,
        action: @escaping () async -> Void
    ) -> some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.accentColor.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct DailyLimitSettingView: View {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(L10n.tr("settingsDailyLimitValueFormat", Int(viewModel.dailyWaterLimit.rounded())))
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            
            Slider(value: Binding(
                get: { viewModel.dailyWaterLimit },
                set: {
                    viewModel.dailyWaterLimit = $0
                }
            ), in: 1000...4000, step: 250) {
                Text(L10n.tr("settingsDailyLimitSliderTitle"))
            }
            .padding(.horizontal)
            
            HStack {
                Text(L10n.tr("commonMilliliterFormat", 1000))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text(L10n.tr("commonMilliliterFormat", 4000))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle(L10n.tr("settingDailyLimitTitle"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct MainIconSettingView: View {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(MainIcon.allCases) { icon in
                Button {
                    viewModel.selectMainIcon(icon)
                } label: {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: icon.systemImage)
                                .font(.title2)
                                .frame(width: 40)
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(icon.displayName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(icon.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            if viewModel.isMainIconSelected(icon) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.title3)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.isMainIconSelected(icon) ?
                                  Color.accentColor.opacity(0.1) :
                                    Color(uiColor: .systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                viewModel.isMainIconSelected(icon) ?
                                Color.accentColor.opacity(0.3) :
                                    Color.clear,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle(L10n.tr("settingMainShapeTitle"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct WithdrawalSettingView: View {
    @Bindable private var viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)

                Text(L10n.tr("settingWithdrawalTitle"))
                    .font(.title2)
                    .fontWeight(.bold)

                Text(L10n.tr("withdrawalDescription"))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.top, 40)

            VStack(alignment: .leading, spacing: 12) {
                Label(L10n.tr("withdrawalDeleteRecordsItem"), systemImage: "drop.fill")
                Label(L10n.tr("withdrawalDeletePreferencesItem"), systemImage: "gearshape.fill")
                Label(L10n.tr("withdrawalDeleteAccountItem"), systemImage: "person.fill")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(uiColor: .systemGray6))
            )
            .padding(.horizontal)

            Spacer()

            Button {
                viewModel.requestWithdrawal()
            } label: {
                Text(L10n.tr("withdrawalActionTitle"))
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle(L10n.tr("settingWithdrawalTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .alert(L10n.tr("withdrawalConfirmationTitle"), isPresented: $viewModel.showWithdrawalConfirmation) {
            Button(L10n.tr("commonCancelTitle"), role: .cancel) {
                viewModel.cancelWithdrawal()
            }
            Button(L10n.tr("commonWithdrawTitle"), role: .destructive) {
                Task {
                    await viewModel.confirmWithdrawal()
                }
            }
        } message: {
            Text(L10n.tr("withdrawalConfirmationMessage"))
        }
        .alert(L10n.tr("withdrawalFailureTitle"), isPresented: .constant(viewModel.withdrawalError != nil)) {
            Button(L10n.tr("commonConfirmTitle"), role: .cancel) {
                viewModel.withdrawalError = nil
            }
        } message: {
            if let error = viewModel.withdrawalError {
                Text(error)
            }
        }
        .overlay {
            if viewModel.isWithdrawing {
                ZStack {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    
                    ProgressView(L10n.tr("withdrawalProgressTitle"))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(uiColor: .systemBackground))
                        )
                }
            }
        }
    }
}
