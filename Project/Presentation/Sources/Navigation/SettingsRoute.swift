//
//  SettingsRoute.swift
//  PresentationLayer
//
//  Created by Codex on 3/15/26.
//

import DomainLayerInterface
import Foundation

public enum SettingsRoute: NavigationRoute {
    case dailyLimit
    case mainShape
    case withdrawal

    public init(menu: SettingMenu) {
        switch menu {
        case .dailyLimit:
            self = .dailyLimit
        case .mainShape:
            self = .mainShape
        case .withdrawal:
            self = .withdrawal
        }
    }

    public var menu: SettingMenu {
        switch self {
        case .dailyLimit:
            return .dailyLimit
        case .mainShape:
            return .mainShape
        case .withdrawal:
            return .withdrawal
        }
    }
}

extension SettingsRoute: Identifiable {
    public var id: String {
        switch self {
        case .dailyLimit:
            return "daily_limit"
        case .mainShape:
            return "main_shape"
        case .withdrawal:
            return "account_withdrawal"
        }
    }
}

extension SettingsRoute {
    public var presentationStyle: NavigationPresentationStyle {
        .push
    }
}
