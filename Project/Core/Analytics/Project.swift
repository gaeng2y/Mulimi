import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.Core.Analytics"

let project = Project(
    name: "MulimiAnalytics",
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
            name: "MulimiAnalytics",
            destinations: .iOS,
            product: .framework,
            bundleId: bundleId,
            deploymentTargets: .iOS("26.0"),
            sources: ["Domain/Sources/**"]
        ),
        .target(
            name: "MulimiAnalyticsData",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Data",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Sources/**"],
            dependencies: [
                .target(name: "MulimiAnalytics"),
                .external(name: "PostHog")
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": .string("$(inherited) -ObjC")
                ]
            )
        )
    ]
)
