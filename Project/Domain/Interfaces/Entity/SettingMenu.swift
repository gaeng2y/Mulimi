//
//  SettingMenu.swift
//  DomainLayerInterface
//
//  Created by Assistant on 2025-01-28.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import SwiftUI

public enum SettingMenu: CaseIterable, Identifiable {
    case dailyLimit
    case mainShape
    case withdrawal

    public var id: Self { self }

    public var title: String {
        switch self {
        case .dailyLimit: "하루 목표량"
        case .mainShape: "메인 화면 모양"
        case .withdrawal: "회원 탈퇴"
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
            return "하루 동안 마실 물의 목표량을 설정합니다"
        case .mainShape:
            return "메인 화면의 디자인을 선택합니다"
        case .withdrawal:
            return "계정을 영구적으로 삭제합니다"
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
