//
//  DrinkWaterWidget.swift
//  DrinkWaterWidget
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

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
        VStack(alignment: .leading, spacing: 8) {
            // 상단: 현재 마신 ml (왼쪽 정렬)
            HStack(alignment: .lastTextBaseline, spacing: 2) {
                Text("\(mililiters)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.7)

                Text("ml")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }

            // 중앙 상단: 프로그레스 바
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .tint(isLimitReached ? .green : .accentColor)
                .scaleEffect(y: 1.8)

            // 중앙 하단: 잔수 / 목표 (한 줄로 표시)
            Text("\(numberOfGlasses)잔 / 목표 \(Int(entry.dailyLimit.rounded()))ml")
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)

            Spacer()

            // 하단: 마시기 버튼 (오른쪽 정렬)
            HStack {
                Spacer()

                Button(intent: ConfigurationAppIntent()) {
                    HStack(spacing: 4) {
                        Image(systemName: isLimitReached ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 13, weight: .medium))
                        Text(isLimitReached ? "완료" : "마시기")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        RoundedRectangle(cornerRadius: 7)
                            .fill(isLimitReached ? Color.green : Color.accentColor)
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(isLimitReached)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(10)
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
