import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.Core"

let project = Project(
    name: "Core",
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
            name: "CoreDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Domain",
            deploymentTargets: .iOS("26.0"),
            sources: ["Domain/Sources/**"]
        ),
        .target(
            name: "CorePresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Presentation",
            deploymentTargets: .iOS("26.0"),
            sources: ["Presentation/Sources/**"],
            dependencies: [
                .target(name: "CoreDomain"),
                .project(
                    target: "AccountDomain",
                    path: .relativeToRoot("Project/Features/Account")
                ),
                .project(
                    target: "Localization",
                    path: .relativeToRoot("Project/Shared/Localization")
                )
            ]
        ),
        .target(
            name: "CorePresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Presentation.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Presentation/Tests/**"],
            dependencies: [.target(name: "CorePresentation")]
        )
    ]
)
