import Foundation
import HealthKit

public struct HealthQuantitySample: Sendable {
    public let id: UUID
    public let startDate: Date
    public let value: Double
    public let isOwnedByCurrentApp: Bool

    public init(id: UUID, startDate: Date, value: Double, isOwnedByCurrentApp: Bool) {
        self.id = id
        self.startDate = startDate
        self.value = value
        self.isOwnedByCurrentApp = isOwnedByCurrentApp
    }
}

public enum HealthQuantityStoreError: Error, Sendable {
    case invalidObjectType
    case permissionDenied
    case incompleteQuery
    case internalError
}

public protocol HealthQuantityStoring: Sendable {
    var isHealthDataAvailable: Bool { get }

    func authorizationStatus(for identifier: HKQuantityTypeIdentifier) -> HKAuthorizationStatus
    func requestAuthorization(
        share: [HKQuantityTypeIdentifier],
        read: [HKQuantityTypeIdentifier]
    ) async throws
    func dailyCumulativeSums(
        of identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        from startDate: Date,
        to endDate: Date
    ) async throws -> [(date: Date, value: Double)]
    func samples(
        of identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        from startDate: Date,
        to endDate: Date
    ) async throws -> [HealthQuantitySample]
    func latestValue(of identifier: HKQuantityTypeIdentifier, unit: HKUnit) async throws -> Double?
    func save(
        _ value: Double,
        unit: HKUnit,
        of identifier: HKQuantityTypeIdentifier,
        at date: Date
    ) async throws
    func deleteOwnedSample(id: UUID, of identifier: HKQuantityTypeIdentifier) async throws -> Bool
    func deleteOwnedSamples(
        of identifier: HKQuantityTypeIdentifier,
        from startDate: Date,
        to endDate: Date
    ) async throws
}

/// HealthKit quantity 샘플에 대한 범용 저장소.
/// 권한 정책·도메인 매핑은 소비자(feature Data)가 담당하고,
/// HealthKit 시스템 오류는 원본 그대로 다시 던져 소비자별 매핑을 보존한다.
public final class HealthKitQuantityStore: HealthQuantityStoring, @unchecked Sendable {
    private let healthStore: HKHealthStore
    private let ownedSourcePrefix: String

    public init(
        healthStore: HKHealthStore = HKHealthStore(),
        ownedSourcePrefix: String = "gaeng2y.DrinkWater"
    ) {
        self.healthStore = healthStore
        self.ownedSourcePrefix = ownedSourcePrefix
    }

    public var isHealthDataAvailable: Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    public func authorizationStatus(for identifier: HKQuantityTypeIdentifier) -> HKAuthorizationStatus {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            return .notDetermined
        }

