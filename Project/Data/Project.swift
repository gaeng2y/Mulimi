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
    name: "DataLayer",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber)
        ]
    ),
    targets: [
        .target(
            name: "DataLayer",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DataLayer",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(
                    target: "DomainLayerInterface",
                    path: .relativeToRoot("Project/Domain")
                ),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                )
            ]
        ),
        .target(
            name: "DataLayerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).DataLayer.Tests",
            deploymentTargets: .iOS("18.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "DataLayer")
            ]
        )
    ]
)
