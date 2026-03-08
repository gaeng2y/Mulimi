//
//  DrinkWaterApp.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import DependencyInjection
import Persistence
import PresentationLayer
import SwiftUI
import SwiftData

@main
struct DrinkWaterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    private let modelContainer: ModelContainer

    init() {
        do {
            self.modelContainer = try SharedHydrationStore.makeModelContainer()
        } catch {
            fatalError("Failed to initialize shared hydration store: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                viewModel: DIContainer.shared.resolve(AuthenticationViewModel.self)
            ) {
                ContentView()
            }
        }
        .modelContainer(modelContainer)
    }
}
