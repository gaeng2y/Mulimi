//
//  AppIntent.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//

import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "물 마시기"
    static let description = IntentDescription("오늘 마신 물의 양을 홈 화면과 잠금화면에서 확인합니다.")

    public func perform() async throws -> some IntentResult {
        .result()
    }
}
