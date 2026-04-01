//
//  FoundationModelsHydrationGoalRecommendationDataSource.swift
//  DataLayer
//
//  Created by Codex on 3/30/26.
//

import DomainLayerInterface
import Foundation
import FoundationModels

public protocol HydrationGoalRecommendationDataSource: Sendable {
    func availability() -> HydrationGoalRecommendationUnavailableReason?
    func generateRecommendation(
        for input: HydrationGoalRecommendationInput
    ) async throws -> HydrationGoalRecommendation
}

@Generable
private struct GeneratedHydrationGoalRecommendation {
    let recommendedLimitML: Int
    let summary: String
    let primaryReason: String
    let secondaryReason: String
    let caution: String
}

public final class FoundationModelsHydrationGoalRecommendationDataSource: HydrationGoalRecommendationDataSource, @unchecked Sendable {
    private enum Constants {
        static let minimumLimitML = 1_000
        static let maximumLimitML = 4_000
        static let stepML = 250
    }

    private let model: SystemLanguageModel
    private let locale: Locale

    public init(
        model: SystemLanguageModel = .default,
        locale: Locale = .current
    ) {
        self.model = model
        self.locale = locale
    }

    public func availability() -> HydrationGoalRecommendationUnavailableReason? {
        guard model.supportsLocale(locale) else {
            return .unsupportedLocale
        }

        switch model.availability {
        case .available:
            return nil
        case let .unavailable(reason):
            return switch reason {
            case .deviceNotEligible:
                .deviceNotEligible
            case .appleIntelligenceNotEnabled:
                .appleIntelligenceNotEnabled
            case .modelNotReady:
                .modelNotReady
            @unknown default:
                .unknown
            }
        }
    }

    public func generateRecommendation(
        for input: HydrationGoalRecommendationInput
    ) async throws -> HydrationGoalRecommendation {
        let session = LanguageModelSession(
            model: model,
            instructions: """
            당신은 수분 섭취 앱의 목표 수분량 추천 도우미입니다.
            제공된 숫자만 사용해 하루 목표 수분량을 추천하세요.
            항상 한국어로 응답하세요.
            추천 목표량은 1000ml 이상 4000ml 이하, 250ml 단위여야 합니다.
            현재 목표와 너무 큰 차이가 나지 않도록 보수적으로 제안하세요.
            요약은 한 문장으로 짧게 작성하세요.
            이유는 짧은 문장 두 개로 작성하세요.
            주의사항은 필요할 때만 짧게 작성하고, 없으면 빈 문자열을 반환하세요.
            의학적 진단처럼 단정하지 마세요.
            """
        )

        let response = try await session.respond(
            to: prompt(for: input),
            generating: GeneratedHydrationGoalRecommendation.self,
            options: GenerationOptions(
                sampling: .greedy,
                maximumResponseTokens: 300
            )
        )

        let content = response.content

        return HydrationGoalRecommendation(
            input: input,
            recommendedLimitML: normalizedLimit(from: content.recommendedLimitML),
            summary: content.summary.trimmingCharacters(in: .whitespacesAndNewlines),
            reasons: [
                content.primaryReason,
                content.secondaryReason
            ]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty },
            caution: sanitizedCaution(content.caution)
        )
    }

    private func prompt(for input: HydrationGoalRecommendationInput) -> String {
        """
        다음 정보를 기반으로 오늘의 개인화 목표 수분량을 추천하세요.

        - 키: \(input.heightCM)cm
        - 몸무게: \(input.weightKG)kg
        - 현재 목표 수분량: \(input.currentGoalML)ml
        - 최근 \(input.analysisDays)일 평균 섭취량: \(input.recentAverageIntakeML)ml
        - 최근 \(input.analysisDays)일 기록이 있었던 날 수: \(input.recentRecordedDays)일
        - 최근 \(input.analysisDays)일 목표 달성 일수: \(input.recentGoalAchievementDays)일

        현재 목표와 최근 기록의 차이를 함께 고려해서 추천하세요.
        """
    }

    private func normalizedLimit(from value: Int) -> Int {
        let clampedValue = min(max(value, Constants.minimumLimitML), Constants.maximumLimitML)
        let roundedStep = Int((Double(clampedValue) / Double(Constants.stepML)).rounded()) * Constants.stepML
        return min(max(roundedStep, Constants.minimumLimitML), Constants.maximumLimitML)
    }

    private func sanitizedCaution(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
