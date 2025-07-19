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
                .external(name: "Swinject"),
                .project(
                    target: "WidgetExtension",
                    path: .relativeToRoot("Project/Widget")
                ),
                .project(
                    target: "DataLayer",
                    path: .relativeToRoot("Project/Data")
                ),
                .project(
                    target: "DomainLayer",
                    path: .relativeToRoot("Project/Domain")
                ),
                .project(
                    target: "PresentationLayer",
                    path: .relativeToRoot("Project/Presentation")
                ),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                ),
            ]
        )
    ]
)
