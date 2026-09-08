import Foundation
import Testing

@testable import HydrationData

struct HydrationComebackRepositoryTests {
    @Test("복귀 처리 시각을 저장해 저장소 재생성 후에도 유지한다")
    func persistsHandledDate() {
        let suiteName = "HydrationComebackRepositoryTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defer { defaults.removePersistentDomain(forName: suiteName) }
        let repository = HydrationComebackRepositoryImpl(userDefaults: defaults)
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        #expect(repository.fetchLastHandledDate() == nil)

        repository.saveLastHandledDate(date)

        let reloaded = HydrationComebackRepositoryImpl(userDefaults: UserDefaults(suiteName: suiteName)!)
        #expect(reloaded.fetchLastHandledDate() == date)
    }
}
