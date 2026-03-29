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
    var body: some View {
        TabView {
            DrinkWaterView(
                viewModel: DIContainer.shared.resolve(DrinkWaterViewModel.self)
            )
            .tabItem {
                Label(L10n.tr("drinkTitle"), systemImage: "waterbottle")
            }

            HydrationRecordListView(
                viewModel: DIContainer.shared.resolve(HydrationRecordListViewModel.self)
            )
            .tabItem {
                Label(L10n.tr("historyTitle"), systemImage: "calendar")
            }

            HydrationInsightView(
                viewModel: DIContainer.shared.resolve(HydrationInsightViewModel.self)
            )
            .tabItem {
                Label(L10n.tr("insightNavigationTitle"), systemImage: "chart.bar.xaxis")
            }

            ChallengeView(
                viewModel: DIContainer.shared.resolve(ChallengeViewModel.self)
            )
            .tabItem {
                Label(L10n.tr("challengeTitle"), systemImage: "trophy")
            }

            ProfileView(
                settingsViewModel: DIContainer.shared.resolve(SettingsViewModel.self),
                bodyProfileViewModel: DIContainer.shared.resolve(BodyProfileViewModel.self),
                routineViewModel: DIContainer.shared.resolve(ProfileRoutineViewModel.self)
            )
            .tabItem {
                Label(L10n.tr("profileTitle"), systemImage: "person.crop.circle")
            }
        }
        .tint(.accent)
    }
}

#Preview {
    ContentView()
}
