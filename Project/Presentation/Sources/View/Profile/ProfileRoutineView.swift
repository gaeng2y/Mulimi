import DomainLayerInterface
import Localization
import SwiftUI
import UIKit

public struct ProfileRoutineView: View {
    @Environment(\.openURL) private var openURL
    @Bindable private var viewModel: ProfileRoutineViewModel

    public init(viewModel: ProfileRoutineViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            Section {
                overviewCard
            }

            Section(L10n.tr("profileRoutineGuidanceSectionTitle")) {
                guidanceCard
            }

            Section(L10n.tr("profileRoutineOverviewSectionTitle")) {
                ForEach(viewModel.detailRows) { row in
                    detailRow(for: row)
                }
            }

            permissionSection

            Section(L10n.tr("profileRoutineSchedulesSectionTitle")) {
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

    private var overviewCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.summaryBadgeText)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)

            Text(viewModel.summaryHeadline)
                .font(.headline)

            Text(viewModel.summaryDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }

    private var guidanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.guidanceSummary.badgeText)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.accentColor)

            Text(viewModel.guidanceSummary.headline)
                .font(.headline)

            Text(viewModel.guidanceSummary.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if let recommendedValueText = viewModel.guidanceSummary.recommendedValueText,
               let actualValueText = viewModel.guidanceSummary.actualValueText {
                HStack(spacing: 12) {
                    guidanceMetric(
                        title: L10n.tr("profileRoutineGuidanceRecommendedTitle"),
                        value: recommendedValueText
                    )

                    guidanceMetric(
                        title: L10n.tr("profileRoutineGuidanceActualTitle"),
                        value: actualValueText
                    )
                }
            }

            Text(viewModel.guidanceSummary.footnote)
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
            } footer: {
                Text(L10n.tr("profileRoutinePermissionPrompt"))
            }
        case .denied:
            Section {
                Button(L10n.tr("profileRoutineOpenSettingsTitle")) {
                    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    openURL(settingsURL)
                }
            } footer: {
                Text(L10n.tr("profileRoutinePermissionDeniedDescription"))
            }
        case .authorized:
            EmptyView()
        }
    }

    private func detailRow(for row: RoutineDetailRow) -> some View {
        HStack(spacing: 12) {
            Image(systemName: row.systemImage)
                .foregroundColor(.accentColor)
                .frame(width: 20)

            Text(row.title)
                .foregroundColor(.primary)

            Spacer()

            Text(row.value)
                .foregroundColor(.secondary)
        }
    }

    private func guidanceMetric(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.secondary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