        return healthStore.authorizationStatus(for: quantityType)
    }

    public func requestAuthorization(
        share: [HKQuantityTypeIdentifier],
        read: [HKQuantityTypeIdentifier]
    ) async throws {
        let shareTypes = try share.map(Self.quantityType(for:))
        let readTypes = try read.map(Self.quantityType(for:))

        try await healthStore.requestAuthorization(toShare: Set(shareTypes), read: Set(readTypes))
    }

    public func dailyCumulativeSums(
        of identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        from startDate: Date,
        to endDate: Date
    ) async throws -> [(date: Date, value: Double)] {
        let quantityType = try Self.quantityType(for: identifier)

        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: .strictStartDate
            )
            let query = HKStatisticsCollectionQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum,
                anchorDate: startDate,
                intervalComponents: DateComponents(day: 1)
            )
            query.initialResultsHandler = { _, result, error in
                if error != nil {
                    continuation.resume(throwing: HealthQuantityStoreError.internalError)
                    return
                }

                guard let result else {
                    continuation.resume(throwing: HealthQuantityStoreError.incompleteQuery)
                    return
                }

                var sums: [(Date, Double)] = []

                result.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    let value = statistics.sumQuantity()?.doubleValue(for: unit) ?? 0
                    sums.append((statistics.startDate, value))
                }
                continuation.resume(returning: sums)
            }

            healthStore.execute(query)
        }
    }

    public func samples(
        of identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        from startDate: Date,
        to endDate: Date
    ) async throws -> [HealthQuantitySample] {
        let quantityType = try Self.quantityType(for: identifier)

        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: .strictStartDate
            )
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if error != nil {
                    continuation.resume(throwing: HealthQuantityStoreError.internalError)
                    return
                }

                let records = ((samples as? [HKQuantitySample]) ?? []).map { sample in
                    HealthQuantitySample(
                        id: sample.uuid,
                        startDate: sample.startDate,
                        value: sample.quantity.doubleValue(for: unit),
                        isOwnedByCurrentApp: sample.sourceRevision.source.bundleIdentifier
                            .hasPrefix(self.ownedSourcePrefix)
                    )
                }

                continuation.resume(returning: records)
            }

            healthStore.execute(query)
        }
    }

    public func latestValue(
        of identifier: HKQuantityTypeIdentifier,
        unit: HKUnit
    ) async throws -> Double? {
        let quantityType = try Self.quantityType(for: identifier)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
            ) { _, samples, error in
                if error != nil {
                    continuation.resume(throwing: HealthQuantityStoreError.internalError)
                    return
                }

                guard let sample = (samples as? [HKQuantitySample])?.first else {
                    continuation.resume(returning: nil)
                    return
                }

                continuation.resume(returning: sample.quantity.doubleValue(for: unit))
            }

            healthStore.execute(query)
        }
    }

    public func save(
        _ value: Double,
        unit: HKUnit,
        of identifier: HKQuantityTypeIdentifier,
        at date: Date
    ) async throws {
        let quantityType = try Self.quantityType(for: identifier)
        let quantity = HKQuantity(unit: unit, doubleValue: value)
        let sample = HKQuantitySample(type: quantityType, quantity: quantity, start: date, end: date)

        try await healthStore.save(sample)
    }

    public func deleteOwnedSample(id: UUID, of identifier: HKQuantityTypeIdentifier) async throws -> Bool {
        let quantityType = try Self.quantityType(for: identifier)

        return try await withCheckedThrowingContinuation { continuation in
            let predicate = HKQuery.predicateForObject(with: id)
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, samples, error in
                if error != nil {
                    continuation.resume(throwing: HealthQuantityStoreError.internalError)
                    return
                }

                guard let sample = (samples as? [HKQuantitySample])?.first,
                      sample.sourceRevision.source.bundleIdentifier.hasPrefix(self.ownedSourcePrefix) else {
                    continuation.resume(returning: false)
                    return
                }

                self.healthStore.delete([sample]) { didDelete, deleteError in
                    if deleteError != nil {
                        continuation.resume(throwing: HealthQuantityStoreError.internalError)
                    } else {
                        continuation.resume(returning: didDelete)
                    }
                }
            }

            healthStore.execute(query)
        }
    }

    public func deleteOwnedSamples(
        of identifier: HKQuantityTypeIdentifier,
        from startDate: Date,
        to endDate: Date
    ) async throws {
        let quantityType = try Self.quantityType(for: identifier)

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let predicate = HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: .strictStartDate
            )
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let ownedSamples = (samples as? [HKQuantitySample])?.filter { sample in
                    sample.sourceRevision.source.bundleIdentifier.hasPrefix(self.ownedSourcePrefix)
                } ?? []

                guard !ownedSamples.isEmpty else {
                    continuation.resume(returning: ())
                    return
                }

                self.healthStore.delete(ownedSamples) { _, deleteError in
                    if let deleteError {
                        continuation.resume(throwing: deleteError)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            }

            healthStore.execute(query)
        }
    }

    private static func quantityType(for identifier: HKQuantityTypeIdentifier) throws -> HKQuantityType {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            throw HealthQuantityStoreError.invalidObjectType
        }

        return quantityType
    }
}
