//
//  ViewPreviews.swift
//  DependencyInjectionPreview
//
//  Created by Assistant on 2025.
//
// 이 파일은 Preview에서만 사용됩니다.
// Presentation Layer는 이 파일을 알지 못하며, 클린 아키텍처 원칙을 준수합니다.

import DependencyInjection
import PresentationLayer
import SwiftUI

// MARK: - DrinkWaterView Preview
#Preview("DrinkWaterView") {
    let viewModel = DIContainer.preview.resolve(DrinkWaterViewModel.self)
    DrinkWaterView(viewModel: viewModel)
}

// MARK: - HydrationRecordListView Preview
#Preview("HydrationRecordListView") {
    let viewModel = DIContainer.preview.resolve(HydrationRecordListViewModel.self)
    HydrationRecordListView(viewModel: viewModel)
}

#Preview("HydrationInsightView") {
    let viewModel = DIContainer.preview.resolve(HydrationInsightViewModel.self)
    HydrationInsightView(viewModel: viewModel)
}

// MARK: - ProfileView Preview
#Preview("ProfileView") {
    let viewModel = DIContainer.preview.resolve(SettingsViewModel.self)
    ProfileView(settingsViewModel: viewModel)
}

#Preview("SettingsView") {
    let viewModel = DIContainer.preview.resolve(SettingsViewModel.self)
    SettingsView(viewModel: viewModel)
}

// MARK: - SettingDetailView Previews
#Preview("DailyLimit Setting") {
    SettingDetailView(menu: .dailyLimit)
}

#Preview("AccentColor Setting") {
    SettingDetailView(menu: .accentColor)
}

#Preview("MainShape Setting") {
    SettingDetailView(menu: .mainShape)
}
