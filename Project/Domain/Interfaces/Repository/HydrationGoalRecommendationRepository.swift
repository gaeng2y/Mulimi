//
//  HydrationGoalRecommendationRepository.swift
//  DomainLayerInterface
//
//  Created by Codex on 3/30/26.
//

import Foundation

public protocol HydrationGoalRecommendationRepository: Sendable {
    func availability() -> HydrationGoalRecommendationUnavailableReason?
    func generateRecommendation(
        for input: HydrationGoalRecommendationInput
    ) async throws -> HydrationGoalRecommendation
}
