import DomainLayerInterface
import Foundation

final class MockHealthKitUseCase: HealthKitUseCase, @unchecked Sendable {
    var authorizationStatusValue: HealthKitAuthorizationStatus = .notDetermined

    private(set) var requestAuthorizationCallCount = 0
    private(set) var drinkWaterCallCount = 0
    private(set) var resetCallCount = 0
    private(set) var fetchHistoryCallCount = 0

    var requestAuthorizationError: Error?
    var drinkWaterError: Error?
    var resetError: Error?
    var fetchHistoryError: Error?

    var historyToReturn: [HydrationRecord] = []

    private(set) var capturedFetchStartDate: Date?
    private(set) var capturedFetchEndDate: Date?

    var authorisationStatus: HealthKitAuthorizationStatus {
        authorizationStatusValue
    }

    func requestAuthorization() async throws {
        requestAuthorizationCallCount += 1
        if let requestAuthorizationError {
            throw requestAuthorizationError
        }
        authorizationStatusValue = .sharingAuthorized
    }

    func drinkWater() async throws {
        drinkWaterCallCount += 1
        if let drinkWaterError {
            throw drinkWaterError
        }
    }

    func reset() async throws {
        resetCallCount += 1
        if let resetError {
            throw resetError
        }
    }

    func fetchHistory(from startDate: Date, to endDate: Date) async throws -> [HydrationRecord] {
        fetchHistoryCallCount += 1
        capturedFetchStartDate = startDate
        capturedFetchEndDate = endDate
        if let fetchHistoryError {
            throw fetchHistoryError
        }
        return historyToReturn
    }
}
