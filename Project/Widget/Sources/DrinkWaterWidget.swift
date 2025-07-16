//
//  DrinkWaterWidget.swift
//  DrinkWaterWidget
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import WidgetKit
import SwiftUI
import Utils

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DrinkWaterEntry {
        .init(date: .now,
              numberOfGlasses: 0,
              configuration: ConfigurationAppIntent())
    }
    
    func snapshot(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> DrinkWaterEntry {
        .init(date: .now,
              numberOfGlasses: UserDefaults.appGroup.glassesOfToday,
              configuration: ConfigurationAppIntent())
    }
    
    func timeline(
        for configuration: ConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<DrinkWaterEntry> {
        var entries: [DrinkWaterEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DrinkWaterEntry(
                date: entryDate,
                numberOfGlasses: UserDefaults.appGroup.glassesOfToday,
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
        CGFloat(mililiters) / 2000.0
    }
    private var percentage: Int {
        Int(progress * 100.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Image(systemName: "drop.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.accentColor)
                
                Spacer()
                
                Button(intent: ConfigurationAppIntent()) {
                    Text("마시기")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .background(Color.accentColor)
                .cornerRadius(10)
            }
            
            Spacer()
            
            HStack {
                Text("\(numberOfGlasses)잔")
                    .font(.title3)
                    .fontWeight(.heavy)
                
                Text("\(percentage)%")
                    .font(.headline)
            }
            
            Text("\(mililiters)ml")
                .font(.subheadline)
                .fontWeight(.semibold)
            
            ProgressView(value: progress)
                .tint(.accentColor)
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
    DrinkWaterEntry(date: .now, numberOfGlasses: 0, configuration: .init())
    DrinkWaterEntry(date: .now, numberOfGlasses: 4, configuration: .init())
    DrinkWaterEntry(date: .now, numberOfGlasses: 8, configuration: .init())
}
