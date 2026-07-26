import DomainLayerInterface
import Foundation

public struct HydrationReminderUseCaseImpl: HydrationReminderUseCase {
    private let repository: HydrationReminderRepository

    public init(repository: HydrationReminderRepository) {
        self.repository = repository
    }

    public func authorizationStatus() async -> HydrationReminderAuthorizationStatus {
        await repository.authorizationStatus()
    }

    public func requestAuthorizationAndSyncReminders() async throws -> HydrationReminderAuthorizationStatus {
        let status = try await repository.requestAuthorization()

        if status == .authorized {
            try await repository.scheduleDailyReminders(for: HydrationReminderSlot.allCases)
        } else {
            await repository.cancelDailyReminders()
        }

        return status
    }

    public func syncReminders() async {
        let status = await repository.authorizationStatus()

        guard status == .authorized else {
            await repository.cancelDailyReminders()
            return
        }

        try? await repository.scheduleDailyReminders(for: HydrationReminderSlot.allCases)
    }

    public func hasSeenPermissionPriming() -> Bool {
        repository.hasSeenPermissionPriming()
    }

    public func markPermissionPrimingSeen() {
        repository.setHasSeenPermissionPriming(true)
    }
}
