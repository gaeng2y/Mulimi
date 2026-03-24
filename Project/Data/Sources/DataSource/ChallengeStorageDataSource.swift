import DomainLayerInterface
import Foundation
import Utils

public protocol ChallengeStorageDataSource: Sendable {
    func fetchChallengeStates() -> [HydrationChallengeState]
    func saveChallengeStates(_ states: [HydrationChallengeState])
    func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory]
    func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory])
}

public final class ChallengeStorageDataSourceImpl: ChallengeStorageDataSource, @unchecked Sendable {
    private struct LegacyHydrationChallengeState: Codable {
        let kind: HydrationChallengeKind
        let progress: Double
        let isCompleted: Bool
        let achievedAt: Date?
        let updatedAt: Date
    }

    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func fetchChallengeStates() -> [HydrationChallengeState] {
        guard let data = userDefaults.data(forKey: .hydrationChallengeStates) else {
            return []
        }

        do {
            return try decoder.decode([HydrationChallengeState].self, from: data)
        } catch {
            guard let legacyStates = try? decoder.decode([LegacyHydrationChallengeState].self, from: data) else {
                return []
            }

            let migratedStates = legacyStates.map(migrateLegacyState(_:))
            saveChallengeStates(migratedStates)
            return migratedStates
        }
    }

    public func saveChallengeStates(_ states: [HydrationChallengeState]) {
        guard let data = try? encoder.encode(states) else {
            return
        }

        userDefaults.set(data, forKey: .hydrationChallengeStates)
        userDefaults.synchronize()
    }

    public func fetchBadgeHistories() -> [HydrationChallengeBadgeHistory] {
        guard let data = userDefaults.data(forKey: .hydrationChallengeBadgeHistories) else {
            return []
        }

        return (try? decoder.decode([HydrationChallengeBadgeHistory].self, from: data)) ?? []
    }

    public func saveBadgeHistories(_ histories: [HydrationChallengeBadgeHistory]) {
        guard let data = try? encoder.encode(histories) else {
            return
        }

        userDefaults.set(data, forKey: .hydrationChallengeBadgeHistories)
        userDefaults.synchronize()
    }

    private func migrateLegacyState(_ legacyState: LegacyHydrationChallengeState) -> HydrationChallengeState {
        switch legacyState.kind.stateType {
        case .recurring:
            return .recurring(
                HydrationRecurringChallengeState(
                    kind: legacyState.kind,
                    cycleID: nil,
                    progress: legacyState.progress,
                    isCompleted: false,
                    achievedAt: nil,
                    updatedAt: legacyState.updatedAt
                )
            )
        case .cumulative:
            return .cumulative(
                HydrationCumulativeChallengeState(
                    kind: legacyState.kind,
                    progress: legacyState.progress,
                    isCompleted: legacyState.isCompleted,
                    achievedAt: legacyState.achievedAt,
                    updatedAt: legacyState.updatedAt
                )
            )
        }
    }
}
