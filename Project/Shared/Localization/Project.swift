import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Localization",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber),
            "DEVELOPMENT_LANGUAGE": .string("ko"),
            "SWIFT_VERSION": .string("6.0")
        ],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        .target(
            name: "Localization",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Localization",
            deploymentTargets: .iOS("18.0"),
            sources: ["Sources/**"],
            resources: ["Resources/**"]
        )
    ]
)
