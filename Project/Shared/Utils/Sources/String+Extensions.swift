//
//  String+Extensions.swift
//  DrinkWater
//
//  Created by Kyeongmo Yang on 2023/07/20.
//

import Foundation

public extension String {
    static let appGroupId = "group.com.gaeng2y.drinkwater"
    static let widgetKind: String = "MulimeeWidget"

    static var glassesOfToday: String {
        let now = Date()
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }()
        return dateFormatter.string(from: now)
    }

    static let mainIcon: String = "mainIcon"
    static let legacyMainAppearance: String = "mainAppearance"
    static let dailyWaterLimit: String = "dailyWaterLimit"
    static let hasCompletedOnboarding: String = "hasCompletedOnboarding"
    static let manualBodyHeightCM: String = "manualBodyHeightCM"
    static let manualBodyWeightKG: String = "manualBodyWeightKG"
    static let hydrationRoutines: String = "hydrationRoutines"
    static let hydrationChallengeStates: String = "hydrationChallengeStates"
    static let hydrationChallengeBadgeHistories: String = "hydrationChallengeBadgeHistories"
}
