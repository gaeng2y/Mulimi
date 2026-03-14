//
//  SettingMenu.swift
//  DomainLayerInterface
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import Localization

public enum SettingMenu: CaseIterable, Identifiable {
    case dailyLimit
    case mainShape
    case withdrawal

    public var id: Self { self }

    public var title: String {
        switch self {
        case .dailyLimit: L10n.tr("settingDailyLimitTitle")
        case .mainShape: L10n.tr("settingMainShapeTitle")
        case .withdrawal: L10n.tr("settingWithdrawalTitle")
        }
    }

    public var systemImage: String {
        switch self {
        case .dailyLimit:
            return "target"
        case .mainShape:
            return "square.grid.2x2"
        case .withdrawal:
            return "person.crop.circle.badge.xmark"
        }
    }

    public var description: String {
        switch self {
        case .dailyLimit:
            return L10n.tr("settingDailyLimitDescription")
        case .mainShape:
            return L10n.tr("settingMainShapeDescription")
        case .withdrawal:
            return L10n.tr("settingWithdrawalDescription")
        }
    }

    public var settingKey: String {
        switch self {
        case .dailyLimit:
            return "dailyWaterLimit"
        case .mainShape:
            return "mainScreenAppearance"
        case .withdrawal:
            return "accountWithdrawal"
        }
    }
}
