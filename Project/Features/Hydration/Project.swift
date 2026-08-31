import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.Hydration"

let project = Project(
    name: "Hydration",
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
            name: "HydrationDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Domain",
            deploymentTargets: .iOS("26.0"),
            sources: ["Domain/Sources/**"],
            dependencies: [
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account"))
            ]
        ),
        .target(
            name: "HydrationData",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Data",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Sources/**"],
            dependencies: [
                .target(name: "HydrationDomain"),
                .project(target: "Utils", path: .relativeToRoot("Project/Shared/Utils"))
            ]
        ),
        .target(
            name: "HydrationPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Presentation",
            deploymentTargets: .iOS("26.0"),
            sources: ["Presentation/Sources/**"],
            dependencies: [
                .target(name: "HydrationDomain"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "CoreDomain", path: .relativeToRoot("Project/Core")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Core")),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine")),
                .project(target: "DesignSystem", path: .relativeToRoot("Project/Shared/DesignSystem")),
                .project(target: "Localization", path: .relativeToRoot("Project/Shared/Localization"))
            ]
        ),
        .target(
            name: "HydrationDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Domain.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Domain/Tests/**"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockDrinkWaterRepository.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockHealthKitRepository.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockHydrationGoalRecommendationRepository.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockUserPreferencesRepository.swift")
            ]),
            dependencies: [
                .target(name: "HydrationDomain"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account"))
            ]
        ),
        .target(
            name: "HydrationDataTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Data.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Tests/**"],
            dependencies: [.target(name: "HydrationData"), .target(name: "HydrationDomain")]
        ),
        .target(
            name: "HydrationPresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Presentation.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Presentation/Tests/**"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockAnalyticsUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockAppReviewRequestUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockBodyProfileUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockDrinkWaterUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockHealthKitUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockHydrationGoalRecommendationUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockHydrationProgressUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockHydrationRoutineAdherenceUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockUserPreferencesUseCase.swift")
            ]),
            dependencies: [
                .target(name: "HydrationPresentation"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "CoreDomain", path: .relativeToRoot("Project/Core")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Core")),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine")),
                .project(target: "Localization", path: .relativeToRoot("Project/Shared/Localization"))
            ]
        )
    ]
)
