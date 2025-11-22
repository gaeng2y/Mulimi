//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 10/4/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Utils",
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
            name: "Utils",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(bundleId).Utils",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"]
        )
    ]
)
