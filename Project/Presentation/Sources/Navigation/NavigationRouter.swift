//
//  NavigationRouter.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import Foundation

@Observable
public final class NavigationRouter {
    public var waterTabPath = NavigationPath()
    public var recordTabPath = NavigationPath()
    public var settingsPath = NavigationPath()

    public init() {}

    // MARK: - Navigation Methods
    public func navigate(to destination: NavigationDestination) {
        settingsPath.append(destination)
    }

    public func navigateBack() {
        if !settingsPath.isEmpty {
            settingsPath.removeLast()
        }
    }

    public func resetSettingsPath() {
        settingsPath = NavigationPath()
    }

    public func resetWaterTabPath() {
        waterTabPath = NavigationPath()
    }

    public func resetRecordTabPath() {
        recordTabPath = NavigationPath()
    }

    public func resetAllPaths() {
        waterTabPath = NavigationPath()
        recordTabPath = NavigationPath()
        settingsPath = NavigationPath()
    }

    // MARK: - Deep Link Handling (Future)
    public func handleDeepLink(_ url: URL) {
        // TODO: Implement URL parsing to NavigationDestination
        // Example: myapp://settings/daily-limit -> .settingDetail(.dailyLimit)
    }

    // MARK: - Path State
    public var hasSettingsPath: Bool {
        !settingsPath.isEmpty
    }

    public var settingsPathCount: Int {
        settingsPath.count
    }
}