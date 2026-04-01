//
//  ContentView.swift
//  Mulimi
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import DependencyInjection
import Localization
import PresentationLayer
import SwiftUI

struct ContentView: View {
    @State private var appCoordinator: AppCoordinator
    @State private var drinkWaterViewModel: DrinkWaterViewModel
    @State private var hydrationRecordListViewModel: HydrationRecordListViewModel
    @State private var hydrationInsightViewModel: HydrationInsightViewModel
    @State private var challengeViewModel: ChallengeViewModel
    @State private var settingsViewModel: SettingsViewModel
    @State private var bodyProfileViewModel: BodyProfileViewModel
    @State private var recommendationViewModel: HydrationGoalRecommendationViewModel
    @State private var routineViewModel: ProfileRoutineViewModel

    init(container: DIContainer = .shared) {
        _appCoordinator = State(initialValue: container.resolve(AppCoordinator.self))
        _drinkWaterViewModel = State(initialValue: container.resolve(DrinkWaterViewModel.self))
        _hydrationRecordListViewModel = State(
            initialValue: container.resolve(HydrationRecordListViewModel.self)
        )
        _hydrationInsightViewModel = State(
            initialValue: container.resolve(HydrationInsightViewModel.self)
        )
        _challengeViewModel = State(initialValue: container.resolve(ChallengeViewModel.self))
        _settingsViewModel = State(initialValue: container.resolve(SettingsViewModel.self))
        _bodyProfileViewModel = State(initialValue: container.resolve(BodyProfileViewModel.self))
        _recommendationViewModel = State(
            initialValue: container.resolve(HydrationGoalRecommendationViewModel.self)
        )
        _routineViewModel = State(initialValue: container.resolve(ProfileRoutineViewModel.self))
    }

    var body: some View {
        NavigationStack(
            path: Binding(
                get: { appCoordinator.path },
                set: { appCoordinator.path = $0 }
            )
        ) {
            TabView {
                DrinkWaterView(viewModel: drinkWaterViewModel)
                    .tabItem {
                        Label(L10n.tr("drinkTitle"), systemImage: "waterbottle")
                    }

                HydrationRecordListView(viewModel: hydrationRecordListViewModel)
                    .tabItem {
                        Label(L10n.tr("historyTitle"), systemImage: "calendar")
                    }

                HydrationInsightView(viewModel: hydrationInsightViewModel)
                    .tabItem {
                        Label(L10n.tr("insightNavigationTitle"), systemImage: "chart.bar.xaxis")
                    }

                ChallengeView(viewModel: challengeViewModel)
                    .tabItem {
                        Label(L10n.tr("challengeTitle"), systemImage: "trophy")
                    }

                ProfileView(
                    settingsViewModel: settingsViewModel,
                    bodyProfileViewModel: bodyProfileViewModel,
                    recommendationViewModel: recommendationViewModel,
                    routineViewModel: routineViewModel
                )
                .tabItem {
                    Label(L10n.tr("profileTitle"), systemImage: "person.crop.circle")
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                destinationView(for: route)
            }
        }
        .tint(.accent)
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .profileRoutine:
            ProfileRoutineView(viewModel: routineViewModel)
        case let .setting(menu):
            switch menu {
            case .bodyProfile:
                SettingDetailView(
                    menu: .bodyProfile,
                    viewModel: settingsViewModel,
                    bodyProfileViewModel: bodyProfileViewModel
                )
            case .dailyLimit:
                SettingDetailView(
                    menu: .dailyLimit,
                    viewModel: settingsViewModel,
                    bodyProfileViewModel: bodyProfileViewModel,
                    recommendationViewModel: recommendationViewModel
                )
            case .mainIcon:
                SettingDetailView(menu: .mainIcon, viewModel: settingsViewModel)
            case .withdrawal:
                SettingDetailView(menu: .withdrawal, viewModel: settingsViewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
