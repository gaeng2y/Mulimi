//
//  DrinkWaterView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 8/30/24.
//

import DesignSystem
import DomainLayerInterface
import Localization
import SwiftUI
import UIKit

public struct DrinkWaterView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.openURL) private var openURL
    private var viewModel: DrinkWaterViewModel
    @State private var isCustomAmountPresented = false
    @State private var isResetConfirmationPresented = false

    public init(viewModel: DrinkWaterViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        nextActionCard
                            .padding(.horizontal)
                            .padding(.top, 12)
                            .padding(.bottom, 8)

                        waterDropArea(in: proxy.size)

                        progressSummary
                            .padding()
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(progressAccessibilityLabel)

                        servingPresetSection
                            .padding(.horizontal)
                            .padding(.bottom, 8)

                        defaultDrinkButton
                            .padding(.horizontal)

                        if let recentRecordUndo = viewModel.recentRecordUndo {
                            recentUndoCard(recentRecordUndo)
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }

                        resetButton
                            .padding(.horizontal)
                            .padding(.top, 4)
                            .padding(.bottom, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: proxy.size.height, alignment: .top)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
        }
        .task {
            // Refresh data when view appears to catch any Widget changes.
            await viewModel.loadInitialState()
        }
        .task {
            // Start the repeating wave after the initial frame is committed.
            guard !reduceMotion else {
                viewModel.resetAnimation()
                return
            }
            viewModel.resetAnimation()
            await Task.yield()
            viewModel.startAnimation()
        }
        .sheet(isPresented: $isCustomAmountPresented) {
            CustomHydrationAmountSheet(viewModel: viewModel)
        }
        .alert(
            L10n.tr("drinkWaterResetConfirmationTitle"),
            isPresented: $isResetConfirmationPresented
        ) {
            Button(
                L10n.tr("drinkWaterResetConfirmationActionTitle"),
                role: .destructive
            ) {
                Task {
                    await viewModel.reset()
                }
            }

            Button(L10n.tr("commonCancelTitle"), role: .cancel) {}
        } message: {
            Text(L10n.tr("drinkWaterResetConfirmationMessage"))
        }
        .alert(
            viewModel.recordFailureAlert?.title ?? "",
            isPresented: Binding(
                get: { viewModel.recordFailureAlert != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.clearRecordFailureAlert()
                    }
                }
            )
        ) {
            if viewModel.recordFailureAlert?.showsOpenSettingsAction == true {
                Button(L10n.tr("healthKitPermissionOpenSettingsTitle")) {
                    openSettings()
                    viewModel.clearRecordFailureAlert()
                }
            }

            Button(L10n.tr("commonConfirmTitle"), role: .cancel) {
                viewModel.clearRecordFailureAlert()
            }
        } message: {
            Text(viewModel.recordFailureAlert?.message ?? "")
        }
        .alert(
            L10n.tr("drinkWaterUndoRecordFailureTitle"),
            isPresented: Binding(
                get: { viewModel.undoErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.clearUndoErrorMessage()
                    }
                }
            )
        ) {
            Button(L10n.tr("commonConfirmTitle")) {
                viewModel.clearUndoErrorMessage()
            }
        } message: {
            Text(viewModel.undoErrorMessage ?? "")
        }
    }

    private var waterDropAnimation: Animation? {
        guard !reduceMotion else {
            return nil
        }

        return .linear(duration: 2.0).repeatForever(autoreverses: false)
    }

    private var progressAccessibilityLabel: String {
        L10n.tr(
            "drinkWaterProgressAccessibilityLabelFormat",
            viewModel.mililiters,
            L10n.tr("commonMilliliterFormat", Int(viewModel.dailyLimit.rounded())),
            Int((viewModel.progress * 100).rounded())
        )
    }

    private var usesExpandedVerticalLayout: Bool {
        dynamicTypeSize.isAccessibilitySize
    }

    private func waterDropArea(in size: CGSize) -> some View {
        GeometryReader { proxy in
            let dropSize = min(proxy.size.width, proxy.size.height) * 0.88

            WaterDropView(
                appearance: viewModel.mainIcon,
                progress: viewModel.progress,
                offset: viewModel.offset
            )
            .animation(waterDropAnimation, value: viewModel.offset)
            .frame(
                width: dropSize,
                height: dropSize,
                alignment: .center
            )
            .frame(
                width: proxy.size.width,
                height: proxy.size.height,
                alignment: .center
            )
        }
        .frame(height: waterDropAreaHeight(for: size))
    }

    private func waterDropAreaHeight(for size: CGSize) -> CGFloat {
        if dynamicTypeSize.isAccessibilitySize {
            return min(max(size.height * 0.28, 180), 260)
        }

        if size.height < 700 || size.width < 360 {
            return min(max(size.height * 0.32, 200), 280)
        }

        return min(max(size.height * 0.38, 280), 360)
    }

    private var progressSummary: some View {
        VStack(spacing: 8) {
            if usesExpandedVerticalLayout {
                VStack(spacing: 4) {
                    Text(L10n.tr("drinkWaterGlassCountFormat", viewModel.drinkWaterCount))
                        .font(.title)
                    Text("\(viewModel.mililiters)")
                        .font(.callout)
                }
            } else {
                HStack(alignment: .firstTextBaseline) {
                    Text(L10n.tr("drinkWaterGlassCountFormat", viewModel.drinkWaterCount))
                        .font(.title)
                    Text("\(viewModel.mililiters)")
                        .font(.callout)
                }
            }

            if usesExpandedVerticalLayout {
                VStack(spacing: 4) {
                    goalText
                    completionText
                }
            } else {
                HStack(alignment: .firstTextBaseline) {
                    goalText
                    completionText
                }
            }
        }
    }

    private var goalText: some View {
        Text(L10n.tr("drinkWaterGoalFormat", Int(viewModel.dailyLimit.rounded())))
            .font(.caption)
            .foregroundColor(.secondary)
    }

    @ViewBuilder
    private var completionText: some View {
        if viewModel.isLimitReached {
            Text(L10n.tr("drinkWaterCompleteLabel"))
                .font(.caption)
                .foregroundColor(.green)
                .fontWeight(.semibold)
        }
    }

    private var nextActionCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.caption.weight(.semibold))

                Text(viewModel.nextActionBadgeText)
                    .font(.caption.weight(.semibold))
            }
            .foregroundColor(.accentColor)

            Text(viewModel.nextActionHeadline)
                .font(.headline)
                .foregroundColor(.primary)

            Text(viewModel.nextActionDescription)
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.accent.opacity(0.12))
        )
    }

    private var servingPresetSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            servingPresetHeader
            servingPresetButtons
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white.opacity(0.8))
        )
    }

    @ViewBuilder
    private var servingPresetHeader: some View {
        if usesExpandedVerticalLayout {
            VStack(alignment: .leading, spacing: 10) {
                servingPresetCopy
                customAmountButton
            }
        } else {
            HStack {
                servingPresetCopy
                Spacer()
                customAmountButton
            }
        }
    }

    private var servingPresetCopy: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(L10n.tr("drinkWaterPresetSectionTitle"))
                .font(.subheadline.weight(.semibold))
            Text(L10n.tr("drinkWaterPresetSectionDescription"))
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var customAmountButton: some View {
        Button {
            isCustomAmountPresented = true
        } label: {
            Text(L10n.tr("drinkWaterCustomAmountTitle"))
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.accent.opacity(0.14))
                .foregroundColor(.accentColor)
                .clipShape(Capsule())
        }
        .frame(maxWidth: usesExpandedVerticalLayout ? .infinity : nil, alignment: .leading)
        .disabled(viewModel.isLimitReached)
        .accessibilityLabel(L10n.tr("drinkWaterCustomAmountTitle"))
        .accessibilityHint(L10n.tr("drinkWaterCustomAmountAccessibilityHint"))
    }

    @ViewBuilder
    private var servingPresetButtons: some View {
        if usesExpandedVerticalLayout {
            VStack(spacing: 10) {
                ForEach(viewModel.servingOptions) { option in
                    servingPresetButton(for: option)
                }
            }
        } else {
            HStack(spacing: 10) {
                ForEach(viewModel.servingOptions) { option in
                    servingPresetButton(for: option)
                }
            }
        }
    }

    private var defaultDrinkButton: some View {
        Button {
            Task {
                await viewModel.drinkWater()
            }
        } label: {
            Text(
                viewModel.isLimitReached ?
                L10n.tr("drinkWaterButtonReachedTitle") :
                L10n.tr("drinkWaterButtonTitle")
            )
                .font(.headline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.isLimitReached ? Color.gray : Color.accent)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(viewModel.isLimitReached)
        .accessibilityLabel(
            L10n.tr(
                "drinkWaterDefaultRecordAccessibilityLabelFormat",
                L10n.tr("commonMilliliterFormat", HydrationServing.defaultGlassVolumeML)
            )
        )
        .accessibilityHint(L10n.tr("drinkWaterDefaultRecordAccessibilityHint"))
    }

    private var resetButton: some View {
        Button(role: .destructive) {
            isResetConfirmationPresented = true
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "trash")
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(.red)
                    .frame(width: 18, height: 18)

                VStack(alignment: .leading, spacing: 3) {
                    Text(L10n.tr("drinkWaterResetTodayRecordsTitle"))
                        .font(.footnote.weight(.semibold))
                        .foregroundColor(.red)

                    Text(L10n.tr("drinkWaterResetTodayRecordsDescription"))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.red.opacity(0.07))
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.red.opacity(0.18), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.tr("drinkWaterResetTodayRecordsTitle"))
        .accessibilityHint(L10n.tr("drinkWaterResetAccessibilityHint"))
    }

    private func servingPresetButton(for option: HydrationServingOptionModel) -> some View {
        let isEnabled = viewModel.isRecordable(volumeML: option.volumeML)

        return Button {
            Task {
                await viewModel.recordPresetWater(volumeML: option.volumeML)
            }
        } label: {
            VStack(spacing: 4) {
                Text(option.title)
                    .font(.caption.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                Text(option.volumeText)
                    .font(.footnote)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isEnabled ? Color.accent.opacity(0.14) : Color.gray.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(isEnabled ? Color.accent.opacity(0.3) : Color.gray.opacity(0.25), lineWidth: 1)
            )
            .foregroundColor(isEnabled ? .primary : .secondary)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityLabel(
            L10n.tr(
                "drinkWaterPresetRecordAccessibilityLabelFormat",
                option.title,
                option.volumeText
            )
        )
        .accessibilityHint(L10n.tr("drinkWaterPresetRecordAccessibilityHint"))
    }

    @ViewBuilder
    private func recentUndoCard(_ model: RecentHydrationRecordUndoModel) -> some View {
        if usesExpandedVerticalLayout {
            VStack(alignment: .leading, spacing: 12) {
                recentUndoContent(model)
                recentUndoButton(model)
            }
            .padding(14)
            .background(recentUndoCardBackground)
        } else {
            HStack(alignment: .top, spacing: 12) {
                recentUndoContent(model)

                Spacer()

                recentUndoButton(model)
            }
            .padding(14)
            .background(recentUndoCardBackground)
        }
    }

    private func recentUndoContent(_ model: RecentHydrationRecordUndoModel) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "arrow.uturn.backward.circle.fill")
                .font(.title3)
                .foregroundColor(.accentColor)

            VStack(alignment: .leading, spacing: 4) {
                Text(model.title)
                    .font(.subheadline.weight(.semibold))

                Text(model.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func recentUndoButton(_ model: RecentHydrationRecordUndoModel) -> some View {
        Button {
            Task {
                await viewModel.undoRecentRecord()
            }
        } label: {
            Text(model.actionTitle)
                .font(.caption.weight(.semibold))
                .frame(maxWidth: usesExpandedVerticalLayout ? .infinity : nil)
        }
        .buttonStyle(.bordered)
        .accessibilityLabel(model.actionTitle)
        .accessibilityHint(L10n.tr("drinkWaterUndoRecordAccessibilityHint"))
    }

    private var recentUndoCardBackground: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(Color(uiColor: .systemBackground).opacity(0.86))
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(settingsURL)
    }
}

fileprivate struct CustomHydrationAmountSheet: View {
    let viewModel: DrinkWaterViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var amountText = ""

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(L10n.tr("drinkWaterCustomAmountDescription"))
                    .font(.body)
                    .foregroundColor(.secondary)

                TextField(L10n.tr("drinkWaterCustomAmountPlaceholder"), text: $amountText)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .accessibilityLabel(L10n.tr("drinkWaterCustomAmountTitle"))
                    .accessibilityHint(L10n.tr("drinkWaterCustomAmountAccessibilityHint"))

                if let errorMessage = viewModel.customAmountErrorMessage(for: amountText) {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
            .navigationTitle(L10n.tr("drinkWaterCustomAmountTitle"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.tr("commonCancelTitle")) {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.tr("drinkWaterCustomAmountRecordTitle")) {
                        Task {
                            let didRecord = await viewModel.recordCustomAmount(amountText)
                            if didRecord {
                                dismiss()
                            }
                        }
                    }
                    .disabled(!viewModel.canRecordCustomAmount(amountText))
                }
            }
        }
        .presentationDetents([.medium])
    }
}

fileprivate struct WaterDropView: View {
    let appearance: MainIcon
    let progress: CGFloat
    let offset: CGFloat

    var body: some View {
        ZStack {
            Image(systemName: appearance.fillSystemImage)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .scaleEffect(x: 1.1, y: 1.1)
                .offset(y: -1)

            WaterWaveView(
                progress: progress,
                waveHeight: 0.1,
                offset: offset
            )
            .fill(.teal)
            .waterDropGlareEffect()
            .mask {
                Image(systemName: appearance.fillSystemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .accessibilityHidden(true)
    }
}
