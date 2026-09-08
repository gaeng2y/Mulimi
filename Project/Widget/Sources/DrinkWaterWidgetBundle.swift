//
//  DrinkWaterWidgetBundle.swift
//  DrinkWaterWidget
//
//  Created by Kyeongmo Yang on 2023/06/24.
//

import WidgetKit
import SwiftUI

@main
struct DrinkWaterWidgetBundle: WidgetBundle {
    var body: some Widget {
        DrinkWaterWidget()
        DrinkWaterLockScreenWidget()
#if MULIMI_CONTROL_WIDGET_EXPERIMENT
        LogWaterControl()
#endif
    }
}

#if MULIMI_CONTROL_WIDGET_EXPERIMENT
struct LogWaterControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(kind: "gaeng2y.DrinkWater.logWater") {
            ControlWidgetButton(action: LogWaterAppIntent()) {
                Label("물 한 잔 기록", systemImage: "drop.fill")
            }
        }
        .displayName("물 한 잔 기록")
        .description("건강 앱에 물 한 잔을 기록합니다.")
    }
}
#endif
