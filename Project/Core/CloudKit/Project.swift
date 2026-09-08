import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.Core.CloudKit"

let project = Project(
    name: "MulimiCloudKit",
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
            name: "MulimiCloudKit",
            destinations: [.iPhone, .iPad, .appleWatch],
            product: .framework,
            bundleId: bundleId,
            deploymentTargets: .multiplatform(iOS: "26.0", watchOS: "26.0"),
            sources: ["Sources/**"]
        )
    ]
)
