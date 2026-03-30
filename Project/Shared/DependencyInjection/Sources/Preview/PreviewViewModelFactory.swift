//
//  PreviewViewModelFactory.swift
//  DependencyInjectionPreview
//
//  Created by Assistant on 2025.
//

import DependencyInjection
import PresentationLayer
import SwiftUI

/// Preview 전용 View 확장
/// DI 모듈에서 Presentation Layer의 View에 대한 Preview 지원
public struct PreviewViews {

    /// DrinkWaterView Preview 생성
    public static var drinkWater: some View {
        let viewModel = DIContainer.preview.resolve(DrinkWaterViewModel.self)
        return DrinkWaterView(viewModel: viewModel)
    }

    /// HydrationRecordListView Preview 생성
    public static var hydrationList: some View {
        let viewModel = DIContainer.preview.resolve(HydrationRecordListViewModel.self)
        return HydrationRecordListView(viewModel: viewModel)
    }

    /// ChallengeView Preview 생성
    public static var challenge: some View {
        let viewModel = DIContainer.preview.resolve(ChallengeViewModel.self)
        return ChallengeView(viewModel: viewModel)
    }

    /// ProfileView Preview 생성
    public static var profile: some View {
        let settingsViewModel = DIContainer.preview.resolve(SettingsViewModel.self)
        let bodyProfileViewModel = DIContainer.preview.resolve(BodyProfileViewModel.self)
        let routineViewModel = DIContainer.preview.resolve(ProfileRoutineViewModel.self)
        return ProfileView(
            settingsViewModel: settingsViewModel,
            bodyProfileViewModel: bodyProfileViewModel,
            routineViewModel: routineViewModel
        )
    }
}
