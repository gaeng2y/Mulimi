//
//  SettingsViewModel.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import DomainLayerInterface
import Utils
import WidgetKit

@Observable
public final class SettingsViewModel {
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let signInUseCase: SignInUseCase
    private let authenticationViewModel: AuthenticationViewModel

    // MARK: - Published State
    public private(set) var currentMainAppearance: MainAppearance
    public private(set) var currentDailyWaterLimit: Double
    public let appVersion: String
    public let appBuildNumber: String
    public var showWithdrawalConfirmation: Bool = false
    public var isWithdrawing: Bool = false
    public var withdrawalError: String?

    public init(
        userPreferencesUseCase: UserPreferencesUseCase,
        signInUseCase: SignInUseCase,
        authenticationViewModel: AuthenticationViewModel,
        appVersion: String? = nil,
        appBuildNumber: String? = nil
    ) {
        self.userPreferencesUseCase = userPreferencesUseCase
        self.signInUseCase = signInUseCase
        self.authenticationViewModel = authenticationViewModel
        self.currentMainAppearance = userPreferencesUseCase.getMainAppearance()
        self.currentDailyWaterLimit = userPreferencesUseCase.getDailyWaterLimit()
        self.appVersion = appVersion ?? Self.bundleValue(for: "CFBundleShortVersionString")
        self.appBuildNumber = appBuildNumber ?? Self.bundleValue(for: "CFBundleVersion")
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

            // AuthenticationViewModel 상태 업데이트하여 로그인 화면으로 이동
            authenticationViewModel.isAuthenticated = false
        } catch {
            withdrawalError = error.localizedDescription
        }

        isWithdrawing = false
    }

    public func cancelWithdrawal() {
        showWithdrawalConfirmation = false
        withdrawalError = nil
    }

    private static func bundleValue(for key: String) -> String {
        (Bundle.main.object(forInfoDictionaryKey: key) as? String) ?? "-"
    }
}
