import Foundation

public protocol SyncedValueStoring: Sendable {
    func double(forKey key: String, default defaultValue: Double) -> Double
    func setDouble(_ value: Double, forKey key: String)
}

/// iCloud KVS를 원본으로, 로컬 UserDefaults를 미러로 유지하는 저장소.
/// 0 이하의 값은 "미설정"으로 간주한다(기존 iOS/Watch 목표 수분량 규칙).
public final class UbiquitousMirroredStore: SyncedValueStoring, @unchecked Sendable {
    private let userDefaults: UserDefaults?
    private let ubiquitousStore: NSUbiquitousKeyValueStore

    public init(
        userDefaults: UserDefaults?,
        ubiquitousStore: NSUbiquitousKeyValueStore = .default
    ) {
        self.userDefaults = userDefaults
        self.ubiquitousStore = ubiquitousStore
    }

    public func double(forKey key: String, default defaultValue: Double) -> Double {
        ubiquitousStore.synchronize()

        let localValue = userDefaults?.double(forKey: key) ?? 0
        let syncedValue = ubiquitousStore.double(forKey: key)

        if syncedValue > 0 {
            if localValue != syncedValue {
                userDefaults?.set(syncedValue, forKey: key)
                userDefaults?.synchronize()
            }
            return syncedValue
        }

        if localValue > 0 {
            ubiquitousStore.set(localValue, forKey: key)
            ubiquitousStore.synchronize()
            return localValue
        }

        return defaultValue
    }

    public func setDouble(_ value: Double, forKey key: String) {
        userDefaults?.set(value, forKey: key)
        userDefaults?.synchronize()
        ubiquitousStore.set(value, forKey: key)
        ubiquitousStore.synchronize()
    }
}
