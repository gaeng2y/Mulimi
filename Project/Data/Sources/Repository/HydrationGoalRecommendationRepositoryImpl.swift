//
//  HydrationGoalRecommendationRepositoryImpl.swift
//  DataLayer
//
//  Created by Codex on 3/30/26.
//

import DomainLayerInterface

public struct HydrationGoalRecommendationRepositoryImpl: HydrationGoalRecommendationRepository {
    private let dataSource: HydrationGoalRecommendationDataSource

    public init(dataSource: HydrationGoalRecommendationDataSource) {
        self.dataSource = dataSource
    }

    public func availability() -> HydrationGoalRecommendationUnavailableReason? {
        dataSource.availability()
    }

    public func generateRecommendation(
        for input: HydrationGoalRecommendationInput
    ) async throws -> HydrationGoalRecommendation {
        try await dataSource.generateRecommendation(for: input)
    }
}
