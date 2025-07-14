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
    targets: [
        .target(
            name: "Mulimi",
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS("17.0"),
            infoPlist: .file(path: .path("Resources/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(
                path: .relativeToRoot("Supporting Files/Mulimi.entitlements")
            ),
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .project(
                    target: "WidgetExtension",
                    path: .relativeToRoot("Project/Widget")
                ),
                .project(
                    target: "Data",
                    path: .relativeToRoot("Project/Data")
                ),
                .project(
                    target: "Domain",
                    path: .relativeToRoot("Project/Domain")
                ),
                .project(
                    target: "Presentation",
                    path: .relativeToRoot("Project/Presentation")
                ),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Utils")
                ),
            ]
        )
    ]
)
