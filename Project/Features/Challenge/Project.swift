import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.Challenge"

let project = Project(
    name: "Challenge",
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
            name: "ChallengeDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Domain",
            deploymentTargets: .iOS("26.0"),
            sources: ["Domain/Sources/**"],
            dependencies: [
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine"))
            ]
        ),
        .target(
            name: "ChallengeData",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Data",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Sources/**"],
            dependencies: [
                .target(name: "ChallengeDomain"),
                .project(target: "Utils", path: .relativeToRoot("Project/Shared/Utils"))
            ]
        ),
        .target(
            name: "ChallengePresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Presentation",
            deploymentTargets: .iOS("26.0"),
            sources: ["Presentation/Sources/**"],
            dependencies: [
                .target(name: "ChallengeDomain"),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Core")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine")),
                .project(target: "RoutinePresentation", path: .relativeToRoot("Project/Features/Routine")),
                .project(target: "DesignSystem", path: .relativeToRoot("Project/Shared/DesignSystem")),
                .project(target: "Localization", path: .relativeToRoot("Project/Shared/Localization"))
            ]
        ),
        .target(
            name: "ChallengeDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Domain.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Domain/Tests/**"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockChallengeRepository.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockDrinkWaterRepository.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockHydrationProgressUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockRoutineRepository.swift")
            ]),
            dependencies: [
                .target(name: "ChallengeDomain"),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine"))
            ]
        ),
        .target(
            name: "ChallengeDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Data.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Tests/**"],
            dependencies: [.target(name: "ChallengeData"), .target(name: "ChallengeDomain")]
        ),
        .target(
            name: "ChallengePresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Presentation.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Presentation/Tests/**"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockChallengeUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockHydrationProgressUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockPersonalizedChallengeUseCase.swift")
            ]),
            dependencies: [
                .target(name: "ChallengePresentation"),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Core")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine")),
                .project(target: "Localization", path: .relativeToRoot("Project/Shared/Localization"))
            ]
        )
    ]
)
