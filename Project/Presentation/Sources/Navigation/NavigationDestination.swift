//
//  NavigationDestination.swift
//  PresentationLayer
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import Foundation
import DomainLayerInterface

public enum NavigationDestination: Hashable {
    // Settings
    case settingDetail(SettingMenu)
    case dailyLimitSetting
    case accentColorSetting
    case mainShapeSetting
    
    // Records (future)
    case recordDetail(Date)
    case monthlyReport
    
    // Profile (future)
    case profile
    case about
}

extension NavigationDestination: Identifiable {
    public var id: String {
        switch self {
        case .settingDetail(let menu):
            return "setting_\(menu.settingKey)"
        case .dailyLimitSetting:
            return "daily_limit"
        case .accentColorSetting:
            return "accent_color"
        case .mainShapeSetting:
            return "main_shape"
        case .recordDetail(let date):
            return "record_\(date.timeIntervalSince1970)"
        case .monthlyReport:
            return "monthly_report"
        case .profile:
            return "profile"
        case .about:
            return "about"
        }
    }
}
