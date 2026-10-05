import DependencyInjection
import AccountDomain
import HydrationDomain
import RoutineDomain
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
        let entry = await makeEntry(date: currentDate)
        let nextDay = Calendar.current.dateInterval(of: .day, for: currentDate)?.end
            ?? currentDate.addingTimeInterval(15 * 60)
        // Never carry today's total into tomorrow while WidgetKit delays a reload.
        let expiredEntry = DrinkWaterEntry.unavailable(date: nextDay)
        return Timeline(
            entries: [entry, expiredEntry],
            policy: .after(min(currentDate.addingTimeInterval(15 * 60), nextDay))
        )
    }

    private func makeEntry(date: Date) async -> DrinkWaterEntry {
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        let mainIconSymbol = userPreferencesUseCase.getMainIcon().fillSystemImage

        do {
            let intake = try await waterUseCase.currentWaterIntakeML
            let guide = try await nextActionGuideUseCase.guide(referenceDate: date, calendar: .current)
            guard Calendar.current.isDate(date, inSameDayAs: .now) else { return .unavailable(date: date) }
            return DrinkWaterEntry(
                date: date,
                currentIntakeML: intake,
                dailyLimit: dailyLimit,
                mainIconSymbol: mainIconSymbol,
                nextActionGuide: guide
            )
        } catch {
            return .unavailable(date: date)
        }
    }
}

struct DrinkWaterEntry: TimelineEntry {
    let date: Date
    let currentIntakeML: Double
    let dailyLimit: Double
    let mainIconSymbol: String
    let nextActionGuide: HydrationNextActionGuide
    var hasReadError = false
}

extension DrinkWaterEntry {
    static func unavailable(date: Date) -> Self {
        .init(
            date: date,
            currentIntakeML: 0,
            dailyLimit: 0,
            mainIconSymbol: "exclamationmark.triangle",
            nextActionGuide: .make(currentIntakeML: 0, dailyGoalML: 0),
            hasReadError: true
        )
    }

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
