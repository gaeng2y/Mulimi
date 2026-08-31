//
//  OnboardingViewModel.swift
//  AccountPresentation
//
//  Created by Codex on 4/3/26.
//

import AccountDomain
import MulimiAnalytics
import CorePresentation
import HydrationDomain
import HydrationPresentation
import RoutinePresentation
import Observation

@Observable
@MainActor
public final class OnboardingViewModel {
    public var currentPage = 0
    public private(set) var hasCompletedOnboarding: Bool

    public let pageCount = 3

    private let userPreferencesUseCase: UserPreferencesUseCase
    private let analyticsUseCase: AnalyticsUseCase

    public init(
        userPreferencesUseCase: UserPreferencesUseCase,
        analyticsUseCase: AnalyticsUseCase = NoOpAnalyticsUseCase()
    ) {
        self.userPreferencesUseCase = userPreferencesUseCase
        self.analyticsUseCase = analyticsUseCase
        self.hasCompletedOnboarding = userPreferencesUseCase.hasCompletedOnboarding()
    }

    public var isLastPage: Bool {
        currentPage == pageCount - 1
    }

    public var canGoBack: Bool {
        currentPage > 0
    }

    public func goToNextPage() {
        guard !isLastPage else {
            completeOnboarding()
            return
        }

        currentPage += 1
    }

    public func goToPreviousPage() {
        guard canGoBack else { return }
        currentPage -= 1
    }

    public func completeOnboarding() {
        userPreferencesUseCase.setHasCompletedOnboarding(true)
        analyticsUseCase.track(.onboardingCompleted())
        hasCompletedOnboarding = true
        resetProgress()
    }

    public func refreshState() {
        hasCompletedOnboarding = userPreferencesUseCase.hasCompletedOnboarding()
    }

    public func prepareForSignedOutState() {
        refreshState()
        resetProgress()
    }

    private func resetProgress() {
        currentPage = 0
    }
}
