//
//  AppIntent.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 9/6/24.
//

import AppIntents
import DependencyInjection
import DomainLayerInterface
import WidgetKit

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "물 마시기"
    static let description = IntentDescription("오늘 마신 물의 양을 홈 화면과 잠금화면에서 확인합니다.")

    public func perform() async throws -> some IntentResult {
        .result()
    }
}

struct LogWaterAppIntent: AppIntent {
    static let title: LocalizedStringResource = "물 마시기"
    static let description = IntentDescription("기본 물 섭취량을 기록합니다.")
    static let openAppWhenRun = false

    public func perform() async throws -> some IntentResult {
        let waterUseCase = DIContainer.shared.resolve(DrinkWaterUseCase.self)
        let userPreferencesUseCase = DIContainer.shared.resolve(UserPreferencesUseCase.self)
        let currentMl = await waterUseCase.currentWaterIntakeML
        
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        
        let nextMl = currentMl + HydrationServing.defaultGlassML
        if nextMl <= dailyLimit {
            await waterUseCase.drinkWater()
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
