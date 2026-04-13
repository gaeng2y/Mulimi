import DependencyInjection
import DomainLayerInterface
import Foundation
import WidgetKit

struct DrinkWaterWidgetProvider: AppIntentTimelineProvider {
    private let waterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    private let nextActionGuideUseCase: HydrationNextActionGuideUseCase

    init() {
        self.waterUseCase = DIContainer.shared.resolve(DrinkWaterUseCase.self)
        self.userPreferencesUseCase = DIContainer.shared.resolve(UserPreferencesUseCase.self)
        self.nextActionGuideUseCase = DIContainer.shared.resolve(HydrationNextActionGuideUseCase.self)
    }

    func placeholder(in context: Context) -> DrinkWaterEntry {
        .init(
            date: .now,
            currentIntakeML: 0,
            dailyLimit: 2000,
            mainIconSymbol: "drop.fill",
            nextActionGuide: HydrationNextActionGuide.make(
                currentIntakeML: 0,
                dailyGoalML: 2_000
            )
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
            currentIntakeML: await waterUseCase.currentWaterIntakeML,
            dailyLimit: dailyLimit,
            mainIconSymbol: mainIconSymbol,
            nextActionGuide: await nextActionGuideUseCase.guide(
                referenceDate: date,
                calendar: .current
            )
        )
    }
}

struct DrinkWaterEntry: TimelineEntry {
    let date: Date
    let currentIntakeML: Double
    let dailyLimit: Double
    let mainIconSymbol: String
    let nextActionGuide: HydrationNextActionGuide
}

extension DrinkWaterEntry {
    var mililiters: Int {
        Int(currentIntakeML.rounded())
    }

    var numberOfGlasses: Int {
        HydrationServing.glassCount(for: currentIntakeML)
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

    var nextActionSummaryText: String {
        switch nextActionGuide.state {
        case .goalReached:
            return "오늘 목표 달성"
        case .needsGoal:
            return "목표를 먼저 설정하세요"
        case .readyToDrink:
            return "\(nextActionGuide.remainingGlassCount)잔 남음"
        case .approachingRoutine:
            guard let nextRoutine = nextActionGuide.nextRoutine else {
                return "\(nextActionGuide.remainingGlassCount)잔 남음"
            }

            return "루틴 \(relativeTimeText(for: nextRoutine.minutesUntil)) 전 · \(nextActionGuide.remainingGlassCount)잔 남음"
        }
    }

    private func relativeTimeText(for minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)분"
        }

        let hours = minutes / 60
        let remainingMinutes = minutes % 60

        guard remainingMinutes > 0 else {
            return "\(hours)시간"
        }

        return "\(hours)시간 \(remainingMinutes)분"
    }
}
