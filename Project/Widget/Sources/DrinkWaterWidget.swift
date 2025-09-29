//
//  DrinkWaterWidget.swift
//  DrinkWaterWidget
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import Foundation
import SwiftUI
import Utils
import WidgetKit

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DrinkWaterEntry {
        .init(
            date: .now,
            numberOfGlasses: 0,
            dailyLimit: 2000,
            configuration: ConfigurationAppIntent()
        )
    }
    
    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> DrinkWaterEntry {
        let userDefaults = UserDefaults.appGroup
        let dailyLimit = userDefaults.dailyLimit
        let limit = dailyLimit == 0 ? 2000 : dailyLimit
        
        return .init(
            date: .now,
            numberOfGlasses: userDefaults.glassesOfToday,
            dailyLimit: limit,
            configuration: ConfigurationAppIntent()
        )
    }
    
    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<DrinkWaterEntry> {
        let userDefaults = UserDefaults.appGroup
        let dailyLimit = userDefaults.dailyLimit
        let limit = dailyLimit == 0 ? 2000 : dailyLimit
        
        var entries: [DrinkWaterEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DrinkWaterEntry(
                date: entryDate,
                numberOfGlasses: userDefaults.glassesOfToday,
                dailyLimit: limit,
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
        VStack(spacing: 8) {
            // 상단: 메인 수치 (HIG - 주요 정보 우선 표시)
            VStack(spacing: 2) {
                Text("\(mililiters)")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
                
                Text("ml")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            // 중앙: 프로그레스 표시 (HIG - 시각적 진행도)
            VStack(spacing: 6) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .tint(isLimitReached ? .green : .accentColor)
                    .scaleEffect(y: 1.5)
                
                Text("\(numberOfGlasses)잔 / \(Int(entry.dailyLimit))ml 목표")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }
            
            // 하단: 액션 버튼 (HIG - 단순한 인터랙션)
            Button(intent: ConfigurationAppIntent()) {
                Label {
                    Text(isLimitReached ? "완료" : "마시기")
                        .font(.system(size: 12, weight: .semibold))
                } icon: {
                    Image(systemName: isLimitReached ? "checkmark.circle.fill" : "plus.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(isLimitReached ? .green : .accentColor)
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isLimitReached)
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
        configuration: .init()
    )
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 4,
        dailyLimit: 2000,
        configuration: .init()
    )
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 8,
        dailyLimit: 2000,
        configuration: .init()
    )
}
