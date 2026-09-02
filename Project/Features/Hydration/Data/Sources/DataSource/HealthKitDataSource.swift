//
//  HealthKitDataSource.swift
//  HydrationData
//
//  Created by Kyeongmo Yang on 7/17/25.
//  Copyright © 2025 gaeng2y. All rights reserved.
//

import HydrationDomain
import Foundation
import HealthKit
import MulimiHealthKit

public protocol HealthKitDataSource: Sendable {
    var healthKitAuthorizationStatus: HealthKitAuthorizationStatus { get }

    func requestAuthorization() async throws
    func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(date: Date, amount: Double)]
    func readWaterSamples(from startDate: Date, to endDate: Date) async throws -> [HydrationEvent]
    func readBodyProfile() async throws -> BodyProfile
    func setAGlassOfWater() async throws
    func setWaterIntake(volumeML: Int) async throws
    func deleteWaterSample(id: UUID) async throws -> Bool
    func resetWaterInTakeInToday() async throws
}

public final class HealthKitDataSourceImpl: HealthKitDataSource, @unchecked Sendable {
    private let store: HealthQuantityStoring

    public init(store: HealthQuantityStoring = HealthKitQuantityStore()) {
        self.store = store
    }

    private var isWaterSharingAuthorized: Bool {
        store.isHealthDataAvailable
            && store.authorizationStatus(for: .dietaryWater) == .sharingAuthorized
    }

    public var healthKitAuthorizationStatus: HealthKitAuthorizationStatus {
        switch store.authorizationStatus(for: .dietaryWater) {
        case .notDetermined: .notDetermined
        case .sharingDenied: .sharingDenied
        case .sharingAuthorized: .sharingAuthorized
        @unknown default: .notDetermined
        }
    }

    public func requestAuthorization() async throws {
        do {
            try await store.requestAuthorization(
                share: [.dietaryWater],
                read: [.dietaryWater, .height, .bodyMass]
            )
        } catch HealthQuantityStoreError.invalidObjectType {
            throw HealthKitError.invalidObjectType
        } catch {
            throw HealthKitError.permissionDenied
        }
    }

    public func readWaterIntake(from startDate: Date, to endDate: Date) async throws -> [(date: Date, amount: Double)] {
        guard isWaterSharingAuthorized else {
            return []
        }

        do {
            return try await store.dailyCumulativeSums(
                of: .dietaryWater,
                unit: .literUnit(with: .milli),
                from: startDate,
                to: endDate
            ).map { (date: $0.date, amount: $0.value) }
        } catch {
            throw Self.healthKitError(from: error)
        }
    }

    public func readWaterSamples(from startDate: Date, to endDate: Date) async throws -> [HydrationEvent] {
        guard isWaterSharingAuthorized else {
            return []
        }

        do {
            return try await store.samples(
                of: .dietaryWater,
                unit: .literUnit(with: .milli),
                from: startDate,
                to: endDate
            ).map { sample in
                HydrationEvent(
                    id: sample.id,
                    consumedAt: sample.startDate,
                    volumeML: Int(sample.value.rounded()),
                    isOwnedByCurrentApp: sample.isOwnedByCurrentApp
                )
            }
        } catch {
            throw Self.healthKitError(from: error)
        }
    }

    public func readBodyProfile() async throws -> BodyProfile {
        guard isWaterSharingAuthorized else {
            throw HealthKitError.permissionDenied
        }

        do {
            async let heightCM = store.latestValue(of: .height, unit: .meterUnit(with: .centi))
            async let weightKG = store.latestValue(of: .bodyMass, unit: .gramUnit(with: .kilo))

            let latestHeightCM = try await heightCM
            let latestWeightKG = try await weightKG

            return BodyProfile(
                heightCM: latestHeightCM.map { BodyProfileValue(value: $0, source: .healthKit) },
                weightKG: latestWeightKG.map { BodyProfileValue(value: $0, source: .healthKit) }
            )
        } catch {
            throw Self.healthKitError(from: error)
        }
    }

    public func setAGlassOfWater() async throws {
        try await setWaterIntake(volumeML: HydrationServing.defaultGlassVolumeML)
    }

    public func setWaterIntake(volumeML: Int) async throws {
        guard volumeML > 0 else {
            throw HealthKitError.healthKitInternalError
        }

        guard isWaterSharingAuthorized else {
            throw HealthKitError.permissionDenied
        }

        do {
            try await store.save(
                Double(volumeML),
                unit: .literUnit(with: .milli),
                of: .dietaryWater,
                at: .now
            )
        } catch HealthQuantityStoreError.invalidObjectType {
            throw HealthKitError.invalidObjectType
        }
    }

    public func deleteWaterSample(id: UUID) async throws -> Bool {
        guard isWaterSharingAuthorized else {
            throw HealthKitError.permissionDenied
        }

        do {
            return try await store.deleteOwnedSample(id: id, of: .dietaryWater)
        } catch {
            throw Self.healthKitError(from: error)
        }
    }

    public func resetWaterInTakeInToday() async throws {
        guard isWaterSharingAuthorized else {
            throw HealthKitError.permissionDenied
        }

        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: .now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? .now

        do {
            try await store.deleteOwnedSamples(of: .dietaryWater, from: startOfDay, to: endOfDay)
        } catch HealthQuantityStoreError.invalidObjectType {
            throw HealthKitError.invalidObjectType
        }
    }

    private static func healthKitError(from error: Error) -> HealthKitError {
        switch error {
        case HealthQuantityStoreError.invalidObjectType:
            .invalidObjectType
        case HealthQuantityStoreError.incompleteQuery:
            .incompleteExecuteQuery
        default:
            .healthKitInternalError
        }
    }
}
