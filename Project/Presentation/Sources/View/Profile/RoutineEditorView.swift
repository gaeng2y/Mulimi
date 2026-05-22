import DomainLayerInterface
import Localization
import SwiftUI
import UIKit

struct RoutineEditorView: View {
    @Environment(\.openURL) private var openURL
    @Bindable private var viewModel: ProfileRoutineViewModel

    init(viewModel: ProfileRoutineViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(L10n.tr("profileRoutineEditorBasicSectionTitle")) {
                    TextField(
                        L10n.tr("profileRoutineEditorTitlePlaceholder"),
                        text: Binding(
                            get: { viewModel.editorDraft.title },
                            set: { viewModel.editorDraft.title = $0 }
                        )
                    )

                    Toggle(
                        L10n.tr("profileRoutineEditorEnabledTitle"),
                        isOn: Binding(
                            get: { viewModel.editorDraft.isEnabled },
                            set: { viewModel.editorDraft.isEnabled = $0 }
                        )
                    )
                }

                Section(L10n.tr("profileRoutineEditorTimeSectionTitle")) {
                    DatePicker(
                        L10n.tr("profileRoutineTimeTitle"),
                        selection: Binding(
                            get: { viewModel.editorDraft.time },
                            set: { viewModel.editorDraft.time = $0 }
                        ),
                        displayedComponents: .hourAndMinute
                    )
                }

                if let guidance = viewModel.editorPermissionGuidance {
                    Section(L10n.tr("profileRoutineEditorPermissionSectionTitle")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(guidance.title)
                                .font(.headline)

                            Text(guidance.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)

                            if guidance.showsOpenSettingsAction {
                                Button(L10n.tr("profileRoutineOpenSettingsTitle")) {
                                    openSettings()
                                }
                                .padding(.top, 4)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    weekdayGrid
                } header: {
                    Text(L10n.tr("profileRoutineEditorWeekdaysSectionTitle"))
                } footer: {
                    Text(L10n.tr("profileRoutineEditorWeekdaysFooter"))
                }
            }
            .navigationTitle(
                viewModel.isEditingDraft
                ? L10n.tr("profileRoutineEditTitle")
                : L10n.tr("profileRoutineAddTitle")
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(L10n.tr("commonCancelTitle")) {
                        viewModel.dismissEditor()
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button(L10n.tr("commonApplyTitle")) {
                        Task {
                            await viewModel.saveDraft()
                        }
                    }
                    .disabled(!viewModel.canSaveDraft || viewModel.isSaving)
                }
            }
        }
        .alert(
            viewModel.permissionPromptTitle,
            isPresented: Binding(
                get: { viewModel.permissionPrompt != nil },
                set: { if !$0 { viewModel.dismissPermissionPrompt() } }
            )
        ) {
            switch viewModel.permissionPrompt {
            case .requestAuthorization:
                Button(L10n.tr("profileRoutineRequestPermissionTitle")) {
                    Task {
                        await viewModel.requestDraftNotificationAuthorization()
                    }
                }

                Button(L10n.tr("commonCancelTitle"), role: .cancel) {
                    viewModel.dismissPermissionPrompt()
                }
            case .openSettings:
                Button(L10n.tr("profileRoutineOpenSettingsTitle")) {
                    viewModel.dismissPermissionPrompt()
                    openSettings()
                }

                Button(L10n.tr("profileRoutineSaveWithoutNotificationsTitle")) {
                    Task {
                        await viewModel.saveDraftWithoutNotifications()
                    }
                }

                Button(L10n.tr("commonCancelTitle"), role: .cancel) {
                    viewModel.dismissPermissionPrompt()
                }
            case .scheduleFailure:
                Button(L10n.tr("profileRoutineRetrySaveTitle")) {
                    Task {
                        await viewModel.saveDraft()
                    }
                }

                Button(L10n.tr("profileRoutineSaveWithoutNotificationsTitle")) {
                    Task {
                        await viewModel.saveDraftWithoutNotifications()
                    }
                }

                Button(L10n.tr("commonCancelTitle"), role: .cancel) {
                    viewModel.dismissPermissionPrompt()
                }
            case .none:
                Button(L10n.tr("commonConfirmTitle"), role: .cancel) {
                    viewModel.dismissPermissionPrompt()
                }
            }
        } message: {
            Text(viewModel.permissionPromptMessage)
        }
    }

    private var weekdayGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
            ForEach(RoutineWeekday.displayOrder) { weekday in
                Button {
                    viewModel.toggleWeekday(weekday)
                } label: {
                    Text(weekday.shortDisplayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(
                                    viewModel.editorDraft.selectedWeekdays.contains(weekday)
                                    ? Color.accentColor
                                    : Color.secondary.opacity(0.12)
                                )
                        )
                        .foregroundColor(
                            viewModel.editorDraft.selectedWeekdays.contains(weekday)
                            ? .white
                            : .primary
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 4)
    }

    private func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        openURL(settingsURL)
    }
}
