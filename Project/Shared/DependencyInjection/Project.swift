//
//  Project.swift
//  DependencyInjection
//
//  Created by Kyeongmo Yang on 9/17/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "DependencyInjection",
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
        // Production DI
        .target(
            name: "DependencyInjection",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DependencyInjection",
            deploymentTargets: .iOS("26.0"),
            sources: ["Sources/Production/**", "Sources/Core/**"],
            dependencies: [
                .external(name: "Swinject"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "AccountData", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "AccountPresentation", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "ChallengeDomain", path: .relativeToRoot("Project/Features/Challenge")),
                .project(target: "ChallengeData", path: .relativeToRoot("Project/Features/Challenge")),
                .project(target: "ChallengePresentation", path: .relativeToRoot("Project/Features/Challenge")),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "MulimiAnalyticsData", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Core")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "HydrationData", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "HydrationPresentation", path: .relativeToRoot("Project/Features/Hydration")),
                .project(
                    target: "HydrationReminderDomain",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                ),
                .project(
                    target: "HydrationReminderData",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                ),
                .project(
                    target: "HydrationReminderPresentation",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                ),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine")),
                .project(target: "RoutineData", path: .relativeToRoot("Project/Features/Routine")),
                .project(target: "RoutinePresentation", path: .relativeToRoot("Project/Features/Routine")),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                )
            ]
        ),
        .target(
            name: "WatchDependencyInjection",
            destinations: [.appleWatch],
            product: .framework,
            bundleId: "\(bundleId).WatchDependencyInjection",
            deploymentTargets: .watchOS("26.0"),
            sources: ["Sources/Watch/**"],
            dependencies: [
                .project(
                    target: "WatchHydrationData",
                    path: .relativeToRoot("Project/Features/WatchHydration")
                ),
                .project(
                    target: "WatchHydrationDomain",
                    path: .relativeToRoot("Project/Features/WatchHydration")
                ),
                .project(
                    target: "WatchHydrationPresentation",
                    path: .relativeToRoot("Project/Features/WatchHydration")
                )
            ]
        ),

        // Preview Support
        .target(
            name: "DependencyInjectionPreview",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DependencyInjection.Preview",
            deploymentTargets: .iOS("26.0"),
            sources: ["Sources/Preview/**", "Sources/Core/**"],
            dependencies: [
                .target(name: "DependencyInjection"),
                .external(name: "Swinject"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "AccountPresentation", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "ChallengeDomain", path: .relativeToRoot("Project/Features/Challenge")),
                .project(target: "ChallengePresentation", path: .relativeToRoot("Project/Features/Challenge")),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Core")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "HydrationPresentation", path: .relativeToRoot("Project/Features/Hydration")),
                .project(
                    target: "HydrationReminderDomain",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                ),
                .project(
                    target: "HydrationReminderPresentation",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                ),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine")),
                .project(target: "RoutinePresentation", path: .relativeToRoot("Project/Features/Routine"))
            ]
        ),

        // Testing Support
        .target(
            name: "DependencyInjectionTesting",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).DependencyInjection.Testing",
            deploymentTargets: .iOS("26.0"),
            sources: ["Sources/Testing/**", "Sources/Core/**"],
            dependencies: [
                .target(name: "DependencyInjection"),
                .external(name: "Swinject"),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "ChallengeDomain", path: .relativeToRoot("Project/Features/Challenge")),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(
                    target: "HydrationReminderDomain",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                ),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine"))
            ]
        )
    ]
)
