//
//  SettingsViewModel.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import DomainLayerInterface

@Observable
public final class SettingsViewModel {
    private let navigationRouter: NavigationRouter
    private let userPreferencesUseCase: UserPreferencesUseCase

    // MARK: - Published State
    public private(set) var currentMainAppearance: MainAppearance

    public init(
        navigationRouter: NavigationRouter,
        userPreferencesUseCase: UserPreferencesUseCase
    ) {
        self.navigationRouter = navigationRouter
        self.userPreferencesUseCase = userPreferencesUseCase
        self.currentMainAppearance = userPreferencesUseCase.getMainAppearance()
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
    }

    public var dailyWaterLimit: Double {
        get { userPreferencesUseCase.getDailyWaterLimit() }
        set { userPreferencesUseCase.setDailyWaterLimit(newValue) }
    }

    public var accentColor: String {
        get { userPreferencesUseCase.getAccentColor() }
        set { userPreferencesUseCase.setAccentColor(newValue) }
    }

    // MARK: - MainAppearance Specific
    public var availableAppearances: [MainAppearance] {
        MainAppearance.allCases
    }

    public func selectMainAppearance(_ appearance: MainAppearance) {
        setMainAppearance(appearance)
    }

    public func isMainAppearanceSelected(_ appearance: MainAppearance) -> Bool {
        currentMainAppearance == appearance
    }
}