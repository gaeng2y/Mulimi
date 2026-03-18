import DomainLayerInterface
import Foundation
import Testing

@testable import DataLayer

@Suite("ChallengeStorageDataSource Tests")
struct ChallengeStorageDataSourceTests {
    private struct LegacyHydrationChallengeState: Codable {
        let kind: HydrationChallengeKind
        let progress: Double
        let isCompleted: Bool
        let achievedAt: Date?
        let updatedAt: Date
    }

    @Test("challenge state를 저장하고 다시 읽어온다")
    func saveAndFetchStates() {
        let suiteName = "ChallengeStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = ChallengeStorageDataSourceImpl(userDefaults: userDefaults)
        let achievedAt = Date(timeIntervalSince1970: 1_710_000_000)
        let states = [
            HydrationChallengeState.recurring(
                HydrationRecurringChallengeState(
                    kind: .streak7,
                    cycleID: "streak:1710000000",
                    progress: 1,
                    isCompleted: true,
                    achievedAt: achievedAt,
                    updatedAt: achievedAt
                )
            ),
            HydrationChallengeState.cumulative(
                HydrationCumulativeChallengeState(
                    kind: .goalAchievement30,
                    progress: 0.4,
                    isCompleted: false,
                    achievedAt: nil,
                    updatedAt: achievedAt
                )
            )
        ]

        dataSource.saveChallengeStates(states)

        #expect(dataSource.fetchChallengeStates() == states)
    }

    @Test("legacy challenge state를 새 모델로 마이그레이션한다")
    func migrateLegacyStates() throws {
        let suiteName = "ChallengeStorageDataSourceTests.\(UUID().uuidString)"
        let userDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = ChallengeStorageDataSourceImpl(userDefaults: userDefaults)
        let achievedAt = Date(timeIntervalSince1970: 1_710_000_000)
        let legacyStates = [
            LegacyHydrationChallengeState(
                kind: .weeklyAchievement80,
                progress: 1,
                isCompleted: true,
                achievedAt: achievedAt,
                updatedAt: achievedAt
            ),
            LegacyHydrationChallengeState(
                kind: .goalAchievement30,
                progress: 0.8,
                isCompleted: true,
                achievedAt: achievedAt,
                updatedAt: achievedAt
            )
        ]

        userDefaults.set(try JSONEncoder().encode(legacyStates), forKey: .hydrationChallengeStates)

        let migratedStates = dataSource.fetchChallengeStates()

        #expect(migratedStates.count == 2)
        #expect(migratedStates[0].kind == .weeklyAchievement80)
        #expect(migratedStates[0].recurringState?.isCompleted == false)
        #expect(migratedStates[0].recurringState?.achievedAt == nil)
        #expect(migratedStates[1].kind == .goalAchievement30)
        #expect(migratedStates[1].cumulativeState?.isCompleted == true)
        #expect(migratedStates[1].achievedAt == achievedAt)
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
