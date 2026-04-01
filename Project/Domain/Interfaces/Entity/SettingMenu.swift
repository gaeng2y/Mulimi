//
//  SettingMenu.swift
//  DomainLayerInterface
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI
import Localization

public enum SettingMenu: CaseIterable, Hashable, Identifiable, Sendable {
    case bodyProfile
    case dailyLimit
    case mainIcon
    case withdrawal

    public var id: Self { self }

    public var title: String {
        switch self {
        case .bodyProfile: L10n.tr("settingBodyProfileTitle")
        case .dailyLimit: L10n.tr("settingDailyLimitTitle")
        case .mainIcon: L10n.tr("settingMainShapeTitle")
        case .withdrawal: L10n.tr("settingWithdrawalTitle")
        }
    }

    public var systemImage: String {
        switch self {
        case .bodyProfile:
            return "figure"
        case .dailyLimit:
            return "target"
        case .mainIcon:
            return "square.grid.2x2"
        case .withdrawal:
            return "person.crop.circle.badge.xmark"
        }
    }

    public var description: String {
        switch self {
        case .bodyProfile:
            return L10n.tr("settingBodyProfileDescription")
        case .dailyLimit:
            return L10n.tr("settingDailyLimitDescription")
        case .mainIcon:
            return L10n.tr("settingMainShapeDescription")
        case .withdrawal:
            return L10n.tr("settingWithdrawalDescription")
        }
    }

    public var settingKey: String {
        switch self {
        case .bodyProfile:
            return "bodyProfile"
        case .dailyLimit:
            return "dailyWaterLimit"
        case .mainIcon:
            return "mainIcon"
        case .withdrawal:
            return "accountWithdrawal"
        }
    }
}
