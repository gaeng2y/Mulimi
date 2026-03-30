import DomainLayerInterface

final class MockBodyProfileUseCase: BodyProfileUseCase, @unchecked Sendable {
    var snapshot = BodyProfileSnapshot(
        authorizationStatus: .notDetermined,
        healthKitBodyProfile: .empty,
        manualBodyProfile: .empty,
        resolvedBodyProfile: .empty,
        availability: .needsPermission,
        didFailHealthKitSync: false
    )
    var requestHealthKitSyncError: Error?

    private(set) var loadBodyProfileCallCount = 0
    private(set) var requestHealthKitSyncCallCount = 0

    func loadBodyProfile() async -> BodyProfileSnapshot {
        loadBodyProfileCallCount += 1
        return snapshot
    }

    func requestHealthKitSync() async throws -> BodyProfileSnapshot {
        requestHealthKitSyncCallCount += 1
        if let requestHealthKitSyncError {
            throw requestHealthKitSyncError
        }
        return snapshot
    }
}
