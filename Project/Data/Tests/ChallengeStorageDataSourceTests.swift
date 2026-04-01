import DomainLayerInterface
import Foundation
import Testing

@testable import DataLayer

@Suite("ChallengeStorageDataSource Tests")
struct ChallengeStorageDataSourceTests {
    @Test("badge history를 저장하고 다시 읽어온다")
    func saveAndFetchBadgeHistories() {
        let suiteName = "ChallengeStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = ChallengeStorageDataSourceImpl(userDefaults: userDefaults)
        let achievedAt = Date(timeIntervalSince1970: 1_710_000_000)
        let histories = [
            HydrationChallengeBadgeHistory(
                kind: .weeklyAchievement80,
                achievedAt: achievedAt,
                cycleID: "week:1710000000"
            ),
            HydrationChallengeBadgeHistory(
                kind: .goalAchievement30,
                achievedAt: achievedAt.addingTimeInterval(3_600)
            )
        ]

        dataSource.saveBadgeHistories(histories)

        #expect(dataSource.fetchBadgeHistories() == histories)
    }

    @Test("저장된 데이터가 없으면 빈 배열을 반환한다")
    func emptyState() {
        let suiteName = "ChallengeStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = ChallengeStorageDataSourceImpl(userDefaults: userDefaults)

        #expect(dataSource.fetchBadgeHistories().isEmpty)
    }

    @Test("기존 challenge state 데이터가 있어도 badge history 조회에는 영향을 주지 않는다")
    func legacyChallengeStatesDoNotAffectBadgeHistory() {
        let suiteName = "ChallengeStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = ChallengeStorageDataSourceImpl(userDefaults: userDefaults)
        let timestamp = Date(timeIntervalSince1970: 1_710_000_000)
        let histories = [
            HydrationChallengeBadgeHistory(
                kind: .goalAchievement30,
                achievedAt: timestamp
            )
        ]

        userDefaults.set(Data("legacy".utf8), forKey: .hydrationChallengeStates)
        dataSource.saveBadgeHistories(histories)

        #expect(dataSource.fetchBadgeHistories() == histories)
    }

    private func makeIsolatedUserDefaults(suiteName: String) -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)
        return userDefaults
    }
}
