import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.HydrationReminder"

let project = Project(
    name: "HydrationReminder",
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
            name: "HydrationReminderDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Domain",
            deploymentTargets: .iOS("26.0"),
            sources: ["Domain/Sources/**"]
        ),
        .target(
            name: "HydrationReminderData",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Data",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Sources/**"],
            dependencies: [
                .target(name: "HydrationReminderDomain"),
                .project(
                    target: "Localization",
                    path: .relativeToRoot("Project/Shared/Localization")
                ),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                )
            ]
        ),
        .target(
            name: "HydrationReminderPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Presentation",
            deploymentTargets: .iOS("26.0"),
            sources: ["Presentation/Sources/**"],
            dependencies: [
                .target(name: "HydrationReminderDomain"),
                .project(
                    target: "CoreDomain",
                    path: .relativeToRoot("Project/Core")
                ),
                .project(
                    target: "Localization",
                    path: .relativeToRoot("Project/Shared/Localization")
                )
            ]
        ),
        .target(
            name: "HydrationReminderDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Domain.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Domain/Tests/**"],
            dependencies: [
                .target(name: "HydrationReminderDomain")
            ]
        ),
        .target(
            name: "HydrationReminderDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Data.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Tests/**"],
            dependencies: [
                .target(name: "HydrationReminderData"),
                .target(name: "HydrationReminderDomain")
            ]
        ),
        .target(
            name: "HydrationReminderPresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Presentation.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Presentation/Tests/**"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockAnalyticsUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockHydrationReminderUseCase.swift")
            ]),
            dependencies: [
                .target(name: "HydrationReminderPresentation"),
                .target(name: "HydrationReminderDomain"),
                .project(
                    target: "CoreDomain",
                    path: .relativeToRoot("Project/Core")
                ),
                .project(
                    target: "Localization",
                    path: .relativeToRoot("Project/Shared/Localization")
                )
            ]
        )
    ]
)
