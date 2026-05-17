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

public struct DrinkWaterView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var viewModel: DrinkWaterViewModel
    @State private var isCustomAmountPresented = false

    public init(viewModel: DrinkWaterViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()

            VStack {
                nextActionCard
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 8)

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
                .frame(height: 360)

                VStack(spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(L10n.tr("drinkWaterGlassCountFormat", viewModel.drinkWaterCount))
                            .font(.title)
                        Text("\(viewModel.mililiters)")
                            .font(.callout)
                    }

                    HStack(alignment: .firstTextBaseline) {
                        Text(L10n.tr("drinkWaterGoalFormat", Int(viewModel.dailyLimit.rounded())))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        if viewModel.isLimitReached {
                            Text(L10n.tr("drinkWaterCompleteLabel"))
                                .font(.caption)
                                .foregroundColor(.green)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .padding()
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(progressAccessibilityLabel)

                servingPresetSection
                    .padding(.horizontal)
                    .padding(.bottom, 8)

                actionButtons

                if let recentRecordUndo = viewModel.recentRecordUndo {
                    recentUndoCard(recentRecordUndo)
                        .padding(.horizontal)
                        .padding(.top, 8)
                }
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
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(L10n.tr("drinkWaterPresetSectionTitle"))
                        .font(.subheadline.weight(.semibold))
                    Text(L10n.tr("drinkWaterPresetSectionDescription"))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

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
                .disabled(viewModel.isLimitReached)
                .accessibilityLabel(L10n.tr("drinkWaterCustomAmountTitle"))
                .accessibilityHint(L10n.tr("drinkWaterCustomAmountAccessibilityHint"))
            }

            HStack(spacing: 10) {
                ForEach(viewModel.servingOptions) { option in
                    servingPresetButton(for: option)
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white.opacity(0.8))
        )
    }

    @ViewBuilder
    private var actionButtons: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: 10) {
                defaultDrinkButton
                resetButton
            }
            .padding(.horizontal)
        } else {
            HStack {
                defaultDrinkButton
                resetButton
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
        Button {
            Task {
                await viewModel.reset()
            }
        } label: {
            Text(L10n.tr("commonResetTitle"))
                .font(.headline)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.white)
                .foregroundColor(.black)
                .cornerRadius(10)
        }
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
                Text(option.volumeText)
                    .font(.footnote)
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

    private func recentUndoCard(_ model: RecentHydrationRecordUndoModel) -> some View {
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

            Spacer()

            Button {
                Task {
                    await viewModel.undoRecentRecord()
                }
            } label: {
                Text(model.actionTitle)
                    .font(.caption.weight(.semibold))
            }
            .buttonStyle(.bordered)
            .accessibilityLabel(model.actionTitle)
            .accessibilityHint(L10n.tr("drinkWaterUndoRecordAccessibilityHint"))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .systemBackground).opacity(0.86))
        )
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
