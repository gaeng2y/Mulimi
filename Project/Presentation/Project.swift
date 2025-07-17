//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 10/4/24.
//

import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "PresentationLayer",
    organizationName: "gaeng2y",
    targets: [
        .target(
            name: "PresentationLayer",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).PresentationLayer",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"],
            dependencies: [
                .project(
                    target: "DomainLayerInterface",
                    path: .relativeToRoot("Project/Domain")
                ),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Utils")
                )
            ]
        ),
        .target(
            name: "PresentationLayerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).PresentationLayer.Tests",
            deploymentTargets: .iOS("18.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "PresentationLayer")
            ]
        )
    ]
)
