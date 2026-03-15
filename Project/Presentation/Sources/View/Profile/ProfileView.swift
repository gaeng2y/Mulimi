import DomainLayerInterface
import Localization
import SwiftUI

public struct ProfileView: View {
    @Bindable private var settingsViewModel: SettingsViewModel
    @Bindable private var routineViewModel: ProfileRoutineViewModel
    @State private var isSettingsPresented = false

    public init(
        settingsViewModel: SettingsViewModel,
        routineViewModel: ProfileRoutineViewModel
    ) {
        self.settingsViewModel = settingsViewModel
        self.routineViewModel = routineViewModel
    }

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        ProfileRoutineView(viewModel: routineViewModel)
                    } label: {
                        routineCard
                    }
                }

                Section(L10n.tr("profileCurrentSettingsSectionTitle")) {
                    settingSummaryRow(
                        title: L10n.tr("settingDailyLimitTitle"),
                        value: L10n.tr(
                            "commonMilliliterFormat",
                            Int(settingsViewModel.currentDailyWaterLimit.rounded())
                        ),
                        systemImage: "target"
                    )

                    settingSummaryRow(
                        title: L10n.tr("settingMainShapeTitle"),
                        value: settingsViewModel.currentMainAppearance.displayName,
                        systemImage: settingsViewModel.currentMainAppearance.fillSystemImage
                    )
                }
            }
            .navigationTitle(L10n.tr("profileTitle"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSettingsPresented = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityLabel(L10n.tr("profileSettingsToolbarAccessibilityLabel"))
                }
            }
            .task {
                await routineViewModel.load()
            }
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView(viewModel: settingsViewModel)
        }
    }

    private var routineCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "bell.badge")
                    .font(.title3)
                    .foregroundColor(.accentColor)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(L10n.tr("profileRoutineSectionTitle"))
                            .font(.headline)

                        Spacer()

                        Text(routineViewModel.summaryBadgeText)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                    }

                    Text(routineViewModel.summaryHeadline)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)

                    Text(routineViewModel.summaryDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func settingSummaryRow(title: String, value: String, systemImage: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .foregroundColor(.accentColor)
                .frame(width: 20)

            Text(title)
                .foregroundColor(.primary)

            Spacer()

            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
