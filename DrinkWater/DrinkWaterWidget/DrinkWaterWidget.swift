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
    private var key: String {
        let now = Date()
        let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            return df
        }()
        return dateFormatter.string(from: now)
    }
    
    func placeholder(in context: Context) -> DrinkWaterEntry {
        let entry = DrinkWaterEntry(
            date: Date(),
            glassesOfWater: Array(repeating: false, count: 8),
            configuration: ConfigurationIntent()
        )
        return entry
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (DrinkWaterEntry) -> ()) {
        let drinkwater = UserDefaults.shared.integer(forKey: key)
        print(drinkwater)
        let glassesOfWater = getGlassesOfWater(with: drinkwater)
        
        let entry = DrinkWaterEntry(
            date: Date(),
            glassesOfWater: glassesOfWater,
            configuration: ConfigurationIntent()
        )
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DrinkWaterEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!

            let drinkwater = UserDefaults.shared.integer(forKey: key)
            print(drinkwater)
            let glassesOfWater = getGlassesOfWater(with: drinkwater)
            let entry = DrinkWaterEntry(
                date: entryDate,
                glassesOfWater: glassesOfWater,
                configuration: configuration
            )
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    private func getGlassesOfWater(with drinkwater: Int) -> [Bool] {
        var arr = [Bool]()
        for _ in 0..<drinkwater {
            arr.append(true)
        }
        for _ in 0..<(8 - drinkwater) {
            arr.append(false)
        }
        return arr
    }
}

struct DrinkWaterEntry: TimelineEntry {
    let date: Date
    let glassesOfWater: [Bool]
    let configuration: ConfigurationIntent
}

struct DrinkWaterWidgetEntryView : View {
    var entry: Provider.Entry
    var drinkWater: Int {
        entry.glassesOfWater.filter { $0 }.count
    }

    var body: some View {
        ZStack {
            let name = "\(drinkWater)"
            Image(name)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(drinkWater)잔")
						.font(.title)
						.foregroundColor(.white)
						.shadow(color: .black, radius: 3)
                }
                .padding(.horizontal)
                
            }
            .padding(.init(top: 0, leading: 0, bottom: 5, trailing: 0))
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
        .supportedFamilies([.systemSmall])
    }
}

struct DrinkWaterWidget_Previews: PreviewProvider {
    static var previews: some View {
        DrinkWaterWidgetEntryView(
            entry: DrinkWaterEntry(
                date: Date(),
                glassesOfWater: [false, false, false, false, false, false, false, false],
                configuration: ConfigurationIntent()
            )
        )
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.gaeng2y.drinkwater"
        return UserDefaults(suiteName: appGroupId)!
    }
}
