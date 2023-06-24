//
//  DrinkWaterWidget.swift
//  DrinkWaterWidget
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> DrinkWaterEntry {
        DrinkWaterEntry(
            date: Date(),
            glassesOfWater: Array(repeating: false, count: 8),
            configuration: ConfigurationIntent()
        )
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DrinkWaterEntry) -> ()) {
        let entry = DrinkWaterEntry(
            date: Date(),
            glassesOfWater: Array(repeating: false, count: 8),
            configuration: configuration
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DrinkWaterEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = DrinkWaterEntry(
                date: entryDate,
                glassesOfWater: Array(repeating: false, count: 8),
                configuration: configuration
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct DrinkWaterEntry: TimelineEntry {
    let date: Date
    let glassesOfWater: [Bool]
    let configuration: ConfigurationIntent
}

struct DrinkWaterWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            ForEach(0..<entry.glassesOfWater.count) { index in
                if entry.glassesOfWater[index] {
                    Rectangle()
                        .fill(Color.blue)
                } else {
                    Rectangle()
                        .fill(Color.gray)
                }
            }
        }
    }
}

struct DrinkWaterWidget: Widget {
    let kind: String = "DrinkWaterWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DrinkWaterWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct DrinkWaterWidget_Previews: PreviewProvider {
    static var previews: some View {
        DrinkWaterWidgetEntryView(
            entry: DrinkWaterEntry(
                date: Date(),
                glassesOfWater: Array(repeating: false, count: 8),
                configuration: ConfigurationIntent()
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
