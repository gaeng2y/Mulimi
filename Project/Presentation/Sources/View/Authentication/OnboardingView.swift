//
//  OnboardingView.swift
//  PresentationLayer
//
//  Created by Codex on 4/3/26.
//

import Localization
import SwiftUI

public struct OnboardingView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Bindable private var viewModel: OnboardingViewModel

    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            GeometryReader { proxy in
                VStack(spacing: 0) {
                    header

                    TabView(selection: $viewModel.currentPage) {
                        ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                            ScrollView(showsIndicators: false) {
                                pageView(page, in: proxy.size)
                                    .padding(.horizontal, 24)
                                    .padding(.top, 20)
                                    .padding(.bottom, 18)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                            }
                            .scrollBounceBehavior(.basedOnSize)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(maxHeight: .infinity)

                    footer
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Capsule()
                .fill(.white.opacity(0.14))
                .frame(width: 64, height: 32)
                .overlay {
                    Text("\(viewModel.currentPage + 1) / \(viewModel.pageCount)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.9))
                }
                .accessibilityLabel(
                    L10n.tr(
                        "onboardingPageProgressAccessibilityLabelFormat",
                        viewModel.currentPage + 1,
                        viewModel.pageCount
                    )
                )

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    private func pageView(_ page: OnboardingPage, in size: CGSize) -> some View {
        let isCompact = isCompactLayout(for: size)

        return VStack(alignment: .leading, spacing: isCompact ? 18 : 24) {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: page.panelColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(alignment: .topLeading) {
                    Circle()
                        .fill(.white.opacity(0.14))
                        .frame(width: 160, height: 160)
                        .offset(x: -36, y: -48)
                }
                .overlay(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(.black.opacity(0.12))
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(18))
                        .offset(x: 30, y: 34)
                }
                .overlay {
                    VStack(alignment: .leading, spacing: 20) {
                        Image(systemName: page.systemImage)
                            .font(.system(size: isCompact ? 46 : 60, weight: .semibold))
                            .foregroundStyle(.white)

                        Spacer(minLength: isCompact ? 12 : 24)

                        Text(page.eyebrow)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.78))

                        Text(page.title)
                            .font(
                                .system(
                                    isCompact ? .title2 : .largeTitle,
                                    design: .rounded,
                                    weight: .bold
                                )
                            )
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(isCompact ? 22 : 28)
                }
                .frame(height: panelHeight(for: size))

            VStack(alignment: .leading, spacing: 18) {
                Text(page.description)
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(page.highlights, id: \.self) { highlight in
                        HStack(alignment: .top, spacing: 10) {
                            RoundedRectangle(cornerRadius: 3, style: .continuous)
                                .fill(.teal)
                                .frame(width: 6, height: 18)
                                .padding(.top, 2)

                            Text(highlight)
                                .font(.subheadline.weight(.medium))
                                .foregroundStyle(.white)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
        }
    }

    private func isCompactLayout(for size: CGSize) -> Bool {
        dynamicTypeSize.isAccessibilitySize || size.height < 720 || size.width < 360
    }

    private func panelHeight(for size: CGSize) -> CGFloat {
        if dynamicTypeSize.isAccessibilitySize {
            return min(max(size.height * 0.42, 300), 400)
        }

        if size.height < 720 || size.width < 360 {
            return min(max(size.height * 0.34, 220), 300)
        }

        return min(max(size.height * 0.40, 300), 360)
    }

    private var footer: some View {
        VStack(spacing: 14) {
            if viewModel.isLastPage {
                Text(L10n.tr("onboardingHealthKitPermissionFootnote"))
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.62))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            footerActions
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
        }
        .padding(.top, 16)
    }

    @ViewBuilder
    private var footerActions: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(spacing: 12) {
                if viewModel.canGoBack {
                    previousButton
                }
                nextButton
            }
        } else {
            HStack(spacing: 12) {
                if viewModel.canGoBack {
                    previousButton
                }
                nextButton
            }
        }
    }

    private var previousButton: some View {
        Button {
            performPageTransition(response: 0.32, dampingFraction: 0.88) {
                viewModel.goToPreviousPage()
            }
        } label: {
            Text(L10n.tr("onboardingPreviousTitle"))
                .font(.headline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 54)
                .foregroundStyle(.white)
                .background(.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private var nextButton: some View {
        Button {
            performPageTransition(response: 0.32, dampingFraction: 0.9) {
                viewModel.goToNextPage()
            }
        } label: {
            Text(
                viewModel.isLastPage ?
                L10n.tr("onboardingHealthKitContinueTitle") :
                L10n.tr("onboardingNextTitle")
            )
                .font(.headline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .frame(minHeight: 54)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private func performPageTransition(
        response: Double,
        dampingFraction: Double,
        action: () -> Void
    ) {
        if reduceMotion {
            action()
        } else {
            withAnimation(.spring(response: response, dampingFraction: dampingFraction)) {
                action()
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.03, green: 0.10, blue: 0.15),
                Color(red: 0.04, green: 0.18, blue: 0.22),
                Color(red: 0.07, green: 0.33, blue: 0.34)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var pages: [OnboardingPage] {
        [
            OnboardingPage(
                eyebrow: L10n.tr("onboardingQuickRecordEyebrow"),
                title: L10n.tr("onboardingQuickRecordTitle"),
                description: L10n.tr("onboardingQuickRecordDescription"),
                highlights: [
                    L10n.tr("onboardingQuickRecordHighlightPrimary"),
                    L10n.tr("onboardingQuickRecordHighlightSecondary")
                ],
                systemImage: "drop.fill",
                panelColors: [
                    Color(red: 0.08, green: 0.47, blue: 0.55),
                    Color(red: 0.11, green: 0.68, blue: 0.70)
                ]
            ),
            OnboardingPage(
                eyebrow: L10n.tr("onboardingRoutineFlowEyebrow"),
                title: L10n.tr("onboardingRoutineFlowTitle"),
                description: L10n.tr("onboardingRoutineFlowDescription"),
                highlights: [
                    L10n.tr("onboardingRoutineFlowHighlightPrimary"),
                    L10n.tr("onboardingRoutineFlowHighlightSecondary")
                ],
                systemImage: "chart.line.uptrend.xyaxis",
                panelColors: [
                    Color(red: 0.18, green: 0.25, blue: 0.56),
                    Color(red: 0.18, green: 0.49, blue: 0.77)
                ]
            ),
            OnboardingPage(
                eyebrow: L10n.tr("onboardingHealthLinkEyebrow"),
                title: L10n.tr("onboardingHealthLinkTitle"),
                description: L10n.tr("onboardingHealthLinkDescription"),
                highlights: [
                    L10n.tr("onboardingHealthLinkHighlightPrimary"),
                    L10n.tr("onboardingHealthLinkHighlightSecondary")
                ],
                systemImage: "heart.text.square.fill",
                panelColors: [
                    Color(red: 0.13, green: 0.38, blue: 0.33),
                    Color(red: 0.16, green: 0.62, blue: 0.49)
                ]
            )
        ]
    }
}

private struct OnboardingPage {
    let eyebrow: String
    let title: String
    let description: String
    let highlights: [String]
    let systemImage: String
    let panelColors: [Color]
}
