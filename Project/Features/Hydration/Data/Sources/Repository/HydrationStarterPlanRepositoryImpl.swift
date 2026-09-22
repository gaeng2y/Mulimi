import Foundation
import HydrationDomain

public final class HydrationStarterPlanRepositoryImpl: HydrationStarterPlanRepository, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let key = "hydrationStarterPlan.v1"

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func fetchPlan() -> HydrationStarterPlan? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(HydrationStarterPlan.self, from: data)
    }

    public func savePlan(_ plan: HydrationStarterPlan) {
        guard let data = try? JSONEncoder().encode(plan) else {
            return
        }
        userDefaults.set(data, forKey: key)
    }
}
