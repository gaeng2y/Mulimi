//
//  DrinkWaterWidget.swift
//  DrinkWaterWidget
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import SwiftUI
import Utils
import WidgetKit
import DependencyInjection
import DomainLayerInterface

struct Provider: AppIntentTimelineProvider {
    private let waterUseCase: DrinkWaterUseCase
    private let userPreferencesUseCase: UserPreferencesUseCase
    
    init() {
        self.waterUseCase = DIContainer.shared.resolve(DrinkWaterUseCase.self)
        self.userPreferencesUseCase = DIContainer.shared.resolve(UserPreferencesUseCase.self)
        waterUseCase.migrateLegacyDataIfNeeded()
    }
    
    func placeholder(in context: Context) -> DrinkWaterEntry {
        .init(
            date: .now,
            numberOfGlasses: 0,
            dailyLimit: 2000,
            mainAppearanceIcon: "drop.fill",
            configuration: ConfigurationAppIntent()
        )
    }
    
    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> DrinkWaterEntry {
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        let mainAppearance = userPreferencesUseCase.getMainAppearance()
        let appearanceIcon = mainAppearance.systemImage
        
        return .init(
            date: .now,
            numberOfGlasses: waterUseCase.currentWater,
            dailyLimit: dailyLimit,
            mainAppearanceIcon: appearanceIcon,
            configuration: ConfigurationAppIntent()
        )
    }
    
    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<DrinkWaterEntry> {
        let dailyLimit = userPreferencesUseCase.getDailyWaterLimit()
        let mainAppearance = userPreferencesUseCase.getMainAppearance()
        let appearanceIcon = mainAppearance.systemImage
        let currentCount = waterUseCase.currentWater
        
        var entries: [DrinkWaterEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DrinkWaterEntry(
                date: entryDate,
                numberOfGlasses: currentCount,
                dailyLimit: dailyLimit,
                mainAppearanceIcon: appearanceIcon,
                configuration: ConfigurationAppIntent()
            )
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct DrinkWaterEntry: TimelineEntry {
    let date: Date
    let numberOfGlasses: Int
    let dailyLimit: Double
    let mainAppearanceIcon: String
    let configuration: ConfigurationAppIntent
}

struct DrinkWaterWidgetEntryView : View {
    var entry: Provider.Entry
    
    private var numberOfGlasses: Int {
        entry.numberOfGlasses
    }
    
    private var mililiters: Int {
        250 * numberOfGlasses
    }
    
    private var progress: CGFloat {
        CGFloat(mililiters) / entry.dailyLimit
    }
    
    private var percentage: Int {
        Int(progress * 100.0)
    }
    
    private var isLimitReached: Bool {
        Double(mililiters) >= entry.dailyLimit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 상단: MainAppearance 아이콘 (좌) + 마시기 버튼 (우)
            HStack {
                Image(systemName: entry.mainAppearanceIcon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                Button(intent: ConfigurationAppIntent()) {
                    HStack(spacing: 4) {
                        Image(systemName: isLimitReached ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                        Text(isLimitReached ? "완료" : "마시기")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(isLimitReached ? Color.green : Color.accentColor)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isLimitReached)
            }
            
            // 마신 ml (큰 글씨)
            Text("\(mililiters.formatted())ml")
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            // 잔수 / 목표
            Text("\(numberOfGlasses)잔 / 목표 \(Int(entry.dailyLimit.rounded()))ml")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
            
            Spacer()
            
            // 하단: 프로그레스 바
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(isLimitReached ? .green : .accentColor)
                .scaleEffect(y: 1.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(12)
    }
}

struct DrinkWaterWidget: Widget {
    let kind: String = .widgetKind
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()
        ) { entry in
            DrinkWaterWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("물 마시기")
        .description("오늘 마신 물의 양을 확인하고 기록하세요")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    DrinkWaterWidget()
} timeline: {
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 0,
        dailyLimit: 2000,
        mainAppearanceIcon: "drop.fill",
        configuration: .init()
    )
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 4,
        dailyLimit: 2000,
        mainAppearanceIcon: "heart.fill",
        configuration: .init()
    )
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 8,
        dailyLimit: 2000,
        mainAppearanceIcon: "cloud.fill",
        configuration: .init()
    )
}
