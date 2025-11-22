//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 07/19/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "DesignSystem",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber)
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DesignSystem",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: []
        )
    ]
)
