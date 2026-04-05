import DomainLayerInterface
import Localization
import SwiftUI

public struct ProfileView: View {
    @Bindable private var settingsViewModel: SettingsViewModel
    @Bindable private var bodyProfileViewModel: BodyProfileViewModel
    @Bindable private var recommendationViewModel: HydrationGoalRecommendationViewModel
    @Bindable private var routineViewModel: ProfileRoutineViewModel

    public init(
        settingsViewModel: SettingsViewModel,
        bodyProfileViewModel: BodyProfileViewModel,
        recommendationViewModel: HydrationGoalRecommendationViewModel,
        routineViewModel: ProfileRoutineViewModel
    ) {
        self.settingsViewModel = settingsViewModel
        self.bodyProfileViewModel = bodyProfileViewModel
        self.recommendationViewModel = recommendationViewModel
        self.routineViewModel = routineViewModel
    }

    public var body: some View {
        List {
            Section(L10n.tr("profileRoutineSectionTitle")) {
                NavigationLink(value: AppRoute.profileRoutine) {
                    routineCard
                }
            }

            Section {
                NavigationLink(value: AppRoute.setting(.bodyProfile)) {
                    settingsRow(
                        title: L10n.tr("settingBodyProfileTitle"),
                        value: bodyProfileViewModel.summaryText,
                        systemImage: "figure"
                    )
                }

                NavigationLink(value: AppRoute.setting(.dailyLimit)) {
                    settingsRow(
                        title: L10n.tr("settingDailyLimitTitle"),
                        value: L10n.tr(
                            "commonMilliliterFormat",
                            Int(settingsViewModel.currentDailyWaterLimit.rounded())
                        ),
                        systemImage: "target"
                    )
                }

                NavigationLink(value: AppRoute.setting(.mainIcon)) {
                    settingsRow(
                        title: L10n.tr("settingMainShapeTitle"),
                        value: settingsViewModel.currentMainIcon.displayName,
                        systemImage: settingsViewModel.currentMainIcon.fillSystemImage
                    )
                }
            } header: {
                Text(L10n.tr("profileQuickSettingsSectionTitle"))
            } footer: {
                Text(L10n.tr("profileQuickSettingsSectionFooter"))
            }

            Section(L10n.tr("profileAccountSectionTitle")) {
                NavigationLink(value: AppRoute.setting(.withdrawal)) {
                    actionRow(
                        title: L10n.tr("settingWithdrawalTitle"),
                        description: L10n.tr("profileWithdrawalDescription"),
                        systemImage: "person.crop.circle.badge.xmark",
                        showsChevron: false
                    )
                }
            }

            Section(L10n.tr("profileAppInfoSectionTitle")) {
                infoRow(
                    title: L10n.tr("profileAppVersionTitle"),
                    value: settingsViewModel.appVersion,
                    systemImage: "app.badge"
                )

                infoRow(
                    title: L10n.tr("profileAppBuildTitle"),
                    value: settingsViewModel.appBuildNumber,
                    systemImage: "number"
                )
            }
        }
        .task {
            await routineViewModel.load()
            await bodyProfileViewModel.load()
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

    private func settingsRow(title: String, value: String, systemImage: String) -> some View {
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

    private func actionRow(title: String, description: String, systemImage: String, showsChevron: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .foregroundColor(.accentColor)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.primary)

                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .contentShape(Rectangle())
    }

    private func infoRow(title: String, value: String, systemImage: String) -> some View {
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
