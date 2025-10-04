import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "DomainLayer",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber)
        ]
    ),
    targets: [
        .target(
            name: "DomainLayerInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DomainLayer.Interface",
            deploymentTargets: .iOS("18.0"),
            sources: ["Interfaces/**"]
        ),
        .target(
            name: "DomainLayer",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DomainLayer",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"],
            dependencies: [
                .target(name: "DomainLayerInterface"),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                )
            ]
        ),
        .target(
            name: "DomainLayerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).DomainLayer.Tests",
            deploymentTargets: .iOS("18.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "DomainLayer")
            ]
        )
    ]
)
