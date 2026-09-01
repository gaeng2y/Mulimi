import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.WatchHydration"

let project = Project(
    name: "WatchHydration",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber),
            "SWIFT_VERSION": .string("6.0")
        ],
        configurations: [.debug(name: "Debug"), .release(name: "Release")]
    ),
    targets: [
        .target(
            name: "WatchHydrationDomain",
            destinations: [.appleWatch],
            product: .framework,
            bundleId: "\(bundleId).Domain",
            deploymentTargets: .watchOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Domain/Sources/**"),
                .relativeToRoot("Project/Features/Hydration/Domain/Sources/Entity/HydrationNextActionGuide.swift"),
                .relativeToRoot("Project/Features/Hydration/Domain/Sources/Entity/HydrationServing.swift"),
                .relativeToRoot("Project/Features/Hydration/Domain/Sources/Entity/HydrationWriteResult.swift")
            ])
        ),
        .target(
            name: "WatchHydrationData",
            destinations: [.appleWatch],
            product: .framework,
            bundleId: "\(bundleId).Data",
            deploymentTargets: .watchOS("26.0"),
            sources: ["Data/Sources/**"],
            dependencies: [
                .target(name: "WatchHydrationDomain"),
                .project(target: "MulimiCloudKit", path: .relativeToRoot("Project/Core/CloudKit"))
            ]
        ),
        .target(
            name: "WatchHydrationPresentation",
            destinations: [.appleWatch],
            product: .framework,
            bundleId: "\(bundleId).Presentation",
            deploymentTargets: .watchOS("26.0"),
            sources: ["Presentation/Sources/**"],
            dependencies: [.target(name: "WatchHydrationDomain")]
        )
    ]
)
