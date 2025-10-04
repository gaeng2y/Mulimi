//
//  SettingDetailView.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import DomainLayerInterface
import WidgetKit
import UIKit

public struct SettingDetailView: View {
    let menu: SettingMenu
    private let viewModel: SettingsViewModel
    
    public init(menu: SettingMenu, viewModel: SettingsViewModel) {
        self.menu = menu
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            switch menu {
            case .dailyLimit:
                DailyLimitSettingView(viewModel: viewModel)
            case .mainShape:
                MainShapeSettingView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Setting Detail Views
private struct DailyLimitSettingView: View {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("\(Int(viewModel.dailyWaterLimit.rounded())) ml")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
            }
            
            Slider(value: Binding(
                get: { viewModel.dailyWaterLimit },
                set: {
                    viewModel.dailyWaterLimit = $0
                    // 위젯 즉시 업데이트
                    WidgetCenter.shared.reloadAllTimelines()
                }
            ), in: 1000...4000, step: 250) {
                Text("목표량")
            }
            .padding(.horizontal)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                // 앱이 활성화될 때 위젯 새로고침
                WidgetCenter.shared.reloadAllTimelines()
            }
            
            HStack {
                Text("1000ml")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Text("4000ml")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("하루 목표량")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct MainShapeSettingView: View {
    private let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ForEach(MainAppearance.allCases) { appearance in
                Button {
                    viewModel.selectMainAppearance(appearance)
                } label: {
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: appearance.systemImage)
                                .font(.title2)
                                .frame(width: 40)
                                .foregroundColor(.accentColor)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appearance.displayName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(appearance.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            if viewModel.isMainAppearanceSelected(appearance) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accentColor)
                                    .font(.title3)
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(viewModel.isMainAppearanceSelected(appearance) ?
                                  Color.accentColor.opacity(0.1) :
                                    Color(uiColor: .systemGray6))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                viewModel.isMainAppearanceSelected(appearance) ?
                                Color.accentColor.opacity(0.3) :
                                    Color.clear,
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .navigationTitle("메인 화면 모양")
        .navigationBarTitleDisplayMode(.inline)
    }
}
