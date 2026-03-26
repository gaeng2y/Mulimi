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
    static let description = IntentDescription("250ml 물 마시기를 기록합니다.")
    static let openAppWhenRun = false

    public func perform() async throws -> some IntentResult {
        let waterUseCase = DIContainer.shared.resolve(DrinkWaterUseCase.self)
        let userPreferencesUseCase = DIContainer.shared.resolve(UserPreferencesUseCase.self)
        let currentGlasses = await waterUseCase.currentWater
        let currentMl = Double(currentGlasses * 250)
        
        // Get daily limit from UseCase
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        
        // Check if adding one more glass would exceed daily limit
        let nextMl = currentMl + 250.0
        if nextMl <= dailyLimit {
            await waterUseCase.drinkWater()
        }
        
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
