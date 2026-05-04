//
//  HealthKitPermissionViewModel.swift
//  PresentationLayer
//
//  Created by Codex on 3/25/26.
//

import DomainLayerInterface
import Foundation
import Localization
import Observation

@Observable
@MainActor
public final class HealthKitPermissionViewModel {
    public private(set) var authorizationStatus: HealthKitAuthorizationStatus
    public private(set) var isAuthorized: Bool
    public var isLoading = false
    public var errorMessage: String?

    private let healthKitUseCase: HealthKitUseCase
    private let analyticsUseCase: AnalyticsUseCase
    private var didTrackGateViewed = false
    private var didTrackAuthorized = false
    private var didTrackDenied = false

    public init(
        healthKitUseCase: HealthKitUseCase,
        analyticsUseCase: AnalyticsUseCase = NoOpAnalyticsUseCase()
    ) {
        self.healthKitUseCase = healthKitUseCase
        self.analyticsUseCase = analyticsUseCase
        let status = healthKitUseCase.authorisationStatus
        self.authorizationStatus = status
        self.isAuthorized = status == .sharingAuthorized
    }

    public func prepareIfNeeded() async {
        refreshStatus()

        if !isAuthorized && !didTrackGateViewed {
            analyticsUseCase.track(
                .healthKitPermissionGateViewed(status: authorizationStatus)
            )
            didTrackGateViewed = true
        }

        trackPermissionOutcomeIfNeeded(source: "healthkit_permission_gate")

        guard !isAuthorized else {
            errorMessage = nil
            return
        }
    }

    public func refreshStatus() {
        authorizationStatus = healthKitUseCase.authorisationStatus
        isAuthorized = authorizationStatus == .sharingAuthorized

        if isAuthorized {
            errorMessage = nil
        }
    }

    public func requestAuthorization() async {
        isLoading = true
        errorMessage = nil
        analyticsUseCase.track(
            .healthKitPermissionRequestTapped(status: authorizationStatus)
        )

        do {
            try await healthKitUseCase.requestAuthorization()
        } catch {
            errorMessage = defaultErrorMessage
        }

        refreshStatus()

        if authorizationStatus == .sharingDenied {
            errorMessage = deniedMessage
        } else if isAuthorized {
            errorMessage = nil
        } else if errorMessage == nil {
            errorMessage = defaultErrorMessage
        }

        trackPermissionOutcomeIfNeeded(source: "healthkit_permission_gate")
        isLoading = false
    }

    public func trackSettingsTapped() {
        analyticsUseCase.track(
            .healthKitPermissionSettingsTapped(status: authorizationStatus)
        )
    }

    public func refreshStatusFromSettings() {
        analyticsUseCase.track(
            .healthKitPermissionRefreshTapped(status: authorizationStatus)
        )
        refreshStatus()
        trackPermissionOutcomeIfNeeded(source: "healthkit_permission_gate")
    }

    public func markSignedOut() {
        errorMessage = nil
        refreshStatus()
    }

    private var deniedMessage: String {
        L10n.tr("healthKitPermissionDeniedErrorDescription")
    }

    private var defaultErrorMessage: String {
        L10n.tr("healthKitPermissionRequestFailureDescription")
    }

    private func trackPermissionOutcomeIfNeeded(source: String) {
        switch authorizationStatus {
        case .sharingAuthorized:
            guard !didTrackAuthorized else {
                return
            }
            analyticsUseCase.track(
                .healthKitPermissionAuthorized(
                    source: source,
                    status: authorizationStatus
                )
            )
            didTrackAuthorized = true
        case .sharingDenied:
            guard !didTrackDenied else {
                return
            }
            analyticsUseCase.track(
                .healthKitPermissionDenied(
                    source: source,
                    status: authorizationStatus
                )
            )
            didTrackDenied = true
        case .notDetermined:
            return
        }
    }
}
