import Foundation
import HydrationDomain
import Testing

@testable import HydrationData

struct HydrationStarterPlanRepositoryTests {
    @Test("방법 선택과 완료·닫기 상태는 저장소를 다시 만들어도 유지한다", arguments: [false, true])
    func persistence(isDismissed: Bool) {
        let suiteName = "HydrationStarterPlanRepositoryTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let repository = HydrationStarterPlanRepositoryImpl(userDefaults: defaults)
        #expect(repository.fetchPlan() == nil)
        let plan = HydrationStarterPlan(
            startedAt: Date(timeIntervalSince1970: 1_800_000_000),
            quickRecordingMethod: .shortcuts,
            isDismissed: isDismissed,
            isCompleted: !isDismissed
        )
        repository.savePlan(plan)

        let reloaded = HydrationStarterPlanRepositoryImpl(userDefaults: UserDefaults(suiteName: suiteName)!)
        #expect(reloaded.fetchPlan() == plan)

        defaults.set(Data("invalid".utf8), forKey: "hydrationStarterPlan.v1")
        #expect(reloaded.fetchPlan() == nil)
    }
}
