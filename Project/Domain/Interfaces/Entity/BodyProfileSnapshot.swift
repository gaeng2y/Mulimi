//
//  BodyProfileSnapshot.swift
//  DomainLayerInterface
//
//  Created by Codex on 3/30/26.
//

import Foundation

public struct BodyProfileSnapshot: Hashable, Sendable {
    public let authorizationStatus: HealthKitAuthorizationStatus
    public let healthKitBodyProfile: BodyProfile
    public let manualBodyProfile: BodyProfile
    public let resolvedBodyProfile: BodyProfile
    public let availability: BodyProfileAvailability
    public let didFailHealthKitSync: Bool

    public init(
        authorizationStatus: HealthKitAuthorizationStatus,
        healthKitBodyProfile: BodyProfile,
        manualBodyProfile: BodyProfile,
        resolvedBodyProfile: BodyProfile,
        availability: BodyProfileAvailability,
        didFailHealthKitSync: Bool
    ) {
        self.authorizationStatus = authorizationStatus
        self.healthKitBodyProfile = healthKitBodyProfile
        self.manualBodyProfile = manualBodyProfile
        self.resolvedBodyProfile = resolvedBodyProfile
        self.availability = availability
        self.didFailHealthKitSync = didFailHealthKitSync
    }
}
