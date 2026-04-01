//
//  BodyProfileUseCaseImpl.swift
//  DomainLayer
//
//  Created by Codex on 3/30/26.
//

import DomainLayerInterface

public struct BodyProfileUseCaseImpl: BodyProfileUseCase {
    private let healthKitRepository: HealthKitRepository

    public init(
        healthKitRepository: HealthKitRepository
    ) {
        self.healthKitRepository = healthKitRepository
    }

    public func loadBodyProfile() async -> BodyProfileSnapshot {
        let authorizationStatus = healthKitRepository.authorisationStatus

        guard authorizationStatus == .sharingAuthorized else {
            return snapshot(
                authorizationStatus: authorizationStatus,
                healthKitBodyProfile: .empty,
                didFailHealthKitSync: false
            )
        }

        do {
            let healthKitBodyProfile = try await healthKitRepository.fetchBodyProfile()
            return snapshot(
                authorizationStatus: authorizationStatus,
                healthKitBodyProfile: healthKitBodyProfile,
                didFailHealthKitSync: false
            )
        } catch {
            return snapshot(
                authorizationStatus: authorizationStatus,
                healthKitBodyProfile: .empty,
                didFailHealthKitSync: true
            )
        }
    }

    public func requestHealthKitSync() async throws -> BodyProfileSnapshot {
        if healthKitRepository.authorisationStatus == .notDetermined {
            try await healthKitRepository.requestAuthorization()
        }

        return await loadBodyProfile()
    }

    private func snapshot(
        authorizationStatus: HealthKitAuthorizationStatus,
        healthKitBodyProfile: BodyProfile,
        didFailHealthKitSync: Bool
    ) -> BodyProfileSnapshot {
        let resolvedBodyProfile = healthKitBodyProfile

        return BodyProfileSnapshot(
            authorizationStatus: authorizationStatus,
            healthKitBodyProfile: healthKitBodyProfile,
            manualBodyProfile: .empty,
            resolvedBodyProfile: resolvedBodyProfile,
            availability: availability(
                authorizationStatus: authorizationStatus,
                healthKitBodyProfile: healthKitBodyProfile,
                resolvedBodyProfile: resolvedBodyProfile
            ),
            didFailHealthKitSync: didFailHealthKitSync
        )
    }

    private func availability(
        authorizationStatus: HealthKitAuthorizationStatus,
        healthKitBodyProfile: BodyProfile,
        resolvedBodyProfile: BodyProfile
    ) -> BodyProfileAvailability {
        if resolvedBodyProfile.isComplete {
            return .ready
        }

        switch authorizationStatus {
        case .notDetermined:
            return .needsPermission
        case .sharingDenied:
            return .permissionDenied
        case .sharingAuthorized:
            if healthKitBodyProfile.isEmpty {
                return .noData
            }
            return .incomplete
        }
    }
}
