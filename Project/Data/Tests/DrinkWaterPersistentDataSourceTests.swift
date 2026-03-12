//
//  DrinkWaterPersistentDataSourceTests.swift
//  DataLayerTests
//
//  Created by Codex on 3/8/26.
//

import DataLayer
import Foundation
import Testing

@Suite("DrinkWaterPersistentDataSource Tests")
struct DrinkWaterPersistentDataSourceTests {
    @Test("기존 UserDefaults count는 1회만 SwiftData로 이관된다")
    func migrateLegacyCountOnlyOnce() async throws {
        let (userDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        userDefaults.set(3, forKey: todayLegacyKey())

        let dataSource = try DrinkWaterPersistentDataSource(
            userDefaults: userDefaults,
            isStoredInMemoryOnly: true
        )

        #expect(await dataSource.currentWater == 3)
        #expect(await dataSource.hydrationEvents(on: .now).count == 3)

        userDefaults.set(false, forKey: "hydrationMigration.swiftData.v1.completed")
        userDefaults.set(10, forKey: todayLegacyKey())
        await dataSource.migrateLegacyDataIfNeeded()

        #expect(await dataSource.currentWater == 3)
        #expect(await dataSource.hydrationEvents(on: .now).count == 3)
    }

    @Test("drinkWater는 이벤트를 저장하고 legacy count와 동기화한다")
    func drinkWaterPersistsEvents() async throws {
        let (userDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = try DrinkWaterPersistentDataSource(
            userDefaults: userDefaults,
            isStoredInMemoryOnly: true
        )

        await dataSource.drinkWater()
        await dataSource.drinkWater()

        #expect(await dataSource.currentWater == 2)
        #expect(await dataSource.hydrationEvents(on: .now).count == 2)
        #expect(userDefaults.integer(forKey: todayLegacyKey()) == 2)
    }

    @Test("reset은 오늘 이벤트를 비우고 count를 0으로 만든다")
    func resetClearsTodayEvents() async throws {
        let (userDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = try DrinkWaterPersistentDataSource(
            userDefaults: userDefaults,
            isStoredInMemoryOnly: true
        )
        await dataSource.drinkWater()
        await dataSource.drinkWater()

        await dataSource.reset()

        #expect(await dataSource.currentWater == 0)
        #expect(await dataSource.hydrationEvents(on: .now).isEmpty)
        #expect(userDefaults.integer(forKey: todayLegacyKey()) == 0)
    }

    @Test("병렬 drinkWater 호출은 actor에 의해 직렬화된다")
    func concurrentDrinkWaterIsSerialized() async throws {
        let (userDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = try DrinkWaterPersistentDataSource(
            userDefaults: userDefaults,
            isStoredInMemoryOnly: true
        )

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<10 {
                group.addTask {
                    await dataSource.drinkWater()
                }
            }
        }

        #expect(await dataSource.currentWater == 10)
        #expect(await dataSource.hydrationEvents(on: .now).count == 10)
    }

    private func makeIsolatedUserDefaults() -> (UserDefaults, String) {
        let suiteName = "DrinkWaterPersistentDataSourceTests.\(UUID().uuidString)"
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.removePersistentDomain(forName: suiteName)
        return (userDefaults, suiteName)
    }

    private func todayLegacyKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: .now)
    }
}
