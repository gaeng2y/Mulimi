//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 07/19/25.
//

import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "DesignSystem",
    organizationName: "gaeng2y",
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
