//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 10/4/24.
//

import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Data",
    organizationName: "gaeng2y",
    targets: [
        .target(
            name: "Data",
            destinations: .iOS,
            product: .staticLibrary,
            bundleId: "\(bundleId).Data",
            deploymentTargets: .iOS("17.0"),
            sources: ["Sources/**"]
        )
    ]
)
