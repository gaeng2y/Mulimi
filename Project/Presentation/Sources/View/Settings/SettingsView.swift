//
//  SettingsView.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 9/28/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import Localization
import SwiftUI

public struct SettingsView: View {
    @Bindable private var viewModel: SettingsViewModel
    private let isEmbeddedInNavigationStack: Bool

    public init(
        viewModel: SettingsViewModel,
        isEmbeddedInNavigationStack: Bool = false
    ) {
        self.viewModel = viewModel
        self.isEmbeddedInNavigationStack = isEmbeddedInNavigationStack
    }

    public var body: some View {
        if isEmbeddedInNavigationStack {
            settingsListEmbedded
        } else {
            NavigationStack(path: $viewModel.navigationPath) {
                settingsListStandalone
            }
        }
    }

    private var settingsListStandalone: some View {
        List {
            settingsSections(isEmbedded: false)
        }
        .navigationTitle(L10n.tr("settingsTitle"))
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: SettingsRoute.self) { route in
            SettingDetailView(menu: route.menu, viewModel: viewModel)
        }
    }

    private var settingsListEmbedded: some View {
        List {
            settingsSections(isEmbedded: true)
        }
        .navigationTitle(L10n.tr("settingsTitle"))
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: SettingMenu.self) { menu in
            SettingDetailView(menu: menu, viewModel: viewModel)
        }
    }

    @ViewBuilder
    private func settingsSections(isEmbedded: Bool) -> some View {
        Section {
            ForEach(viewModel.personalizationMenus) { menu in
                if isEmbedded {
                    NavigationLink(value: menu) {
                        rowLabel(for: menu)
                    }
                } else {
                    Button {
                        viewModel.navigate(to: menu)
                    } label: {
                        rowLabel(for: menu)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        } header: {
            Text(L10n.tr("settingsPersonalizationSectionTitle"))
        }
        Section {
            ForEach(viewModel.accountManagementMenus) { menu in
                if isEmbedded {
                    NavigationLink(value: menu) {
                        rowLabel(for: menu)
                    }
                } else {
                    Button {
                        viewModel.navigate(to: menu)
                    } label: {
                        rowLabel(for: menu)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        } header: {
            Text(L10n.tr("settingsAccountManagementSectionTitle"))
        }
    }

    private func rowLabel(for menu: SettingMenu) -> some View {
        HStack {
            Label(
                viewModel.getSettingTitle(for: menu),
                systemImage: viewModel.getSettingSystemImage(for: menu)
            )
            .foregroundColor(.primary)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .contentShape(Rectangle())
    }
}
