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
    private let recommendationViewModel: HydrationGoalRecommendationViewModel?

    public init(
        menu: SettingMenu,
        viewModel: SettingsViewModel,
        bodyProfileViewModel: BodyProfileViewModel? = nil,
        recommendationViewModel: HydrationGoalRecommendationViewModel? = nil
    ) {
        self.menu = menu
        self.viewModel = viewModel
        self.bodyProfileViewModel = bodyProfileViewModel
        self.recommendationViewModel = recommendationViewModel
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
                DailyLimitSettingView(
                    viewModel: viewModel,
                    bodyProfileViewModel: bodyProfileViewModel,
                    recommendationViewModel: recommendationViewModel
                )
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
    @Bindable private var viewModel: SettingsViewModel
    private let bodyProfileViewModel: BodyProfileViewModel?
    private let recommendationViewModel: HydrationGoalRecommendationViewModel?

    init(
        viewModel: SettingsViewModel,
        bodyProfileViewModel: BodyProfileViewModel? = nil,
        recommendationViewModel: HydrationGoalRecommendationViewModel? = nil
    ) {
        self.viewModel = viewModel
        self.bodyProfileViewModel = bodyProfileViewModel
        self.recommendationViewModel = recommendationViewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let recommendationViewModel {
                    HydrationGoalRecommendationCard(
                        settingsViewModel: viewModel,
                        bodyProfileViewModel: bodyProfileViewModel,
                        recommendationViewModel: recommendationViewModel
                    )
                }

                VStack(spacing: 20) {
                    HStack {
                        Text(L10n.tr("settingsDailyLimitValueFormat", Int(viewModel.dailyWaterLimit.rounded())))
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }

                    Slider(value: Binding(
                        get: { viewModel.dailyWaterLimit },
                        set: { newValue in
                            viewModel.dailyWaterLimit = newValue
                            recommendationViewModel?.clearRecommendation()
                        }
                    ), in: 1000...4000, step: HydrationServing.defaultGlassML) {
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
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(uiColor: .systemGray6))
                )
            }
            .padding()
        }
        .navigationTitle(L10n.tr("settingDailyLimitTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if let recommendationViewModel {
                await recommendationViewModel.load()
            }
        }
    }
}

private struct HydrationGoalRecommendationCard: View {
    private let settingsViewModel: SettingsViewModel
    private let bodyProfileViewModel: BodyProfileViewModel?
    @Bindable private var recommendationViewModel: HydrationGoalRecommendationViewModel

    init(
        settingsViewModel: SettingsViewModel,
        bodyProfileViewModel: BodyProfileViewModel?,
        recommendationViewModel: HydrationGoalRecommendationViewModel
    ) {
        self.settingsViewModel = settingsViewModel
        self.bodyProfileViewModel = bodyProfileViewModel
        self.recommendationViewModel = recommendationViewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.accentColor)

