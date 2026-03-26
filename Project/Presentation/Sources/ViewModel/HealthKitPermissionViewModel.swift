//
//  HealthKitPermissionViewModel.swift
//  PresentationLayer
//
//  Created by Codex on 3/25/26.
//

import DomainLayerInterface
import Foundation
import Observation

@Observable
@MainActor
public final class HealthKitPermissionViewModel {
    public private(set) var authorizationStatus: HealthKitAuthorizationStatus
    public private(set) var isAuthorized: Bool
    public var isLoading = false
    public var errorMessage: String?

    private let healthKitUseCase: HealthKitUseCase
    private var hasRequestedOnLaunch = false

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

        guard authorizationStatus == .notDetermined, !hasRequestedOnLaunch else {
            return
        }

        hasRequestedOnLaunch = true
        await requestAuthorization()
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
            errorMessage = error.localizedDescription
        }

        refreshStatus()
        isLoading = false
    }

    public func markSignedOut() {
        hasRequestedOnLaunch = false
        errorMessage = nil
        refreshStatus()
    }
}
