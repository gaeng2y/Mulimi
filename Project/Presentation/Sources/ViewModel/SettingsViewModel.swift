//
//  SettingsViewModel.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import DomainLayerInterface
import WidgetKit

@Observable
public final class SettingsViewModel {
    private let navigationRouter: NavigationRouter
    private let userPreferencesUseCase: UserPreferencesUseCase
    
    // MARK: - Published State
    public private(set) var currentMainAppearance: MainAppearance
    public private(set) var currentDailyWaterLimit: Double
    
    public init(
        navigationRouter: NavigationRouter,
        userPreferencesUseCase: UserPreferencesUseCase
    ) {
        self.navigationRouter = navigationRouter
        self.userPreferencesUseCase = userPreferencesUseCase
        self.currentMainAppearance = userPreferencesUseCase.getMainAppearance()
        self.currentDailyWaterLimit = userPreferencesUseCase.getDailyWaterLimit()
    }
    
    // MARK: - Navigation State
    public var navigationPath: NavigationPath {
        get { navigationRouter.settingsPath }
        set { navigationRouter.settingsPath = newValue }
    }
    
    public var hasNavigationPath: Bool {
        navigationRouter.hasSettingsPath
    }
    
    // MARK: - Settings Data
    public let settingMenus = SettingMenu.allCases
    
    // MARK: - Navigation Actions
    public func navigate(to menu: SettingMenu) {
        let destination = NavigationDestination.settingDetail(menu)
        navigationRouter.navigate(to: destination)
    }
    
    public func navigateBack() {
        navigationRouter.navigateBack()
    }
    
    public func resetNavigation() {
        navigationRouter.resetSettingsPath()
    }
    
    // MARK: - Settings Actions
    public func getSettingTitle(for menu: SettingMenu) -> String {
        menu.title
    }
    
    public func getSettingDescription(for menu: SettingMenu) -> String {
        menu.description
    }
    
    public func getSettingSystemImage(for menu: SettingMenu) -> String {
        menu.systemImage
    }
    
    // MARK: - User Preferences Actions
    public func setMainAppearance(_ appearance: MainAppearance) {
        currentMainAppearance = appearance
        userPreferencesUseCase.setMainAppearance(appearance)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    public var dailyWaterLimit: Double {
        get { currentDailyWaterLimit }
        set {
            currentDailyWaterLimit = newValue
            userPreferencesUseCase.setDailyWaterLimit(newValue)

            // Force UserDefaults synchronization for widget
            UserDefaults.standard.synchronize()
            UserDefaults(suiteName: "group.com.gaeng2y.drinkwater")?.synchronize()

            // Reload widget timelines
            WidgetCenter.shared.reloadTimelines(ofKind: .widgetKind)

            // Notify other ViewModels
            NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
        }
    }

    // MARK: - MainAppearance Specific
    func selectMainAppearance(_ appearance: MainAppearance) {
        setMainAppearance(appearance)
    }
    
    func isMainAppearanceSelected(_ appearance: MainAppearance) -> Bool {
        currentMainAppearance == appearance
    }
}
