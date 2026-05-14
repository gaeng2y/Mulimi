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

enum LogWaterAmountOption: String, AppEnum {
    case glass
    case bottle
    case tumbler
    case custom

    static let typeDisplayRepresentation = TypeDisplayRepresentation(name: "수분량")
    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .glass: DisplayRepresentation(title: "250ml (1잔)"),
        .bottle: DisplayRepresentation(title: "330ml"),
        .tumbler: DisplayRepresentation(title: "500ml"),
        .custom: DisplayRepresentation(title: "직접 입력")
    ]

    var volumeML: Int? {
        switch self {
        case .glass:
            HydrationServing.defaultGlassVolumeML
        case .bottle:
            HydrationServing.bottleML
        case .tumbler:
            HydrationServing.tumblerML
        case .custom:
            nil
        }
    }

    var servingType: String {
        switch self {
        case .glass:
            "default_glass"
        case .bottle, .tumbler:
            "preset"
        case .custom:
            "custom"
        }
    }

    var presetID: String? {
        switch self {
        case .bottle:
            HydrationServingPreset.bottle.rawValue
        case .tumbler:
            HydrationServingPreset.tumbler.rawValue
        case .glass, .custom:
            nil
        }
    }
}

struct LogWaterAppIntent: AppIntent {
    private enum Constant {
        static let analyticsSource = "app_intent"
        static let minimumCustomAmountML = 1
        static let maximumCustomAmountML = 4_000
    }

    private enum FailureReason {
        static let healthKitPermissionRequired = "healthkit_permission_required"
        static let customAmountMissing = "custom_amount_missing"
        static let customAmountOutOfRange = "custom_amount_out_of_range"
        static let dailyGoalExceeded = "daily_goal_exceeded"
    }

    static let title: LocalizedStringResource = "물 마시기 기록"
    static let description = IntentDescription("선택한 물 섭취량을 건강 앱에 기록합니다.")
    static let supportedModes: IntentModes = [.background, .foreground(.dynamic)]

    @Parameter(title: "수분량")
    var amount: LogWaterAmountOption

    @Parameter(
        title: "직접 입력 ml",
        description: "직접 입력을 선택한 경우 1~4000ml 사이로 입력해 주세요."
    )
    var customAmountML: Int?

    init() {
        self.amount = .glass
        self.customAmountML = nil
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let healthKitUseCase = DIContainer.shared.resolve(HealthKitUseCase.self)

        guard healthKitUseCase.authorisationStatus == .sharingAuthorized else {
            trackWaterLogFailed(
                failureReason: FailureReason.healthKitPermissionRequired,
                volumeML: resolvedVolumeML
            )
            try await continueInForeground(
                IntentDialog("건강 앱 권한이 필요해요. 물리미에서 HealthKit 권한을 허용해 주세요."),
                alwaysConfirm: false
            )
            return .result(dialog: "건강 앱 권한을 확인해 주세요.")
        }

        guard let volumeML = resolvedVolumeML else {
            trackWaterLogFailed(failureReason: FailureReason.customAmountMissing)
            return .result(dialog: "직접 입력 ml를 입력해 주세요.")
        }

        guard isValidCustomAmount(volumeML) else {
            trackWaterLogFailed(
                failureReason: FailureReason.customAmountOutOfRange,
                volumeML: volumeML
            )
            return .result(dialog: "직접 입력은 1ml부터 4000ml 사이로 기록할 수 있어요.")
        }

        let waterUseCase = DIContainer.shared.resolve(DrinkWaterUseCase.self)
        let userPreferencesUseCase = DIContainer.shared.resolve(UserPreferencesUseCase.self)
        let currentMl = await waterUseCase.currentWaterIntakeML
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        let nextMl = currentMl + Double(volumeML)

        guard nextMl <= dailyLimit else {
            trackWaterLogFailed(
                failureReason: FailureReason.dailyGoalExceeded,
                volumeML: volumeML,
                dailyLimit: dailyLimit
            )
            return .result(dialog: overLimitDialog(currentMl: currentMl, dailyLimit: dailyLimit, volumeML: volumeML))
        }

        await waterUseCase.drinkWater(volumeML: volumeML)
        WidgetCenter.shared.reloadAllTimelines()
        trackWaterLogged(volumeML: volumeML, dailyLimit: dailyLimit)

        return .result(dialog: "물 \(volumeML)ml를 기록했어요.")
    }

    private var resolvedVolumeML: Int? {
        switch amount {
        case .glass, .bottle, .tumbler:
            amount.volumeML
        case .custom:
            customAmountML
        }
    }

    private func isValidCustomAmount(_ volumeML: Int) -> Bool {
        guard amount == .custom else {
            return true
        }

        return (Constant.minimumCustomAmountML...Constant.maximumCustomAmountML).contains(volumeML)
    }

    private func overLimitDialog(
        currentMl: Double,
        dailyLimit: Double,
        volumeML: Int
    ) -> IntentDialog {
        let remainingML = max(Int((dailyLimit - currentMl).rounded()), 0)

        guard remainingML > 0 else {
            return "오늘 목표를 이미 달성해서 기록하지 않았어요."
        }

        return "오늘 목표까지 \(remainingML)ml 남아 \(volumeML)ml는 기록하지 않았어요."
    }

    private func trackWaterLogged(volumeML: Int, dailyLimit: Double) {
        let analyticsUseCase = DIContainer.shared.resolve(AnalyticsUseCase.self)
        analyticsUseCase.track(
            .waterLogged(
                source: Constant.analyticsSource,
                servingType: amount.servingType,
                volumeML: volumeML,
                dailyGoalML: Int(dailyLimit.rounded())
            )
        )

        guard let presetID = amount.presetID else {
            return
        }

        analyticsUseCase.track(
            .waterPresetLogged(
                source: Constant.analyticsSource,
                preset: presetID,
                volumeML: volumeML
            )
        )
    }

    private func trackWaterLogFailed(
        failureReason: String,
        volumeML: Int? = nil,
        dailyLimit: Double? = nil
    ) {
        let analyticsUseCase = DIContainer.shared.resolve(AnalyticsUseCase.self)
        analyticsUseCase.track(
            .waterLogFailed(
                source: Constant.analyticsSource,
                servingType: amount.servingType,
                failureReason: failureReason,
                volumeML: volumeML,
                dailyGoalML: dailyLimit.map { Int($0.rounded()) }
            )
        )
    }
}
