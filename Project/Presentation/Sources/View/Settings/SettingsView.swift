//
//  SettingsView.swift
//  PresentationLayer
//
//  Created by Kyeongmo Yang on 9/28/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DomainLayerInterface
import SwiftUI

public struct SettingsView: View {
    @Bindable private var viewModel: SettingsViewModel

    public init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            List(viewModel.settingMenus) { menu in
                Button {
                    viewModel.navigate(to: menu)
                } label: {
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
                }
                .buttonStyle(PlainButtonStyle())
            }
            .navigationTitle("설정")
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .settingDetail(let menu):
                    SettingDetailView(menu: menu, viewModel: viewModel)
                default:
                    EmptyView()
                }
            }
        }
    }
}
