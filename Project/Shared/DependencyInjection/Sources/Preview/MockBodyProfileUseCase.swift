//
//  MockBodyProfileUseCase.swift
//  DependencyInjectionPreview
//
//  Created by Codex on 3/30/26.
//

import DomainLayerInterface

public final class MockBodyProfileUseCase: BodyProfileUseCase, @unchecked Sendable {
    public var snapshot: BodyProfileSnapshot = BodyProfileSnapshot(
        authorizationStatus: .sharingAuthorized,
        healthKitBodyProfile: BodyProfile(
            heightCM: BodyProfileValue(value: 172, source: .healthKit),
            weightKG: BodyProfileValue(value: 64, source: .healthKit)
        ),
        manualBodyProfile: .empty,
        resolvedBodyProfile: BodyProfile(
            heightCM: BodyProfileValue(value: 172, source: .healthKit),
            weightKG: BodyProfileValue(value: 64, source: .healthKit)
        ),
        availability: .ready,
        didFailHealthKitSync: false
    )

    public init() {}

    public func loadBodyProfile() async -> BodyProfileSnapshot {
        snapshot
    }

    public func requestHealthKitSync() async throws -> BodyProfileSnapshot {
        snapshot
    }
}
