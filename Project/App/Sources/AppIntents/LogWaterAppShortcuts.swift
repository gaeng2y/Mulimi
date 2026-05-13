//
//  LogWaterAppShortcuts.swift
//  Mulimi App
//
//  Created by Codex on 5/13/26.
//

import AppIntents

struct LogWaterAppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: LogWaterAppIntent(),
            phrases: [
                "\(.applicationName)에서 물 기록",
                "\(.applicationName)로 물 마시기",
                "\(.applicationName) 물 마셔",
                "\(.applicationName) 수분 기록"
            ],
            shortTitle: "물 기록",
            systemImageName: "drop.fill"
        )
    }

    static var shortcutTileColor: ShortcutTileColor {
        .blue
    }
}
