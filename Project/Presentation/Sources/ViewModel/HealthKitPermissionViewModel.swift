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

    public init(healthKitUseCase: HealthKitUseCase) {
        self.healthKitUseCase = healthKitUseCase
        let status = healthKitUseCase.authorisationStatus
        self.authorizationStatus = status
        self.isAuthorized = status == .sharingAuthorized
    }

    public func prepareIfNeeded() async {
        refreshStatus()

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

        isLoading = false
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
}
