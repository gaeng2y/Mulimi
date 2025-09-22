//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 10/4/24.
//

import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Mulimi App",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [:],
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("XCConfig/Debug.xcconfig")),
            .release(name: "Release", xcconfig: .relativeToRoot("XCConfig/Release.xcconfig"))
        ]
    ),
    targets: [
        .target(
            name: "Mulimi",
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS("18.0"),
            infoPlist: .file(path: .path("Supports/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(
                path: .relativeToCurrentFile("Supports/Mulimi.entitlements")
            ),
            dependencies: [
                .target(name: "WidgetExtension"),
                .project(
                    target: "DependencyInjection",
                    path: .relativeToRoot("Project/Shared/DependencyInjection")
                ),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                ),
            ]
        ),
        .target(
            name: "WidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(bundleId).WidgetExtension",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .file(path: .relativeToRoot("Project/Widget/Resources/Info.plist")),
            sources: .paths([.relativeToRoot("Project/Widget/Sources/**")]),
            resources: .resources([.glob(pattern: .relativeToRoot("Project/Widget/Resources/Assets.xcassets"))]),
            entitlements: .file(
                path: .relativeToRoot("Supporting Files/WidgetExtension.entitlements")
            ),
            dependencies: [
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                )
            ]
        )
    ]
)
