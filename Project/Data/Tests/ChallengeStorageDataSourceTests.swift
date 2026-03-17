import DomainLayerInterface
import Foundation
import Testing

@testable import DataLayer

@Suite("ChallengeStorageDataSource Tests")
struct ChallengeStorageDataSourceTests {
    @Test("challenge state를 저장하고 다시 읽어온다")
    func saveAndFetchStates() {
        let suiteName = "ChallengeStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = ChallengeStorageDataSourceImpl(userDefaults: userDefaults)
        let achievedAt = Date(timeIntervalSince1970: 1_710_000_000)
        let states = [
            HydrationChallengeState(
                kind: .streak7,
                progress: 1,
                isCompleted: true,
                achievedAt: achievedAt,
                updatedAt: achievedAt
            ),
            HydrationChallengeState(
                kind: .goalAchievement30,
                progress: 0.4,
                isCompleted: false,
                achievedAt: nil,
                updatedAt: achievedAt
            )
        ]

        dataSource.saveChallengeStates(states)

        #expect(dataSource.fetchChallengeStates() == states)
    }

    @Test("저장된 데이터가 없으면 빈 배열을 반환한다")
    func emptyState() {
        let suiteName = "ChallengeStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = ChallengeStorageDataSourceImpl(userDefaults: userDefaults)

        #expect(dataSource.fetchChallengeStates().isEmpty)
    }

    private func makeIsolatedUserDefaults(suiteName: String) -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)
        return userDefaults
    }
}
