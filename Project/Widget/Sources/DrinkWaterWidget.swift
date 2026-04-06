import SwiftUI
import Utils
import WidgetKit

struct DrinkWaterWidgetEntryView: View {
    let entry: DrinkWaterEntry

    private var accentColor: Color {
        entry.isLimitReached ? .green : .accentColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: entry.mainIconSymbol)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.accentColor)

                Spacer()

                Button(intent: LogWaterAppIntent()) {
                    HStack(spacing: 4) {
                        Image(systemName: entry.isLimitReached ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                        Text(entry.isLimitReached ? "완료" : "마시기")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(accentColor)
                    )
                }
                .buttonStyle(.plain)
                .disabled(entry.isLimitReached)
            }

            Text("\(entry.mililiters.formatted())ml")
                .font(.system(size: 25, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            Text("\(entry.numberOfGlasses)잔 / 목표 \(entry.dailyLimitText)ml")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)

            Spacer()

            ProgressView(value: entry.progressFraction)
                .progressViewStyle(.linear)
                .tint(accentColor)
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
            provider: DrinkWaterWidgetProvider()
        ) { entry in
            DrinkWaterWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("물 마시기")
        .description("홈 화면에서 오늘 마신 물의 양을 확인하고 기록하세요")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    DrinkWaterWidget()
} timeline: {
    DrinkWaterEntry(
        date: .now,
        currentIntakeML: 0,
        dailyLimit: 2000,
        mainIconSymbol: "drop.fill"
    )
    DrinkWaterEntry(
        date: .now,
        currentIntakeML: 1_000,
        dailyLimit: 2000,
        mainIconSymbol: "heart.fill"
    )
    DrinkWaterEntry(
        date: .now,
        currentIntakeML: 2_000,
        dailyLimit: 2000,
        mainIconSymbol: "cloud.fill"
    )
}
