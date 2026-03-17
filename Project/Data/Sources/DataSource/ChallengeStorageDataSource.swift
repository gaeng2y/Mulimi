import DomainLayerInterface
import Foundation
import Utils

public protocol ChallengeStorageDataSource: Sendable {
    func fetchChallengeStates() -> [HydrationChallengeState]
    func saveChallengeStates(_ states: [HydrationChallengeState])
}

public final class ChallengeStorageDataSourceImpl: ChallengeStorageDataSource, @unchecked Sendable {
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
            return []
        }
    }

    public func saveChallengeStates(_ states: [HydrationChallengeState]) {
        guard let data = try? encoder.encode(states) else {
            return
        }

        userDefaults.set(data, forKey: .hydrationChallengeStates)
        userDefaults.synchronize()
    }
}
