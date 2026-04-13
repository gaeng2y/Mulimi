import DomainLayerInterface
import Localization
import SwiftUI
import UIKit

public struct ProfileRoutineView: View {
    @Environment(\.openURL) private var openURL
    @Bindable private var viewModel: ProfileRoutineViewModel
    @State private var hasAppliedInitialAction = false
    private let initialAction: RoutineActionIntent?

    public init(
        viewModel: ProfileRoutineViewModel,
        initialAction: RoutineActionIntent? = nil
    ) {
        self.viewModel = viewModel
        self.initialAction = initialAction
    }

    public var body: some View {
        List {
            Section(L10n.tr("profileRoutineGuidanceSectionTitle")) {
                guidanceCard
            }

            if !viewModel.recommendationCards.isEmpty {
                Section(
                    content: {
                    ForEach(viewModel.recommendationCards) { recommendation in
                        recommendationCard(recommendation)
                    }
                    },
                    header: {
                        Text(L10n.tr("profileRoutineRecommendationSectionTitle"))
                    },
                    footer: {
                        Text(L10n.tr("profileRoutineRecommendationSectionFootnote"))
                    }
                )
            }

            permissionSection

            Section {
                if viewModel.displayedRoutines.isEmpty {
                    Text(L10n.tr("profileRoutineNoSchedulesDescription"))
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.displayedRoutines) { routine in
                        Button {
                            viewModel.presentEditRoutine(routine)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(routine.title)
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Spacer()

                                    Text(routine.isEnabled ? L10n.tr("profileRoutineEnabledBadge") : L10n.tr("profileRoutineDisabledBadge"))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(routine.isEnabled ? .accentColor : .secondary)
                                }

                                Text("\(routine.timeText) · \(routine.weekdayText)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                        .swipeActions {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteRoutine(routine)
                                }
                            } label: {
                                Text(L10n.tr("commonDeleteTitle"))
                            }
                        }
                    }
                }
            } header: {
                HStack {
                    Text(L10n.tr("profileRoutineSchedulesSectionTitle"))

                    Spacer()

                    Text(viewModel.summaryBadgeText)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle(L10n.tr("profileRoutineSectionTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.presentCreateRoutine()
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(L10n.tr("profileRoutineAddTitle"))
            }
        }
        .sheet(
            isPresented: Binding(
                get: { viewModel.isEditorPresented },
                set: { if !$0 { viewModel.dismissEditor() } }
            )
        ) {
            RoutineEditorView(viewModel: viewModel)
        }
        .task {
            await viewModel.load()
            applyInitialActionIfNeeded()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            Task {
                await viewModel.load()
            }
        }
        .alert(
            L10n.tr("profileRoutineAlertTitle"),
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.clearErrorMessage() } }
            )
        ) {
            Button(L10n.tr("commonConfirmTitle")) {
                viewModel.clearErrorMessage()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    private var guidanceCard: some View {
        let summary = viewModel.guidanceSummary

        return VStack(alignment: .leading, spacing: 16) {
            Text(summary.badgeText)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(guidanceToneColor(summary.tone))

            Text(summary.headline)
                .font(.headline)

            Text(summary.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if !summary.metrics.isEmpty {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ],
                    spacing: 10
                ) {
                    ForEach(summary.metrics) { metric in
                        guidanceMetric(metric)
                    }
                }
            }

            if let nextRoutineValueText = summary.nextRoutineValueText,
               let remainingRoutineValueText = summary.remainingRoutineValueText {
                HStack(spacing: 10) {
                    guidanceInfoCard(
                        title: L10n.tr("profileRoutineGuidanceNextRoutineTitle"),
                        value: nextRoutineValueText,
                        systemImage: "clock"
                    )

                    guidanceInfoCard(
                        title: L10n.tr("profileRoutineGuidanceRemainingTitle"),
                        value: remainingRoutineValueText,
                        systemImage: "list.bullet"
                    )
                }
            }

            if !summary.slots.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.tr("profileRoutineGuidanceTimelineTitle"))
                        .font(.caption)
                        .foregroundColor(.secondary)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(summary.slots) { slot in
                                guidanceSlotChip(slot)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
            }

            Text(summary.footnote)
                .font(.footnote)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var permissionSection: some View {
        switch viewModel.notificationStatus {
        case .notDetermined:
            Section {
                Button(L10n.tr("profileRoutineRequestPermissionTitle")) {
                    Task {
                        await viewModel.requestNotificationAuthorization()
                    }
                }
            } header: {
                Text(L10n.tr("profileRoutineNotificationStatusTitle"))
            } footer: {
                Text(L10n.tr("profileRoutinePermissionPrompt"))
            }
        case .denied:
            Section {
                Button(L10n.tr("profileRoutineOpenSettingsTitle")) {
                    openSettings()
                }
            } header: {
                Text(L10n.tr("profileRoutineNotificationStatusTitle"))
            } footer: {
                Text(L10n.tr("profileRoutinePermissionDeniedDescription"))
            }
        case .authorized:
            EmptyView()
        }
    }

    private func guidanceMetric(_ metric: RoutineGuidanceMetric) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(metric.title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(metric.value)
                .font(.headline)
                .foregroundColor(guidanceToneColor(metric.tone))

            Text(metric.detail)
                .font(.caption2)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.secondary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func guidanceInfoCard(title: String, value: String, systemImage: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.secondary.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func recommendationCard(_ recommendation: RoutineRecommendationCard) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: recommendationIconName(for: recommendation.id))
                    .font(.title3)
                    .foregroundStyle(Color.accentColor)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 6) {
                    Text(recommendation.title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(recommendation.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Label(
                L10n.tr(
                    "profileRoutineRecommendationTimeValueFormat",
                    recommendation.timeText,
                    recommendation.weekdayText
                ),
                systemImage: "clock"
            )
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.primary)

            Button(recommendation.applyButtonTitle) {
                viewModel.presentRecommendation(id: recommendation.id)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 4)
    }

    private func guidanceSlotChip(_ slot: RoutineGuidanceSlot) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(slot.timeText)
                .font(.caption.weight(.semibold))
                .foregroundColor(guidanceSlotColor(slot.status))

            Text(slot.title)
                .font(.caption2)
                .foregroundColor(.primary)
                .lineLimit(1)

            Text(guidanceSlotStatusText(slot.status))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(guidanceSlotColor(slot.status).opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func guidanceToneColor(_ tone: RoutineGuidanceTone) -> Color {
        switch tone {
        case .neutral:
            return .secondary
        case .onTrack:
            return .accentColor
        case .behind:
            return .orange
        case .ahead:
            return .blue
        }
    }

    private func guidanceSlotColor(_ status: RoutineGuidanceSlotStatus) -> Color {
        switch status {
        case .elapsed:
            return .accentColor
        case .next:
            return .orange
        case .upcoming:
            return .secondary
        }
    }

    private func guidanceSlotStatusText(_ status: RoutineGuidanceSlotStatus) -> String {
        switch status {
        case .elapsed:
            return L10n.tr("profileRoutineGuidanceSlotElapsedTitle")
        case .next:
            return L10n.tr("profileRoutineGuidanceSlotNextTitle")
        case .upcoming:
            return L10n.tr("profileRoutineGuidanceSlotUpcomingTitle")
        }
    }

    private func recommendationIconName(for id: String) -> String {
        if id.hasPrefix(HydrationRoutineRecommendationKind.morningStart.rawValue) {
            return "sun.max.fill"
        }

        if id.hasPrefix(HydrationRoutineRecommendationKind.afternoonGap.rawValue) {
            return "sun.haze.fill"
        }

        return "sparkles"
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(settingsURL)
    }

    private func applyInitialActionIfNeeded() {
        guard hasAppliedInitialAction == false, let initialAction else {
            return
        }

        hasAppliedInitialAction = true

        switch initialAction {
        case .create:
            viewModel.presentCreateRoutine()
        case let .edit(routineID):
            viewModel.presentEditRoutine(id: routineID)
        }
    }
}
