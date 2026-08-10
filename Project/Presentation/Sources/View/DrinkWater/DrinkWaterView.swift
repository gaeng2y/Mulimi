//
//  DrinkWaterView.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 8/30/24.
//

import DesignSystem
import DomainLayerInterface
import Localization
import StoreKit
import SwiftUI
import UIKit

public struct DrinkWaterView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.openURL) private var openURL
    @Environment(\.requestReview) private var requestReview
    @Environment(\.scenePhase) private var scenePhase
    private var viewModel: DrinkWaterViewModel
    @State private var isResetConfirmationPresented = false

    private struct AppReviewRequestTaskID: Equatable {
        let requestID: UUID?
        let isSuccessFeedbackVisible: Bool
        let isBlocked: Bool
    }

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
                        nextActionSummary
                            .padding(.top, 8)
                            .padding(.horizontal, 24)
                            .accessibilityElement(children: .combine)

                        Spacer(minLength: 0)

                        waterDropArea(in: proxy.size)

                        progressSummary
                            .padding(.horizontal, 24)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(progressAccessibilityLabel)

                        Spacer(minLength: 0)

                        actionButtons
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)
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
        .task(id: viewModel.recordSuccessFeedbackMessage) {
            guard viewModel.recordSuccessFeedbackMessage != nil else {
                return
            }

            try? await Task.sleep(nanoseconds: 1_400_000_000)
            viewModel.clearRecordSuccessFeedback()
        }
        .task(id: appReviewRequestTaskID) {
            await requestAppReviewIfReady()
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
            Button(L10n.tr("commonConfirmTitle"), role: .cancel) {
                viewModel.clearUndoErrorMessage()
            }
        } message: {
            Text(viewModel.undoErrorMessage ?? "")
        }
        .onDisappear {
            viewModel.cancelPendingAppReviewRequest()
        }
    }

    private var appReviewRequestTaskID: AppReviewRequestTaskID {
        AppReviewRequestTaskID(
            requestID: viewModel.pendingAppReviewRequestID,
            isSuccessFeedbackVisible: viewModel.recordSuccessFeedbackMessage != nil,
            isBlocked: isAppReviewRequestBlocked
        )
    }

    private var isAppReviewRequestBlocked: Bool {
        scenePhase != .active ||
        isResetConfirmationPresented ||
        viewModel.recordFailureAlert != nil ||
        viewModel.undoErrorMessage != nil
    }

    private func requestAppReviewIfReady() async {
        let taskID = appReviewRequestTaskID
        guard let requestID = taskID.requestID else {
            return
        }

        guard !taskID.isBlocked else {
            viewModel.cancelPendingAppReviewRequest(id: requestID)
            return
        }

        guard !taskID.isSuccessFeedbackVisible else {
            return
        }

        do {
            try await Task.sleep(for: .seconds(2))
        } catch {
            return
        }

        guard !isAppReviewRequestBlocked,
              viewModel.recordSuccessFeedbackMessage == nil else {
            viewModel.cancelPendingAppReviewRequest(id: requestID)
            return
        }

        guard viewModel.consumePendingAppReviewRequest(id: requestID) else {
            return
        }

        requestReview()
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
                reduceMotion: reduceMotion
            )
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
            return min(max(size.height * 0.30, 190), 270)
        }

        if size.height < 700 || size.width < 360 {
            return min(max(size.height * 0.36, 220), 300)
        }

        return min(max(size.height * 0.42, 300), 400)
    }

    private var progressSummary: some View {
        VStack(spacing: 8) {
            if usesExpandedVerticalLayout {
                VStack(spacing: 4) {
                    Text(L10n.tr("drinkWaterGlassCountFormat", viewModel.drinkWaterCount))
                        .font(.title)
                    Text(viewModel.mililiters)
                        .font(.callout)
                }
            } else {
                HStack(alignment: .firstTextBaseline) {
                    Text(L10n.tr("drinkWaterGlassCountFormat", viewModel.drinkWaterCount))
                        .font(.title)
                    Text(viewModel.mililiters)
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

    private var nextActionSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(
                viewModel.nextActionBadgeText,
                systemImage: "drop.circle.fill"
            )
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.accent)

            Text(viewModel.nextActionHeadline)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(viewModel.nextActionDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(uiColor: .systemBackground).opacity(0.72))
        )
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.accent.opacity(0.16), lineWidth: 1)
        }
    }

    private var actionButtons: some View {
        HStack(alignment: .center, spacing: 12) {
            defaultDrinkButton
            overflowMenu
        }
    }

    private var defaultDrinkButton: some View {
        Button {
            Task {
                await viewModel.drinkWater()
            }
        } label: {
            defaultDrinkButtonContent
                .font(.headline)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 50)
                .background(defaultDrinkButtonBackground)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .disabled(viewModel.isLimitReached || viewModel.isRecording)
        .accessibilityLabel(defaultDrinkButtonAccessibilityLabel)
        .accessibilityHint(L10n.tr("drinkWaterDefaultRecordAccessibilityHint"))
    }

    @ViewBuilder
    private var defaultDrinkButtonContent: some View {
        if viewModel.isRecording {
            HStack(spacing: 8) {
                ProgressView()
                    .controlSize(.small)
                    .tint(.white)
                    .accessibilityHidden(true)
                Text(L10n.tr("drinkWaterRecordingTitle"))
            }
        } else if let feedbackMessage = viewModel.recordSuccessFeedbackMessage {
            Label(feedbackMessage, systemImage: "checkmark.circle.fill")
        } else {
            Text(
                viewModel.isLimitReached ?
                L10n.tr("drinkWaterButtonReachedTitle") :
                L10n.tr("drinkWaterButtonTitle")
            )
        }
    }

    private var defaultDrinkButtonBackground: Color {
        if viewModel.recordSuccessFeedbackMessage != nil {
            return .green
        }

        if viewModel.isLimitReached {
            return .gray
        }

        return .accent
    }

    private var defaultDrinkButtonAccessibilityLabel: String {
        if viewModel.isRecording {
            return L10n.tr("drinkWaterRecordingAccessibilityLabel")
        }

        if viewModel.recordSuccessFeedbackMessage != nil {
            return L10n.tr("drinkWaterRecordSuccessAccessibilityLabel")
        }

        return L10n.tr(
            "drinkWaterDefaultRecordAccessibilityLabelFormat",
            L10n.tr("commonMilliliterFormat", HydrationServing.defaultGlassVolumeML)
        )
    }

    private var overflowMenu: some View {
        Menu {
            if let recentRecordUndo = viewModel.recentRecordUndo {
                Section(recentRecordUndo.description) {
                    Button {
                        Task {
                            await viewModel.undoRecentRecord()
                        }
                    } label: {
                        Label(
                            recentRecordUndo.actionTitle,
                            systemImage: "arrow.uturn.backward"
                        )
                    }
                }
            }

            Button(role: .destructive) {
                isResetConfirmationPresented = true
            } label: {
                Label(
                    L10n.tr("commonResetTitle"),
                    systemImage: "trash"
                )
            }
        } label: {
            Image(systemName: "ellipsis")
                .font(.headline)
                .frame(width: 56)
                .frame(minHeight: 50)
                .foregroundColor(.primary)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.secondary.opacity(0.12))
                )
        }
        .accessibilityLabel(L10n.tr("drinkWaterMoreActionsAccessibilityLabel"))
        .accessibilityHint(L10n.tr("drinkWaterMoreActionsAccessibilityHint"))
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
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0, paused: reduceMotion)) { context in
            GeometryReader { proxy in
                let size = CGSize(
                    width: max(proxy.size.width, 1),
                    height: max(proxy.size.height, 1)
                )
                let time = reduceMotion ?
                0 :
                context.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 10_000)

                ZStack {
                    dropBackground
                    waterSurface(time: time, size: size)
                    dropHighlights
                }
                .frame(
                    width: proxy.size.width,
                    height: proxy.size.height,
                    alignment: .center
                )
            }
        }
        .accessibilityHidden(true)
    }

    private var dropBackground: some View {
        Image(systemName: appearance.fillSystemImage)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .scaleEffect(x: 1.1, y: 1.1)
            .offset(y: -1)
    }

    private var dropHighlights: some View {
        ZStack {
            dropSymbol
                .foregroundColor(.white.opacity(0.16))
                .scaleEffect(1.015)

            LinearGradient(
                colors: [
                    Color.white.opacity(0.45),
                    Color.white.opacity(0.03),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .mask {
                dropSymbol
            }
            .blendMode(.screen)
            .opacity(0.55)
        }
    }

    private var dropSymbol: some View {
        Image(systemName: appearance.fillSystemImage)
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
    }

    private func waterSurface(time: TimeInterval, size: CGSize) -> some View {
        let library = ShaderLibrary.bundle(Bundle(for: PresentationLayerShaderBundleToken.self))
        let shaderTime = Float(time)
        let shaderProgress = Float(progress)
        let wavePhase = CGFloat(time * 58)

        return ZStack {
            WaterWaveView(
                progress: progress,
                waveHeight: 0.055,
                offset: wavePhase
            )
            .fill(
                LinearGradient(
                    colors: [
                        Color.cyan.opacity(0.9),
                        Color.teal
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .distortionEffect(
                library.mulimiWaterDistortion(
                    .float(shaderTime),
                    .float(shaderProgress),
                    .float2(size)
                ),
                maxSampleOffset: CGSize(width: 12, height: 8)
            )
            .colorEffect(
                library.mulimiWaterLighting(
                    .float(shaderTime),
                    .float(shaderProgress),
                    .float2(size)
                )
            )
            .mask {
                Image(systemName: appearance.fillSystemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }

            WaterWaveView(
                progress: progress,
                waveHeight: 0.025,
                offset: -wavePhase * 0.62 + 140
            )
            .fill(Color.white.opacity(0.28))
            .distortionEffect(
                library.mulimiWaterDistortion(
                    .float(shaderTime + 3.7),
                    .float(shaderProgress),
                    .float2(size)
                ),
                maxSampleOffset: CGSize(width: 8, height: 5)
            )
            .mask {
                Image(systemName: appearance.fillSystemImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .compositingGroup()
        .waterDropGlareEffect()
    }
}

private final class PresentationLayerShaderBundleToken {}
