import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater.Account"

let project = Project(
    name: "Account",
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
            name: "AccountDomain",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Domain",
            deploymentTargets: .iOS("26.0"),
            sources: ["Domain/Sources/**"]
        ),
        .target(
            name: "AccountData",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Data",
            deploymentTargets: .iOS("26.0"),
            sources: ["Data/Sources/**"],
            dependencies: [
                .target(name: "AccountDomain"),
                .project(target: "MulimiCloudKit", path: .relativeToRoot("Project/Core/CloudKit")),
                .project(target: "MulimiKeychain", path: .relativeToRoot("Project/Core/Keychain")),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                )
            ]
        ),
        .target(
            name: "AccountPresentation",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Presentation",
            deploymentTargets: .iOS("26.0"),
            sources: ["Presentation/Sources/**"],
            dependencies: [
                .target(name: "AccountDomain"),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "MulimiPlatform", path: .relativeToRoot("Project/Core/Platform")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "HydrationPresentation", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "RoutinePresentation", path: .relativeToRoot("Project/Features/Routine")),
                .project(
                    target: "HydrationReminderDomain",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                ),
                .project(target: "Localization", path: .relativeToRoot("Project/Shared/Localization"))
            ]
        ),
        .target(
            name: "AccountDomainTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Domain.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Domain/Tests/**"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockAuthenticationRepository.swift"),
                .relativeToRoot("Project/Features/TestSupport/Domain/MockUserPreferencesRepository.swift")
            ]),
            dependencies: [.target(name: "AccountDomain")]
        ),
        .target(
            name: "AccountPresentationTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).Presentation.Tests",
            deploymentTargets: .iOS("26.0"),
            sources: .paths([
                .relativeToCurrentFile("Presentation/Tests/**"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockAnalyticsUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockHydrationReminderUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockSignInUseCase.swift"),
                .relativeToRoot("Project/Features/TestSupport/Presentation/MockUserPreferencesUseCase.swift")
            ]),
            dependencies: [
                .target(name: "AccountPresentation"),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "MulimiPlatform", path: .relativeToRoot("Project/Core/Platform")),
                .project(
                    target: "HydrationReminderDomain",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                )
            ]
        )
    ]
)
