import Foundation
import HydrationDomain

public final class HydrationComebackRepositoryImpl: HydrationComebackRepository, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let key = "hydrationComebackLastHandledDate"

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func fetchLastHandledDate() -> Date? {
        userDefaults.object(forKey: key) as? Date
    }

    public func saveLastHandledDate(_ date: Date) {
        userDefaults.set(date, forKey: key)
    }
}
