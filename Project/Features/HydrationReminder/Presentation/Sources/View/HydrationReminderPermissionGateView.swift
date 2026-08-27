//
//  HydrationReminderPermissionGateView.swift
//  HydrationReminder
//
//  Created by Claude on 7/25/26.
//

import Localization
import SwiftUI

public struct HydrationReminderPermissionGateView<Content: View>: View {
    @Bindable private var viewModel: HydrationReminderPermissionViewModel
    private let content: () -> Content

    public init(
        viewModel: HydrationReminderPermissionViewModel,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }

    public var body: some View {
        Group {
            if viewModel.isFinished {
                content()
            } else if viewModel.isPrepared {
                primingView
            } else {
                // 권한이 이미 결정된 사용자(재설치 등)에게 프라이밍이 잠깐
                // 노출되지 않도록 시스템 상태 확인 전에는 빈 화면을 유지한다.
                Color.clear
            }
        }
        .task {
            await viewModel.prepareIfNeeded()
        }
    }

    private var primingView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 24)

                headerSection
                benefitCard

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
                        Task {
                            await viewModel.requestPermission()
                        }
                    } label: {
                        allowButtonLabel
                    }
                    .disabled(viewModel.isLoading)
                    .accessibilityLabel(L10n.tr("hydrationReminderPrimingAllowTitle"))
                    .accessibilityHint(L10n.tr("hydrationReminderPrimingAllowAccessibilityHint"))

                    Button {
                        viewModel.skipPriming()
                    } label: {
                        Text(L10n.tr("hydrationReminderPrimingSkipTitle"))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(minHeight: 52)
                            .foregroundColor(.primary)
                            .background(Color.secondary.opacity(0.12))
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    }
                    .disabled(viewModel.isLoading)
                    .accessibilityHint(L10n.tr("hydrationReminderPrimingSkipAccessibilityHint"))
                }
                .padding(.horizontal, 24)

                Text(L10n.tr("hydrationReminderPrimingFootnote"))
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
            Image(systemName: "bell.badge.fill")
                .font(.system(size: 72))
                .foregroundStyle(.teal)
                .accessibilityHidden(true)

            Text(L10n.tr("hydrationReminderPrimingTitle"))
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(L10n.tr("hydrationReminderPrimingDescription"))
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }

    private var benefitCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(L10n.tr("hydrationReminderPrimingBenefitSectionTitle"))
                .font(.headline)

            benefitRow(
                title: L10n.tr("hydrationReminderPrimingScheduleTitle"),
                description: L10n.tr("hydrationReminderPrimingScheduleDescription"),
                systemImage: "bell.fill",
                tint: .teal
            )

            benefitRow(
                title: L10n.tr("hydrationReminderPrimingHabitTitle"),
                description: L10n.tr("hydrationReminderPrimingHabitDescription"),
                systemImage: "flame.fill",
                tint: .orange
            )

            benefitRow(
                title: L10n.tr("hydrationReminderPrimingControlTitle"),
                description: L10n.tr("hydrationReminderPrimingControlDescription"),
                systemImage: "slider.horizontal.3",
                tint: .blue
            )
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.secondary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 24)
    }

    private var allowButtonLabel: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
            } else {
                Text(L10n.tr("hydrationReminderPrimingAllowTitle"))
                    .font(.headline)
                    .fontWeight(.semibold)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 52)
        .foregroundColor(.white)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func benefitRow(
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
                .accessibilityHidden(true)

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
        .accessibilityElement(children: .combine)
    }
}
