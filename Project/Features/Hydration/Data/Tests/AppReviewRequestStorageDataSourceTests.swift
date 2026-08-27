import HydrationDomain
import Foundation
import Testing

@testable import HydrationData

@Suite("AppReviewRequestStorageDataSource Tests")
struct AppReviewRequestStorageDataSourceTests {
    @Test("리뷰 요청 상태를 저장하고 다시 읽는다")
    func saveAndFetchState() {
        let suiteName = "AppReviewRequestStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }
        let dataSource = AppReviewRequestStorageDataSourceImpl(userDefaults: userDefaults)
        let state = AppReviewRequestState(
            attemptedMarketingVersions: ["1.0.0", "2.0.0"],
            attemptDates: [
                Date(timeIntervalSince1970: 1_710_000_000),
                Date(timeIntervalSince1970: 1_720_000_000)
            ]
        )

        dataSource.saveState(state)

        #expect(dataSource.fetchState() == state)
    }

    @Test("저장값이 없거나 손상되면 빈 상태를 반환한다")
    func emptyAndCorruptState() {
        let suiteName = "AppReviewRequestStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }
        let dataSource = AppReviewRequestStorageDataSourceImpl(userDefaults: userDefaults)

        #expect(dataSource.fetchState() == .empty)

        userDefaults.set(Data("invalid".utf8), forKey: .appReviewRequestState)

        #expect(dataSource.fetchState() == .empty)
    }

    private func makeIsolatedUserDefaults(suiteName: String) -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)
        return userDefaults
    }
}
