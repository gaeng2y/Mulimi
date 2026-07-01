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
                    VStack(spacing: 28) {
                        waterDropArea(in: proxy.size)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(progressAccessibilityLabel)

                        actionButtons
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: proxy.size.height, alignment: .center)
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
            return min(max(size.height * 0.38, 220), 320)
        }

        if size.height < 700 || size.width < 360 {
            return min(max(size.height * 0.44, 260), 340)
        }

        return min(max(size.height * 0.52, 320), 460)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            defaultDrinkButton
            resetButton
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
            Text(L10n.tr("commonResetTitle"))
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .foregroundColor(.red)
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
        .accessibilityLabel(L10n.tr("commonResetTitle"))
        .accessibilityHint(L10n.tr("drinkWaterResetAccessibilityHint"))
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(settingsURL)
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
