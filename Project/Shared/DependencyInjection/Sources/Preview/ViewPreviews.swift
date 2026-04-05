//
//  ViewPreviews.swift
//  DependencyInjectionPreview
//
//  Created by Assistant on 2025.
//
// 이 파일은 Preview에서만 사용됩니다.
// Presentation Layer는 이 파일을 알지 못하며, 클린 아키텍처 원칙을 준수합니다.

import DependencyInjection
import DomainLayerInterface
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

#Preview("ChallengeView") {
    let viewModel = DIContainer.preview.resolve(ChallengeViewModel.self)
    ChallengeView(viewModel: viewModel)
}

// MARK: - ProfileView Preview
#Preview("ProfileView") {
    let settingsViewModel = DIContainer.preview.resolve(SettingsViewModel.self)
    let bodyProfileViewModel = DIContainer.preview.resolve(BodyProfileViewModel.self)
    let recommendationViewModel = DIContainer.preview.resolve(HydrationGoalRecommendationViewModel.self)
    let routineViewModel = DIContainer.preview.resolve(ProfileRoutineViewModel.self)
    ProfileView(
        settingsViewModel: settingsViewModel,
        bodyProfileViewModel: bodyProfileViewModel,
        recommendationViewModel: recommendationViewModel,
        routineViewModel: routineViewModel
    )
}

#Preview("ProfileRoutineView") {
    let mockUseCase = MockRoutineUseCase(
        routines: [
            HydrationRoutine(
                title: "출근 전 알림",
                hour: 9,
                minute: 0,
                weekdays: [.monday, .tuesday, .wednesday, .thursday, .friday],
                isEnabled: true
            )
        ],
        authorizationStatus: .authorized
    )
    let mockDrinkWaterUseCase = MockDrinkWaterUseCase()
    mockDrinkWaterUseCase.currentWaterIntakeMLValue = 500
    let mockUserPreferencesUseCase = MockUserPreferencesUseCase()
    mockUserPreferencesUseCase.setDailyWaterLimit(2000)

    ProfileRoutineView(
        viewModel: ProfileRoutineViewModel(
            routineUseCase: mockUseCase,
            drinkWaterUseCase: mockDrinkWaterUseCase,
            userPreferencesUseCase: mockUserPreferencesUseCase
        )
    )
}

// MARK: - SettingDetailView Previews
#Preview("DailyLimit Setting") {
    let settingsViewModel = DIContainer.preview.resolve(SettingsViewModel.self)
    let bodyProfileViewModel = DIContainer.preview.resolve(BodyProfileViewModel.self)
    let recommendationViewModel = DIContainer.preview.resolve(HydrationGoalRecommendationViewModel.self)
    SettingDetailView(
        menu: .dailyLimit,
        viewModel: settingsViewModel,
        bodyProfileViewModel: bodyProfileViewModel,
        recommendationViewModel: recommendationViewModel
    )
}

#Preview("BodyProfile Setting") {
    let settingsViewModel = DIContainer.preview.resolve(SettingsViewModel.self)
    let bodyProfileViewModel = DIContainer.preview.resolve(BodyProfileViewModel.self)
    SettingDetailView(
        menu: .bodyProfile,
        viewModel: settingsViewModel,
        bodyProfileViewModel: bodyProfileViewModel
    )
}

#Preview("MainShape Setting") {
    let viewModel = DIContainer.preview.resolve(SettingsViewModel.self)
    SettingDetailView(menu: .mainIcon, viewModel: viewModel)
}
