//
//  OnboardingView.swift
//  PresentationLayer
//
//  Created by Codex on 4/3/26.
//

import SwiftUI

public struct OnboardingView: View {
    @Bindable private var viewModel: OnboardingViewModel

    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                TabView(selection: $viewModel.currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        pageView(page)
                            .tag(index)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                footer
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

            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(alignment: .leading, spacing: 24) {
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
                            .font(.system(size: 60, weight: .semibold))
                            .foregroundStyle(.white)

                        Spacer()

                        Text(page.eyebrow)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.white.opacity(0.78))

                        Text(page.title)
                            .font(.system(size: 31, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(28)
                }
                .frame(maxHeight: 360)

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

            Spacer(minLength: 0)
        }
    }

    private var footer: some View {
        VStack(spacing: 14) {
            if viewModel.isLastPage {
                Text("온보딩을 마치면 다음 단계에서 건강 앱 권한을 안내해요.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.62))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }

            HStack(spacing: 12) {
                if viewModel.canGoBack {
                    Button {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.88)) {
                            viewModel.goToPreviousPage()
                        }
                    } label: {
                        Text("이전")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .foregroundStyle(.white)
                            .background(.white.opacity(0.08))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.32, dampingFraction: 0.9)) {
                        viewModel.goToNextPage()
                    }
                } label: {
                    Text(viewModel.isLastPage ? "건강 앱 연동 계속하기" : "다음")
                        .font(.headline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .foregroundStyle(.black)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .padding(.top, 16)
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
                eyebrow: "빠른 기록",
                title: "기록은\n가볍고 빠르게",
                description: "오늘 마신 물을 한 번의 탭으로 기록하고, 현재 목표까지 얼마나 남았는지 바로 확인할 수 있어요.",
                highlights: [
                    "첫 화면에서 바로 물 마시기 기록",
                    "현재 섭취량과 목표 진행률을 즉시 확인"
                ],
                systemImage: "drop.fill",
                panelColors: [
                    Color(red: 0.08, green: 0.47, blue: 0.55),
                    Color(red: 0.11, green: 0.68, blue: 0.70)
                ]
            ),
            OnboardingPage(
                eyebrow: "루틴 흐름",
                title: "흐름은\n한눈에 읽기",
                description: "기록, 인사이트, 챌린지로 하루와 일주일의 수분 루틴을 한 번에 파악할 수 있어요.",
                highlights: [
                    "월별 기록과 최근 패턴을 빠르게 탐색",
                    "챌린지와 인사이트로 루틴 유지 상태 확인"
                ],
                systemImage: "chart.line.uptrend.xyaxis",
                panelColors: [
                    Color(red: 0.18, green: 0.25, blue: 0.56),
                    Color(red: 0.18, green: 0.49, blue: 0.77)
                ]
            ),
            OnboardingPage(
                eyebrow: "건강 연동",
                title: "건강 앱과\n연결해서 시작",
                description: "물리미는 건강 앱과 연동해 수분 기록과 신체 정보를 함께 활용합니다. 온보딩 뒤에 바로 권한을 안내할게요.",
                highlights: [
                    "건강 앱 기반으로 기록과 목표 흐름 유지",
                    "권한 허용 후 앱의 주요 기능을 바로 사용"
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
