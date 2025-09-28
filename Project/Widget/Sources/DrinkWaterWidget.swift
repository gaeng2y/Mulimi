//
//  DrinkWaterWidget.swift
//  DrinkWaterWidget
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import DomainLayerInterface
import SwiftUI
import WidgetKit
import Utils

// Extension to help convert UserDefaults string to MainAppearance
extension MainAppearance {
    static func from(userDefaults: UserDefaults) -> MainAppearance {
        let storedValue = userDefaults.string(forKey: "mainScreenAppearance") ?? "drop"
        
        switch storedValue {
        case "drop":
            return .drop
        case "heart":
            return .heart
        case "cloud":
            return .cloud
        default:
            return .drop
        }
    }
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DrinkWaterEntry {
        .init(
            date: .now,
            numberOfGlasses: 0,
            appearance: .drop,
            dailyLimit: 2000,
            configuration: ConfigurationAppIntent()
        )
    }
    
    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> DrinkWaterEntry {
        let userDefaults = UserDefaults.appGroup
        let appearance = MainAppearance.from(userDefaults: userDefaults)
        let dailyLimit = userDefaults.dailyLimit
        let limit = dailyLimit == 0 ? 2000 : dailyLimit
        
        return .init(
            date: .now,
            numberOfGlasses: userDefaults.glassesOfToday,
            appearance: appearance,
            dailyLimit: limit,
            configuration: ConfigurationAppIntent()
        )
    }
    
    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<DrinkWaterEntry> {
        let userDefaults = UserDefaults.appGroup
        let appearance = MainAppearance.from(userDefaults: userDefaults)
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
                appearance: appearance,
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
    let appearance: MainAppearance
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
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: entry.appearance.fillSystemImage)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.accentColor)
                
                Spacer()
                
                Button(intent: ConfigurationAppIntent()) {
                    Text(isLimitReached ? "완료!" : "마시기")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .background(isLimitReached ? Color.gray : Color.accentColor)
                .cornerRadius(10)
                .disabled(isLimitReached)
            }
            
            Spacer()
            
            HStack {
                Text("\(numberOfGlasses)잔")
                    .font(.title3)
                    .fontWeight(.heavy)
                
                Text("\(percentage)%")
                    .font(.headline)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(mililiters)ml")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("목표: \(Int(entry.dailyLimit))ml")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: progress)
                .tint(isLimitReached ? .green : .accentColor)
        }
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
        appearance: .drop,
        dailyLimit: 2000,
        configuration: .init()
    )
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 4,
        appearance: .heart,
        dailyLimit: 2000,
        configuration: .init()
    )
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 8,
        appearance: .cloud,
        dailyLimit: 2000,
        configuration: .init()
    )
}
