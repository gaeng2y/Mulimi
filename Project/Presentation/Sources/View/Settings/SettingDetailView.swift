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

public struct SettingDetailView: View {
    let menu: SettingMenu
    private let viewModel: SettingsViewModel
    
    public init(menu: SettingMenu, viewModel: SettingsViewModel) {
        self.menu = menu
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            switch menu {
            case .dailyLimit:
                DailyLimitSettingView(viewModel: viewModel)
            case .mainShape:
                MainShapeSettingView(viewModel: viewModel)
            case .withdrawal:
                WithdrawalSettingView(viewModel: viewModel)
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}

// MARK: - Setting Detail Views
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

private struct MainShapeSettingView: View {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(MainAppearance.allCases) { appearance in
                Button {
                    viewModel.selectMainAppearance(appearance)
                } label: {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: appearance.systemImage)
                                .font(.title2)
                                .frame(width: 40)
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appearance.displayName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(appearance.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            if viewModel.isMainAppearanceSelected(appearance) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.title3)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.isMainAppearanceSelected(appearance) ?
                                  Color.accentColor.opacity(0.1) :
                                    Color(uiColor: .systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                viewModel.isMainAppearanceSelected(appearance) ?
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
