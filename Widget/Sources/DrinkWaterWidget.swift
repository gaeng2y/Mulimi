//
//  DrinkWaterWidget.swift
//  DrinkWaterWidget
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DrinkWaterEntry {
        .init(date: .now,
              numberOfGlasses: 0,
              configuration: ConfigurationAppIntent())
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> DrinkWaterEntry {
        .init(date: .now,
              numberOfGlasses: UserDefaults.appGroup.glassesOfToday,
              configuration: ConfigurationAppIntent())
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<DrinkWaterEntry> {
        var entries: [DrinkWaterEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DrinkWaterEntry(date: entryDate,
                                        numberOfGlasses: UserDefaults.appGroup.glassesOfToday,
                                        configuration: ConfigurationAppIntent())
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
    
    var body: some View {
        ZStack {
            Image("\(numberOfGlasses)")
                .resizable()
            
            VStack {
                Spacer()
                
                HStack {
                    Button(intent: DrinkWaterIntent()) {
                        Text("마시기")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                    .background(Color.teal)
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    Text("\(numberOfGlasses)잔")
                        .font(.title)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 3)
                }
            }
        }
    }
}

struct DrinkWaterWidget: Widget {
    let kind: String = .widgetKind
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
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
