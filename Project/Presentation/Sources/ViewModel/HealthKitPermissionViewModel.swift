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
        "한 번 거부한 건강 권한은 앱에서 다시 요청할 수 없어요. 설정에서 다시 허용해 주세요."
    }

    private var defaultErrorMessage: String {
        "건강 권한을 확인하는 중 문제가 발생했어요. 잠시 후 다시 시도해 주세요."
    }
}
