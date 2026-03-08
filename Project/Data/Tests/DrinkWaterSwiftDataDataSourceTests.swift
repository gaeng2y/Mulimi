//
//  DrinkWaterSwiftDataDataSourceTests.swift
//  DataLayerTests
//
//  Created by Codex on 3/8/26.
//

import DataLayer
import Foundation
import Testing

@Suite("DrinkWaterSwiftDataDataSource Tests")
struct DrinkWaterSwiftDataDataSourceTests {
    @Test("기존 UserDefaults count는 1회만 SwiftData로 이관된다")
    func migrateLegacyCountOnlyOnce() throws {
        let (userDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        userDefaults.set(3, forKey: todayLegacyKey())

        let dataSource = try DrinkWaterSwiftDataDataSource(
            userDefaults: userDefaults,
            isStoredInMemoryOnly: true
        )

        #expect(dataSource.currentWater == 3)
        #expect(dataSource.hydrationEvents(on: .now).count == 3)

        userDefaults.set(false, forKey: "hydrationMigration.swiftData.v1.completed")
        userDefaults.set(10, forKey: todayLegacyKey())
        dataSource.migrateLegacyDataIfNeeded()

        #expect(dataSource.currentWater == 3)
        #expect(dataSource.hydrationEvents(on: .now).count == 3)
    }

    @Test("drinkWater는 이벤트를 저장하고 legacy count와 동기화한다")
    func drinkWaterPersistsEvents() throws {
        let (userDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = try DrinkWaterSwiftDataDataSource(
            userDefaults: userDefaults,
            isStoredInMemoryOnly: true
        )

        dataSource.drinkWater()
        dataSource.drinkWater()

        #expect(dataSource.currentWater == 2)
        #expect(dataSource.hydrationEvents(on: .now).count == 2)
        #expect(userDefaults.integer(forKey: todayLegacyKey()) == 2)
    }

    @Test("reset은 오늘 이벤트를 비우고 count를 0으로 만든다")
    func resetClearsTodayEvents() throws {
        let (userDefaults, suiteName) = makeIsolatedUserDefaults()
        defer { userDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = try DrinkWaterSwiftDataDataSource(
            userDefaults: userDefaults,
            isStoredInMemoryOnly: true
        )
        dataSource.drinkWater()
        dataSource.drinkWater()

        dataSource.reset()

        #expect(dataSource.currentWater == 0)
        #expect(dataSource.hydrationEvents(on: .now).isEmpty)
        #expect(userDefaults.integer(forKey: todayLegacyKey()) == 0)
    }

    private func makeIsolatedUserDefaults() -> (UserDefaults, String) {
        let suiteName = "DrinkWaterSwiftDataDataSourceTests.\(UUID().uuidString)"
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
