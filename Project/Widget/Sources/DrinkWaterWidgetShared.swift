import DependencyInjection
import DomainLayerInterface
import Foundation
import WidgetKit

struct DrinkWaterWidgetProvider: AppIntentTimelineProvider {
    private let waterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase

    init() {
        self.waterUseCase = DIContainer.shared.resolve(DrinkWaterUseCase.self)
        self.userPreferencesUseCase = DIContainer.shared.resolve(UserPreferencesUseCase.self)
    }

    func placeholder(in context: Context) -> DrinkWaterEntry {
        .init(
            date: .now,
            numberOfGlasses: 0,
            dailyLimit: 2000,
            mainIconSymbol: "drop.fill"
        )
    }

    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> DrinkWaterEntry {
        await makeEntry(date: .now)
    }

    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<DrinkWaterEntry> {
        let currentDate = Date()
        var entries: [DrinkWaterEntry] = []

        for hourOffset in 0..<5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) ?? currentDate
            let entry = await makeEntry(date: entryDate)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    private func makeEntry(date: Date) async -> DrinkWaterEntry {
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        let mainIconSymbol = userPreferencesUseCase.getMainIcon().fillSystemImage

        return DrinkWaterEntry(
            date: date,
            numberOfGlasses: await waterUseCase.currentWater,
            dailyLimit: dailyLimit,
            mainIconSymbol: mainIconSymbol
        )
    }
}

struct DrinkWaterEntry: TimelineEntry {
    let date: Date
    let numberOfGlasses: Int
    let dailyLimit: Double
    let mainIconSymbol: String
}

extension DrinkWaterEntry {
    var mililiters: Int {
        250 * numberOfGlasses
    }

    var progressFraction: Double {
        guard dailyLimit > 0 else {
            return 0
        }

        return min(max(Double(mililiters) / dailyLimit, 0), 1)
    }

    var percentage: Int {
        Int(progressFraction * 100.0)
    }

    var isLimitReached: Bool {
        Double(mililiters) >= dailyLimit
    }

    var dailyLimitText: String {
        Int(dailyLimit.rounded()).formatted()
    }
}
