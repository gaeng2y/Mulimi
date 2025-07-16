//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 10/4/24.
//

import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Presentation",
    organizationName: "gaeng2y",
    targets: [
        .target(
            name: "Presentation",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(bundleId).Presentation",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"]
        )
    ]
)
