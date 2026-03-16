import DomainLayerInterface
import Localization
import SwiftUI

struct RoutineEditorView: View {
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
}
