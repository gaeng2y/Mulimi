import Foundation
import HealthKit
import MulimiHealthKit
import OSLog
import WatchHydrationDomain

protocol WatchHydrationLocalDataSource: Sendable {
    func hydrationEvents(on date: Date) async throws -> [WatchHydrationEvent]
    @discardableResult
    func addDrink(volumeML: Int, consumedAt: Date) async -> Result<WatchHydrationEvent, HydrationWriteFailureReason>
    func deleteDrink(id: UUID) async -> HydrationWriteResult
    @discardableResult
    func resetEvents(on date: Date) async -> HydrationWriteResult
}

actor WatchHydrationHealthKitDataSource: WatchHydrationLocalDataSource {
    private let logger = Logger(
        subsystem: "gaeng2y.DrinkWater",
        category: "WatchHydrationHealthKitDataSource"
    )
    private let store: HealthQuantityStoring
    private let calendar: Calendar

    init(
        store: HealthQuantityStoring = HealthKitQuantityStore(),
        calendar: Calendar = .autoupdatingCurrent
    ) {
        self.store = store
        self.calendar = calendar
    }

    private var isWaterSharingAuthorized: Bool {
        store.isHealthDataAvailable
            && store.authorizationStatus(for: .dietaryWater) == .sharingAuthorized
    }

    func hydrationEvents(on date: Date) async throws -> [WatchHydrationEvent] {
        let interval = dayInterval(for: date)

        do {
            return try await store.samples(
                of: .dietaryWater,
                unit: .literUnit(with: .milli),
                from: interval.start,
                to: interval.end
            ).map { sample in
                WatchHydrationEvent(
                    id: sample.id,
                    consumedAt: sample.startDate,
                    volumeML: Int(sample.value.rounded())
                )
            }
        } catch {
            logger.error("Failed to fetch watch hydration samples: \(String(describing: error))")
            throw error
        }
    }

    @discardableResult
    func addDrink(volumeML: Int, consumedAt: Date) async -> Result<WatchHydrationEvent, HydrationWriteFailureReason> {
        guard volumeML > 0 else { return .failure(.invalidObjectType) }
        guard isWaterSharingAuthorized else {
            logger.error("HealthKit water write permission is unavailable on watch.")
            return .failure(.permissionDenied)
        }

        do {
            let id = try await store.save(
                Double(volumeML),
                unit: .literUnit(with: .milli),
                of: .dietaryWater,
                at: consumedAt
            )
            return .success(WatchHydrationEvent(id: id, consumedAt: consumedAt, volumeML: volumeML))
        } catch {
            logger.error("Failed to save watch hydration sample: \(String(describing: error))")
            return .failure(Self.writeFailureReason(for: error))
        }
    }

    func deleteDrink(id: UUID) async -> HydrationWriteResult {
        guard isWaterSharingAuthorized else { return .failure(.permissionDenied) }

        do {
            let deleted = try await store.deleteOwnedSample(id: id, of: .dietaryWater)
            return deleted ? .success : .failure(.systemError)
        } catch {
            logger.error("Failed to undo watch hydration sample: \(String(describing: error))")
            return .failure(Self.writeFailureReason(for: error))
        }
    }

    @discardableResult
    func resetEvents(on date: Date) async -> HydrationWriteResult {
        guard isWaterSharingAuthorized else {
            logger.error("HealthKit water reset permission is unavailable on watch.")
            return .failure(.permissionDenied)
        }

        let interval = dayInterval(for: date)

        do {
            try await store.deleteOwnedSamples(
                of: .dietaryWater,
                from: interval.start,
                to: interval.end
            )
            return .success
        } catch {
            logger.error("Failed to reset watch hydration samples: \(String(describing: error))")
            return .failure(Self.writeFailureReason(for: error))
        }
    }

    private static func writeFailureReason(for error: Error) -> HydrationWriteFailureReason {
        if case HealthQuantityStoreError.permissionDenied = error {
            return .permissionDenied
        }
        if case HealthQuantityStoreError.invalidObjectType = error {
            return .invalidObjectType
        }

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
