import Foundation
import HealthKit
import OSLog
import WatchDomainLayerInterface

protocol WatchHydrationLocalDataSource: Sendable {
    func hydrationEvents(on date: Date) async -> [WatchHydrationEvent]
    @discardableResult
    func addDrink(volumeML: Int, consumedAt: Date) async -> HydrationWriteResult
    @discardableResult
    func resetEvents(on date: Date) async -> HydrationWriteResult
}

actor WatchHydrationHealthKitDataSource: WatchHydrationLocalDataSource {
    private enum Constants {
        static let appSourcePrefix = "gaeng2y.DrinkWater"
    }

    private let logger = Logger(
        subsystem: "gaeng2y.DrinkWater",
        category: "WatchHydrationHealthKitDataSource"
    )
    private let healthStore = HKHealthStore()
    private let calendar: Calendar

    init(calendar: Calendar = .autoupdatingCurrent) {
        self.calendar = calendar
    }

    func hydrationEvents(on date: Date) async -> [WatchHydrationEvent] {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            logger.error("Unable to resolve dietaryWater quantity type on watch.")
            return []
        }

        let interval = dayInterval(for: date)
        let predicate = HKQuery.predicateForSamples(
            withStart: interval.start,
            end: interval.end,
            options: .strictStartDate
        )

        return await withCheckedContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: waterType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: true)]
            ) { _, samples, error in
                if let error {
                    self.logger.error("Failed to fetch watch hydration samples: \(String(describing: error))")
                    continuation.resume(returning: [])
                    return
                }

                let events = (samples as? [HKQuantitySample])?.map { sample in
                    WatchHydrationEvent(
                        id: sample.uuid,
                        consumedAt: sample.startDate,
                        volumeML: Int(
                            sample.quantity.doubleValue(for: .literUnit(with: .milli)).rounded()
                        )
                    )
                } ?? []

                continuation.resume(returning: events)
            }

            healthStore.execute(query)
        }
    }

    @discardableResult
    func addDrink(volumeML: Int, consumedAt: Date) async -> HydrationWriteResult {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            logger.error("Unable to resolve dietaryWater quantity type on watch.")
            return .failure(.invalidObjectType)
        }

        guard HKHealthStore.isHealthDataAvailable(),
              healthStore.authorizationStatus(for: waterType) == .sharingAuthorized else {
            logger.error("HealthKit water write permission is unavailable on watch.")
            return .failure(.permissionDenied)
        }

        let quantity = HKQuantity(unit: .literUnit(with: .milli), doubleValue: Double(volumeML))
        let sample = HKQuantitySample(type: waterType, quantity: quantity, start: consumedAt, end: consumedAt)

        do {
            try await healthStore.save(sample)
            return .success
        } catch {
            logger.error("Failed to save watch hydration sample: \(String(describing: error))")
            return .failure(Self.writeFailureReason(for: error))
        }
    }

    @discardableResult
    func resetEvents(on date: Date) async -> HydrationWriteResult {
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            logger.error("Unable to resolve dietaryWater quantity type on watch.")
            return .failure(.invalidObjectType)
        }

        guard HKHealthStore.isHealthDataAvailable(),
              healthStore.authorizationStatus(for: waterType) == .sharingAuthorized else {
            logger.error("HealthKit water reset permission is unavailable on watch.")
            return .failure(.permissionDenied)
        }

        let interval = dayInterval(for: date)
        let predicate = HKQuery.predicateForSamples(
            withStart: interval.start,
            end: interval.end,
            options: .strictStartDate
        )

        return await withCheckedContinuation { (continuation: CheckedContinuation<HydrationWriteResult, Never>) in
            let query = HKSampleQuery(
                sampleType: waterType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: nil
            ) { _, samples, error in
                if let error {
                    self.logger.error("Failed to fetch watch samples for reset: \(String(describing: error))")
                    continuation.resume(returning: HydrationWriteResult.failure(Self.writeFailureReason(for: error)))
                    return
                }

                let ownedSamples = (samples as? [HKQuantitySample])?.filter { sample in
                    sample.sourceRevision.source.bundleIdentifier.hasPrefix(Constants.appSourcePrefix)
                } ?? []

                guard !ownedSamples.isEmpty else {
                    continuation.resume(returning: HydrationWriteResult.success)
                    return
                }

                self.healthStore.delete(ownedSamples) { _, error in
                    if let error {
                        self.logger.error("Failed to reset watch hydration samples: \(String(describing: error))")
                        continuation.resume(
                            returning: HydrationWriteResult.failure(Self.writeFailureReason(for: error))
                        )
                        return
                    }

                    continuation.resume(returning: HydrationWriteResult.success)
                }
            }

            healthStore.execute(query)
        }
    }

    private static func writeFailureReason(for error: Error) -> HydrationWriteFailureReason {
        if let healthKitError = error as? HKError {
            switch healthKitError.code {
            case .errorAuthorizationDenied, .errorAuthorizationNotDetermined:
                return .permissionDenied
            case .errorInvalidArgument:
                return .invalidObjectType
            default:
                return .systemError
            }
        }

        return .systemError
    }

    private func dayInterval(for date: Date) -> DateInterval {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start)
            ?? start.addingTimeInterval(86_400)
        return DateInterval(start: start, end: end)
    }
}
