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
    name: "MulimiUISystem",
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
            name: "MulimiUISystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).MulimiUISystem",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "DesignSystemFoundation", path: .relativeToRoot("Project/Shared/DesignSystemFoundation"))
            ]
        ),
        .target(
            name: "MulimiUISystemTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).MulimiUISystem.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Tests/**"],
            dependencies: [.target(name: "MulimiUISystem")]
        )
    ]
)
