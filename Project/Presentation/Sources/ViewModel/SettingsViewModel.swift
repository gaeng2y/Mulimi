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
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let signInUseCase: SignInUseCase
    private let appSession: AppSession
    private let widgetTimelineReloader: any WidgetTimelineReloading
    private let analyticsUseCase: AnalyticsUseCase

    // MARK: - Published State
    public private(set) var currentMainIcon: MainIcon
    public private(set) var currentDailyWaterLimit: Double
    public let appVersion: String
    public let appBuildNumber: String
    public var showWithdrawalConfirmation: Bool = false
    public var isWithdrawing: Bool = false
    public var withdrawalError: String?

    public init(
        userPreferencesUseCase: UserPreferencesUseCase,
        signInUseCase: SignInUseCase,
        appSession: AppSession,
        widgetTimelineReloader: any WidgetTimelineReloading,
        appInfoProvider: any AppInfoProviding,
        analyticsUseCase: AnalyticsUseCase = NoOpAnalyticsUseCase()
    ) {
        self.userPreferencesUseCase = userPreferencesUseCase
        self.signInUseCase = signInUseCase
        self.appSession = appSession
        self.widgetTimelineReloader = widgetTimelineReloader
        self.analyticsUseCase = analyticsUseCase
        self.currentMainIcon = userPreferencesUseCase.getMainIcon()
        self.currentDailyWaterLimit = userPreferencesUseCase.getDailyWaterLimit()
        self.appVersion = appInfoProvider.appVersion
        self.appBuildNumber = appInfoProvider.appBuildNumber
    }

    // MARK: - User Preferences Actions
    public func setMainIcon(_ icon: MainIcon) {
        currentMainIcon = icon
        userPreferencesUseCase.setMainIcon(icon)
        widgetTimelineReloader.reloadAllTimelines()
    }

    public var dailyWaterLimit: Double {
        get { currentDailyWaterLimit }
        set {
            setDailyWaterLimit(newValue)
        }
    }

    public func setDailyWaterLimit(
        _ limit: Double,
        source: String = "settings"
    ) {
        let previousGoalML = Int(currentDailyWaterLimit.rounded())
        let newGoalML = Int(limit.rounded())

        currentDailyWaterLimit = limit
        userPreferencesUseCase.setDailyWaterLimit(limit)
        widgetTimelineReloader.reloadAllTimelines()

        guard previousGoalML != newGoalML else {
            return
        }

        analyticsUseCase.track(
            .dailyGoalChanged(
                source: source,
                previousGoalML: previousGoalML,
                newGoalML: newGoalML
            )
        )
    }

    public func refreshState() {
        currentMainIcon = userPreferencesUseCase.getMainIcon()
        currentDailyWaterLimit = userPreferencesUseCase.getDailyWaterLimit()
    }

    // MARK: - MainIcon Specific
    func selectMainIcon(_ icon: MainIcon) {
        setMainIcon(icon)
    }

    func isMainIconSelected(_ icon: MainIcon) -> Bool {
        currentMainIcon == icon
    }

    // MARK: - Withdrawal Actions
    public func requestWithdrawal() {
        showWithdrawalConfirmation = true
    }

    @MainActor
    public func confirmWithdrawal() async {
        isWithdrawing = true
        withdrawalError = nil

        do {
            try await signInUseCase.deleteAccount()
            showWithdrawalConfirmation = false

            appSession.isAuthenticated = false
        } catch {
            withdrawalError = error.localizedDescription
        }

        isWithdrawing = false
    }

    public func cancelWithdrawal() {
        showWithdrawalConfirmation = false
        withdrawalError = nil
    }
}
