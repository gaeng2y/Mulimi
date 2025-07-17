//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 10/4/24.
//

import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "DataLayer",
    organizationName: "gaeng2y",
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
                    path: .relativeToRoot("Project/Utils")
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
