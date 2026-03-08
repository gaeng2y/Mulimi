//
//  Project.swift
//  Persistence
//
//  Created by Codex on 3/8/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Persistence",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber),
            "SWIFT_VERSION": .string("6.0")
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .target(
            name: "Persistence",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Persistence",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"]
        )
    ]
)
