//
//  Project.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "DependencyInjection",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber)
        ]
    ),
    targets: [
        // Production DI
        .target(
            name: "DependencyInjection",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DependencyInjection",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Production/**", "Sources/Core/**"],
            dependencies: [
                .external(name: "Swinject"),
                .project(
                    target: "DataLayer",
                    path: .relativeToRoot("Project/Data")
                ),
                .project(
                    target: "DomainLayerInterface",
                    path: .relativeToRoot("Project/Domain")
                ),
                .project(
                    target: "DomainLayer",
                    path: .relativeToRoot("Project/Domain")
                ),
                .project(
                    target: "PresentationLayer",
                    path: .relativeToRoot("Project/Presentation")
                )
            ]
        ),

        // Preview Support
        .target(
            name: "DependencyInjectionPreview",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DependencyInjection.Preview",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Preview/**", "Sources/Core/**"],
            dependencies: [
                .target(name: "DependencyInjection"),
                .external(name: "Swinject"),
                .project(
                    target: "DomainLayerInterface",
                    path: .relativeToRoot("Project/Domain")
                ),
                .project(
                    target: "PresentationLayer",
                    path: .relativeToRoot("Project/Presentation")
                )
            ]
        ),

        // Testing Support
        .target(
            name: "DependencyInjectionTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DependencyInjection.Testing",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/Testing/**", "Sources/Core/**"],
            dependencies: [
                .target(name: "DependencyInjection"),
                .external(name: "Swinject"),
                .project(
                    target: "DomainLayerInterface",
                    path: .relativeToRoot("Project/Domain")
                )
            ]
        )
    ]
)
