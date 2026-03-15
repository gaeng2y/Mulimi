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
        List(viewModel.settingMenus) { menu in
            Button {
                viewModel.navigate(to: menu)
            } label: {
                rowLabel(for: menu)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .navigationTitle(L10n.tr("settingsTitle"))
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: SettingsRoute.self) { route in
            SettingDetailView(menu: route.menu, viewModel: viewModel)
        }
    }

    private var settingsListEmbedded: some View {
        List(viewModel.settingMenus) { menu in
            NavigationLink(value: menu) {
                rowLabel(for: menu)
            }
        }
        .navigationTitle(L10n.tr("settingsTitle"))
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: SettingMenu.self) { menu in
            SettingDetailView(menu: menu, viewModel: viewModel)
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
