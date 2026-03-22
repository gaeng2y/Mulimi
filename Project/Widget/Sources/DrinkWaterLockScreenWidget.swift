import SwiftUI
import WidgetKit

struct DrinkWaterLockScreenWidgetEntryView: View {
    @Environment(\.widgetFamily) private var widgetFamily
    
    let entry: DrinkWaterEntry
    
    private var accentColor: Color {
        entry.isLimitReached ? .green : .accentColor
    }
    
    var body: some View {
        switch widgetFamily {
        case .accessoryInline:
            inlineView
        case .accessoryCircular:
            circularView
        case .accessoryRectangular:
            rectangularView
        default:
            rectangularView
        }
    }
    
    private var inlineView: some View {
        Label("\(entry.mililiters.formatted())ml", systemImage: entry.mainAppearanceIcon)
    }
    
    private var circularView: some View {
        Gauge(value: entry.progressFraction) {
            EmptyView()
        } currentValueLabel: {
            VStack(spacing: 0) {
                Text("\(entry.mililiters)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .minimumScaleFactor(0.6)
                
                Text("ml")
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(accentColor)
    }
    
    private var rectangularView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: entry.mainAppearanceIcon)
                    .foregroundStyle(accentColor)
                
                Text("오늘 수분")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Spacer(minLength: 4)
                
                Text("\(entry.percentage)%")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(accentColor)
            }
            
            Text("\(entry.mililiters.formatted())ml")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.7)
            
            Text("\(entry.numberOfGlasses)잔 · 목표 \(entry.dailyLimitText)ml")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }
}

struct DrinkWaterLockScreenWidget: Widget {
    private let kind = "MulimeeLockScreenWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: DrinkWaterWidgetProvider()
        ) { entry in
            DrinkWaterLockScreenWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("잠금화면 물 마시기")
        .description("잠금화면에서 오늘 마신 물의 양을 빠르게 확인하세요")
        .supportedFamilies([.accessoryInline, .accessoryCircular, .accessoryRectangular])
    }
}

#Preview(as: .accessoryRectangular) {
    DrinkWaterLockScreenWidget()
} timeline: {
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 5,
        dailyLimit: 2000,
        mainAppearanceIcon: "drop.fill"
    )
}

#Preview(as: .accessoryCircular) {
    DrinkWaterLockScreenWidget()
} timeline: {
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 6,
        dailyLimit: 2000,
        mainAppearanceIcon: "heart.fill"
    )
}

#Preview(as: .accessoryInline) {
    DrinkWaterLockScreenWidget()
} timeline: {
    DrinkWaterEntry(
        date: .now,
        numberOfGlasses: 3,
        dailyLimit: 2000,
        mainAppearanceIcon: "cloud.fill"
    )
}
