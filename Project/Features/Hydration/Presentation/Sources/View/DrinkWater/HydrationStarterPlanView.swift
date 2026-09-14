import HydrationDomain
import Localization
import SwiftUI

public struct HydrationStarterPlanView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    private let viewModel: HydrationStarterPlanViewModel
    private let onRecordAction: () -> Void
    private let onRoutineAction: () -> Void

    public init(
        viewModel: HydrationStarterPlanViewModel,
        onRecordAction: @escaping () -> Void,
        onRoutineAction: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.onRecordAction = onRecordAction
        self.onRoutineAction = onRoutineAction
    }

    public var body: some View {
        Group {
            if viewModel.isAvailable {
                checklist
            } else if viewModel.isRefreshing {
                ProgressView()
            } else {
                ContentUnavailableView(
                    L10n.tr("starterPlanUnavailableTitle"),
                    systemImage: "checklist",
                    description: Text(L10n.tr("starterPlanUnavailableDescription"))
                )
            }
        }
        .navigationTitle(L10n.tr("starterPlanTitle"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await refresh()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                Task { await refresh() }
            }
        }
    }

    private var checklist: some View {
        List {
            Section {
                Text(L10n.tr("starterPlanProgressFormat", viewModel.dayNumber ?? 1, viewModel.completedStepCount))
                    .font(.headline)
                Text(L10n.tr("starterPlanDescription"))
                    .foregroundStyle(.secondary)
            }

            Section {
                stepLabel("starterPlanRecordTitle", isComplete: viewModel.hasRecordedWater)
                if !viewModel.hasRecordedWater {
                    Button(L10n.tr("starterPlanRecordAction")) {
                        viewModel.trackAction("go_record")
                        onRecordAction()
                    }
                }
            } footer: {
                Text(L10n.tr("starterPlanRecordDescription"))
            }

            Section {
                stepLabel("starterPlanRoutineTitle", isComplete: viewModel.hasSavedRoutine)
                if !viewModel.hasSavedRoutine {
                    Button(L10n.tr("starterPlanRoutineAction")) {
                        viewModel.trackAction("create_routine")
                        onRoutineAction()
                    }
                }
            } footer: {
                Text(L10n.tr("starterPlanRoutineDescription"))
            }

            Section {
                stepLabel("starterPlanMethodTitle", isComplete: viewModel.plan?.quickRecordingMethod != nil)
                ForEach(HydrationQuickRecordingMethod.allCases, id: \.self) { method in
                    DisclosureGroup {
                        Text(L10n.tr("starterPlanMethodGuide_\(method.rawValue)"))
                            .foregroundStyle(.secondary)
                        Button(L10n.tr("starterPlanMethodSelect")) {
                            viewModel.selectQuickRecordingMethod(method)
                        }
                        .disabled(viewModel.plan?.quickRecordingMethod == method)
                    } label: {
                        HStack {
                            Text(L10n.tr("starterPlanMethodName_\(method.rawValue)"))
                            if viewModel.plan?.quickRecordingMethod == method {
                                Text(L10n.tr("starterPlanMethodSelected"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            } footer: {
                Text(L10n.tr("starterPlanMethodDescription"))
            }

            Section {
                Button(L10n.tr("starterPlanCompleteAction")) {
                    Task {
                        if await viewModel.complete() {
                            dismiss()
                        }
                    }
                }
                .disabled(viewModel.completedStepCount != 3 || viewModel.isRefreshing)

                Button(L10n.tr("starterPlanDismissAction"), role: .destructive) {
                    viewModel.dismiss()
                    dismiss()
                }
            } footer: {
                Text(L10n.tr("starterPlanDismissDescription"))
            }
        }
        .refreshable { await refresh() }
    }

    private func stepLabel(_ key: String, isComplete: Bool) -> some View {
        HStack {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isComplete ? Color.accentColor : .secondary)
                .accessibilityHidden(true)
            Text(L10n.tr(key))
                .font(.headline)
            if isComplete {
                Text(L10n.tr("starterPlanStepComplete"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private func refresh() async {
        await viewModel.refresh()
        viewModel.trackViewed()
    }
}
