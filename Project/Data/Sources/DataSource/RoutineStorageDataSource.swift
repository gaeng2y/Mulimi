import DomainLayerInterface
import Foundation
import Utils

public protocol RoutineStorageDataSource: Sendable {
    func fetchRoutines() -> [HydrationRoutine]
    func saveRoutines(_ routines: [HydrationRoutine])
}

public final class RoutineStorageDataSourceImpl: RoutineStorageDataSource, @unchecked Sendable {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public func fetchRoutines() -> [HydrationRoutine] {
        guard let data = userDefaults.data(forKey: .hydrationRoutines) else {
            return []
        }

        do {
            return try decoder.decode([HydrationRoutine].self, from: data)
        } catch {
            return []
        }
    }

    public func saveRoutines(_ routines: [HydrationRoutine]) {
        guard let data = try? encoder.encode(routines) else {
            return
        }

        userDefaults.set(data, forKey: .hydrationRoutines)
        userDefaults.synchronize()
    }
}