                        Text(L10n.tr("hydrationGoalRecommendationTitle"))
                            .font(.headline)
                    }

                    Text(L10n.tr("hydrationGoalRecommendationDescription"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

            }

            content
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.accentColor.opacity(0.12),
                            Color(uiColor: .systemGray6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
    }

    @ViewBuilder
    private var content: some View {
        switch recommendationViewModel.state {
        case .idle, .loading:
            HStack(spacing: 12) {
                ProgressView()
                Text(L10n.tr("hydrationGoalRecommendationLoadingDescription"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        case .ready:
            if let recommendation = recommendationViewModel.recommendation {
                recommendationResultContent(recommendation)
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    Text(L10n.tr("hydrationGoalRecommendationReadyDescription"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    primaryAsyncButton(
                        title: recommendationViewModel.isGenerating
                            ? L10n.tr("hydrationGoalRecommendationGeneratingTitle")
                            : L10n.tr("hydrationGoalRecommendationGenerateTitle"),
                        isLoading: recommendationViewModel.isGenerating
                    ) {
                        await recommendationViewModel.generateRecommendation()
                    }

                    if let errorMessage = recommendationViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                    }
                }
            }
        case let .bodyProfileRequired(availability):
            VStack(alignment: .leading, spacing: 14) {
                    Text(bodyProfileDescription(for: availability))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                if bodyProfileViewModel != nil {
                    NavigationLink(value: AppRoute.setting(.bodyProfile)) {
                        actionLabel(
                            title: L10n.tr("hydrationGoalRecommendationBodyProfileActionTitle"),
                            fillsBackground: true
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        case let .modelUnavailable(reason):
            VStack(alignment: .leading, spacing: 10) {
                Text(unavailableDescription(for: reason))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(L10n.tr("hydrationGoalRecommendationUnavailableFootnote"))
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func recommendationResultContent(_ recommendation: HydrationGoalRecommendation) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(L10n.tr("hydrationGoalRecommendationRecommendedLabel"))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(L10n.tr("commonMilliliterFormat", recommendation.recommendedLimitML))
                    .font(.system(size: 34, weight: .bold))
            }

            Text(recommendation.summary)
                .font(.subheadline)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(recommendation.reasons, id: \.self) { reason in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)

                        Text(reason)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }

            if let caution = recommendation.caution {
                Text(caution)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            recommendationMetricGrid(for: recommendation.input)

            VStack(spacing: 10) {
                Button {
                    settingsViewModel.setDailyWaterLimit(
                        Double(recommendation.recommendedLimitML),
                        source: "recommendation"
                    )
                } label: {
                    actionLabel(
                        title: L10n.tr("commonApplyTitle"),
                        fillsBackground: true
                    )
                }
                .buttonStyle(.plain)
                .disabled(Int(settingsViewModel.currentDailyWaterLimit.rounded()) == recommendation.recommendedLimitML)

                    primaryAsyncButton(
                        title: recommendationViewModel.isGenerating
                            ? L10n.tr("hydrationGoalRecommendationGeneratingTitle")
                            : L10n.tr("hydrationGoalRecommendationGenerateTitle"),
                        isLoading: recommendationViewModel.isGenerating,
                        filled: false
                    ) {
                        await recommendationViewModel.generateRecommendation()
                    }
            }
        }
    }

    private func recommendationMetricGrid(for input: HydrationGoalRecommendationInput) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.tr("hydrationGoalRecommendationInputSectionTitle"))
                .font(.subheadline)
                .fontWeight(.semibold)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                metricCard(
                    title: L10n.tr("hydrationGoalRecommendationCurrentGoalTitle"),
                    value: L10n.tr("commonMilliliterFormat", input.currentGoalML)
                )
                metricCard(
                    title: L10n.tr("hydrationGoalRecommendationAverageIntakeTitle"),
                    value: L10n.tr("commonMilliliterFormat", input.recentAverageIntakeML)
                )
                metricCard(
                    title: L10n.tr("hydrationGoalRecommendationBodyProfileTitle"),
                    value: "\(input.heightCM)cm · \(input.weightKG)kg"
                )
                metricCard(
                    title: L10n.tr("hydrationGoalRecommendationGoalAchievementTitle"),
                    value: L10n.tr(
                        "hydrationGoalRecommendationGoalAchievementValueFormat",
                        input.recentGoalAchievementDays,
                        input.analysisDays
                    )
                )
            }
        }
    }

    private func metricCard(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .secondarySystemBackground))
        )
    }

    private func bodyProfileDescription(for availability: BodyProfileAvailability) -> String {
        switch availability {
        case .needsPermission:
            L10n.tr("bodyProfilePermissionNeededDescription")
        case .permissionDenied:
            L10n.tr("bodyProfilePermissionDeniedDescription")
        case .noData:
            L10n.tr("bodyProfileNoDataDescription")
        case .incomplete:
            L10n.tr("bodyProfileIncompleteDescription")
        case .ready:
            L10n.tr("hydrationGoalRecommendationReadyDescription")
        }
    }

    private func unavailableDescription(
        for reason: HydrationGoalRecommendationUnavailableReason
    ) -> String {
        switch reason {
        case .deviceNotEligible:
            L10n.tr("hydrationGoalRecommendationDeviceUnavailableDescription")
        case .appleIntelligenceNotEnabled:
            L10n.tr("hydrationGoalRecommendationAppleIntelligenceDisabledDescription")
        case .modelNotReady:
            L10n.tr("hydrationGoalRecommendationModelNotReadyDescription")
        case .unsupportedLocale:
            L10n.tr("hydrationGoalRecommendationUnsupportedLocaleDescription")
        case .unknown:
            L10n.tr("hydrationGoalRecommendationUnknownUnavailableDescription")
        }
    }

    private func actionLabel(title: String, fillsBackground: Bool) -> some View {
        Text(title)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(fillsBackground ? Color.accentColor : Color.clear)
            )
            .foregroundColor(fillsBackground ? .white : .accentColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        fillsBackground ? Color.clear : Color.accentColor.opacity(0.3),
                        lineWidth: 1
                    )
            )
    }

    private func primaryAsyncButton(
        title: String,
        isLoading: Bool,
        filled: Bool = true,
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
                        .tint(filled ? .white : .accentColor)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(filled ? Color.accentColor : Color.clear)
            )
            .foregroundColor(filled ? .white : .accentColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        filled ? Color.clear : Color.accentColor.opacity(0.3),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
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
