import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "DomainLayer",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber),
            "SWIFT_VERSION": .string("6.0")
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .target(
            name: "DomainLayerInterface",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DomainLayer.Interface",
            deploymentTargets: .iOS("26.0"),
            sources: ["Interfaces/**"]
        ),
        .target(
            name: "DomainLayer",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DomainLayer",
            deploymentTargets: .iOS("26.0"),
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
            name: "WatchDomainLayerInterface",
            destinations: [.appleWatch],
            product: .framework,
            bundleId: "\(bundleId).WatchDomainLayer.Interface",
            deploymentTargets: .watchOS("26.0"),
            sources: ["WatchInterfaces/**"]
        ),
        .target(
            name: "WatchDomainLayer",
            destinations: [.appleWatch],
            product: .framework,
            bundleId: "\(bundleId).WatchDomainLayer",
            deploymentTargets: .watchOS("26.0"),
            sources: ["WatchSources/**"],
            dependencies: [
                .target(name: "WatchDomainLayerInterface")
            ]
        ),
        .target(
            name: "DomainLayerTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).DomainLayer.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "DomainLayer")
            ]
        )
    ]
)
