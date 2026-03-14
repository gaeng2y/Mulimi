//
//  DrinkWaterPersistentDataSourceTests.swift
//  DataLayerTests
//
//  Created by Codex on 3/8/26.
//

import DataLayer
import Foundation
import Persistence
import SwiftData
import Testing

@Suite("DrinkWaterPersistentDataSource Tests")
struct DrinkWaterPersistentDataSourceTests {
    @Test("기존 UserDefaults count는 1회만 SwiftData로 이관된다")
    func migrateLegacyCountOnlyOnce() async throws {
        let suiteName = makeIsolatedSuiteName()
        let setupUserDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { setupUserDefaults.removePersistentDomain(forName: suiteName) }

        setupUserDefaults.set(3, forKey: todayLegacyKey())

        let dataSource = try DrinkWaterPersistentDataSource(
            userDefaults: makeIsolatedUserDefaults(suiteName: suiteName),
            isStoredInMemoryOnly: true
        )

        #expect(await dataSource.currentWater == 3)
        #expect(await dataSource.hydrationEvents(on: .now).count == 3)

        let verificationUserDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        verificationUserDefaults.set(false, forKey: "hydrationMigration.swiftData.v1.completed")
        verificationUserDefaults.set(10, forKey: todayLegacyKey())
        await dataSource.migrateLegacyDataIfNeeded()

        #expect(await dataSource.currentWater == 3)
        #expect(await dataSource.hydrationEvents(on: .now).count == 3)
    }

    @Test("drinkWater는 이벤트를 저장하고 legacy count와 동기화한다")
    func drinkWaterPersistsEvents() async throws {
        let suiteName = makeIsolatedSuiteName()
        let setupUserDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { setupUserDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = try DrinkWaterPersistentDataSource(
            userDefaults: makeIsolatedUserDefaults(suiteName: suiteName),
            isStoredInMemoryOnly: true
        )

        await dataSource.drinkWater()
        await dataSource.drinkWater()

        #expect(await dataSource.currentWater == 2)
        #expect(await dataSource.hydrationEvents(on: .now).count == 2)
        let verificationUserDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        verificationUserDefaults.synchronize()
        #expect(verificationUserDefaults.integer(forKey: todayLegacyKey()) == 2)
    }

    @Test("reset은 오늘 이벤트를 비우고 count를 0으로 만든다")
    func resetClearsTodayEvents() async throws {
        let suiteName = makeIsolatedSuiteName()
        let setupUserDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { setupUserDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = try DrinkWaterPersistentDataSource(
            userDefaults: makeIsolatedUserDefaults(suiteName: suiteName),
            isStoredInMemoryOnly: true
        )
        await dataSource.drinkWater()
        await dataSource.drinkWater()

        await dataSource.reset()

        #expect(await dataSource.currentWater == 0)
        #expect(await dataSource.hydrationEvents(on: .now).isEmpty)
        let verificationUserDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        verificationUserDefaults.synchronize()
        #expect(verificationUserDefaults.integer(forKey: todayLegacyKey()) == 0)
    }

    @Test("병렬 drinkWater 호출은 actor에 의해 직렬화된다")
    func concurrentDrinkWaterIsSerialized() async throws {
        let suiteName = makeIsolatedSuiteName()
        let setupUserDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { setupUserDefaults.removePersistentDomain(forName: suiteName) }

        let dataSource = try DrinkWaterPersistentDataSource(
            userDefaults: makeIsolatedUserDefaults(suiteName: suiteName),
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

    @Test("hydrationEvents(in:)은 지정한 기간의 이벤트만 반환한다")
    func hydrationEventsInInterval() async throws {
        let suiteName = makeIsolatedSuiteName()
        let setupUserDefaults = makeIsolatedUserDefaults(suiteName: suiteName)
        defer { setupUserDefaults.removePersistentDomain(forName: suiteName) }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let modelContainer = try SharedHydrationStore.makeModelContainer(isStoredInMemoryOnly: true)
        let context = ModelContext(modelContainer)
        let firstDay = calendar.date(from: DateComponents(year: 2026, month: 3, day: 10, hour: 8))!
        let secondDay = calendar.date(byAdding: .day, value: 1, to: firstDay)!
        let thirdDay = calendar.date(byAdding: .day, value: 2, to: firstDay)!

        context.insert(HydrationEventModel(consumedAt: firstDay, volumeML: 250))
        context.insert(HydrationEventModel(consumedAt: secondDay, volumeML: 500))
        context.insert(HydrationEventModel(consumedAt: thirdDay, volumeML: 750))
        try context.save()

        let dataSource = DrinkWaterPersistentDataSource(
            modelContainer: modelContainer,
            userDefaults: makeIsolatedUserDefaults(suiteName: suiteName),
            calendar: calendar
        )

        let interval = DateInterval(
            start: calendar.startOfDay(for: secondDay),
            end: calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: thirdDay))!
        )
        let events = await dataSource.hydrationEvents(in: interval)

        #expect(events.count == 2)
        #expect(events.map(\.volumeML) == [500, 750])
    }

    private func makeIsolatedSuiteName() -> String {
        "DrinkWaterPersistentDataSourceTests.\(UUID().uuidString)"
    }

    private func makeIsolatedUserDefaults(suiteName: String) -> UserDefaults {
        let userDefaults = UserDefaults(suiteName: suiteName)!
        userDefaults.synchronize()
        return userDefaults
    }

    private func todayLegacyKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: .now)
    }
}
