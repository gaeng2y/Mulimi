//
//  HydrationGoalRecommendationUseCase.swift
//  DomainLayerInterface
//
//  Created by Codex on 3/30/26.
//

import Foundation

public protocol HydrationGoalRecommendationUseCase: Sendable {
    func availability(referenceDate: Date) async -> HydrationGoalRecommendationAvailability
    func generateRecommendation(referenceDate: Date) async throws -> HydrationGoalRecommendation
}
