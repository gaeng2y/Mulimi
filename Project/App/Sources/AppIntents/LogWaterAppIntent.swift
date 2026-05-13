//
//  LogWaterAppIntent.swift
//  Mulimi App
//
//  Created by Codex on 5/13/26.
//

import AppIntents
import DependencyInjection
import DomainLayerInterface
import WidgetKit

struct LogWaterAppIntent: AppIntent {
    static let title: LocalizedStringResource = "물 마시기 기록"
    static let description = IntentDescription("기본 1잔 물 섭취량을 건강 앱에 기록합니다.")
    static let supportedModes: IntentModes = [.background, .foreground(.dynamic)]

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let healthKitUseCase = DIContainer.shared.resolve(HealthKitUseCase.self)

        guard healthKitUseCase.authorisationStatus == .sharingAuthorized else {
            try await continueInForeground(
                IntentDialog("건강 앱 권한이 필요해요. 물리미에서 HealthKit 권한을 허용해 주세요."),
                alwaysConfirm: false
            )
            return .result(dialog: "건강 앱 권한을 확인해 주세요.")
        }

        let waterUseCase = DIContainer.shared.resolve(DrinkWaterUseCase.self)
        let userPreferencesUseCase = DIContainer.shared.resolve(UserPreferencesUseCase.self)
        let currentMl = await waterUseCase.currentWaterIntakeML
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        let defaultVolumeML = HydrationServing.defaultGlassVolumeML
        let nextMl = currentMl + Double(defaultVolumeML)

        guard nextMl <= dailyLimit else {
            return .result(dialog: "오늘 목표를 넘어서 기록하지 않았어요.")
        }

        await waterUseCase.drinkWater(volumeML: defaultVolumeML)
        WidgetCenter.shared.reloadAllTimelines()

        return .result(dialog: "물 1잔을 기록했어요.")
    }
}
