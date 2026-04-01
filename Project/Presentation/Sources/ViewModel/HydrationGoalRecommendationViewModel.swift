//
//  HydrationGoalRecommendationViewModel.swift
//  PresentationLayer
//
//  Created by Codex on 3/30/26.
//

import DomainLayerInterface
import Foundation
import Localization
import Observation

@Observable
@MainActor
public final class HydrationGoalRecommendationViewModel {
    public enum State: Equatable {
        case idle
        case loading
        case ready
        case bodyProfileRequired(BodyProfileAvailability)
        case modelUnavailable(HydrationGoalRecommendationUnavailableReason)
    }

    public private(set) var state: State = .idle
    public private(set) var recommendation: HydrationGoalRecommendation?
    public private(set) var isGenerating = false
    public private(set) var errorMessage: String?

    private let useCase: HydrationGoalRecommendationUseCase

    public init(useCase: HydrationGoalRecommendationUseCase) {
        self.useCase = useCase
    }

    public func load() async {
        state = .loading
        errorMessage = nil
        recommendation = nil
        state = map(await useCase.availability(referenceDate: .now))
    }

    public func generateRecommendation() async {
        errorMessage = nil

        let availability = await useCase.availability(referenceDate: .now)
        let mappedState = map(availability)
        state = mappedState

        guard case .ready = availability else {
            recommendation = nil
            return
        }

        isGenerating = true
        defer { isGenerating = false }

        do {
            recommendation = try await useCase.generateRecommendation(referenceDate: .now)
            state = .ready
        } catch let error as HydrationGoalRecommendationError {
            recommendation = nil
            switch error {
            case let .bodyProfileRequired(availability):
                state = .bodyProfileRequired(availability)
            case let .modelUnavailable(reason):
                state = .modelUnavailable(reason)
            }
        } catch {
            recommendation = nil
            errorMessage = L10n.tr("hydrationGoalRecommendationGenerationFailureDescription")
        }
    }

    public func clearRecommendation() {
        recommendation = nil
        errorMessage = nil
    }

    private func map(_ availability: HydrationGoalRecommendationAvailability) -> State {
        switch availability {
        case .ready:
            .ready
        case let .bodyProfileRequired(value):
            .bodyProfileRequired(value)
        case let .modelUnavailable(reason):
            .modelUnavailable(reason)
        }
    }
}
