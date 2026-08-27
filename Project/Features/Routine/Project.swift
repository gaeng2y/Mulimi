import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.Routine"

let project = Project(
    name: "Routine",
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
            name: "RoutineDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Domain",
            deploymentTargets: .iOS("26.0"),
            sources: ["Domain/Sources/**"],
            dependencies: [
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration"))
            ]
        ),
        .target(
            name: "RoutineData",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Data",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Sources/**"],
            dependencies: [
                .target(name: "RoutineDomain"),
                .project(target: "Localization", path: .relativeToRoot("Project/Shared/Localization")),
                .project(target: "Utils", path: .relativeToRoot("Project/Shared/Utils"))
            ]
        ),
        .target(
            name: "RoutinePresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Presentation",
            deploymentTargets: .iOS("26.0"),
            sources: ["Presentation/Sources/**"],
            dependencies: [
                .target(name: "RoutineDomain"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "CoreDomain", path: .relativeToRoot("Project/Features/Core")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Features/Core")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "Localization", path: .relativeToRoot("Project/Shared/Localization"))
            ]
        ),
        .target(
            name: "RoutineDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Domain.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Domain/Tests/**"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockDrinkWaterRepository.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockRoutineRepository.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockUserPreferencesRepository.swift")
            ]),
            dependencies: [
                .target(name: "RoutineDomain"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration"))
            ]
        ),
        .target(
            name: "RoutineDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Data.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Tests/**"],
            dependencies: [.target(name: "RoutineData"), .target(name: "RoutineDomain")]
        ),
        .target(
            name: "RoutinePresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Presentation.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Presentation/Tests/**"],
            dependencies: [
                .target(name: "RoutinePresentation"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "CoreDomain", path: .relativeToRoot("Project/Features/Core")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Features/Core")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "Localization", path: .relativeToRoot("Project/Shared/Localization"))
            ]
        )
    ]
)
