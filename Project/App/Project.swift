//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 10/4/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Mulimi App",
    organizationName: "gaeng2y",
    settings: .settings(
        base: [
            "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
            "APP_BUILD_NUMBER": .string(AppVersion.buildNumber),
            "SWIFT_VERSION": .string("6.0")
        ],
        configurations: [
            .debug(name: "Debug", xcconfig: .relativeToRoot("XCConfig/Debug.xcconfig")),
            .release(
                name: "Release",
                settings: [
                    "DEBUG_INFORMATION_FORMAT": .string("dwarf-with-dsym"),
                    "ENABLE_USER_SCRIPT_SANDBOXING": .string("NO")
                ],
                xcconfig: .relativeToRoot("XCConfig/Release.xcconfig")
            )
        ]
    ),
    targets: [
        .target(
            name: "Mulimi",
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS("26.0"),
            infoPlist: .file(path: .path("Supports/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(
                path: .relativeToCurrentFile("Supports/Mulimi.entitlements")
            ),
            scripts: [
                .post(
                    script: """
                    if [ "$CONFIGURATION" != "Release" ]; then
                      exit 0
                    fi
                    if [ -z "$POSTHOG_CLI_API_KEY" ] || [ -z "$POSTHOG_CLI_PROJECT_ID" ]; then
                      echo "warning: PostHog dSYM upload skipped: CLI credentials are not configured."
                      exit 0
                    fi
                    "$SRCROOT/../../Tuist/.build/checkouts/posthog-ios/build-tools/upload-symbols.sh"
                    """,
                    name: "Upload PostHog dSYMs",
                    inputPaths: [
                        "$(DWARF_DSYM_FOLDER_PATH)/$(DWARF_DSYM_FILE_NAME)/Contents/Resources/DWARF/$(EXECUTABLE_NAME)"
                    ],
                    basedOnDependencyAnalysis: false
                )
            ],
            dependencies: [
                .target(name: "MulimiWatch"),
                .target(name: "WidgetExtension"),
                .project(
                    target: "DependencyInjection",
                    path: .relativeToRoot("Project/Shared/DependencyInjection")
                ),
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "AccountPresentation", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "ChallengePresentation", path: .relativeToRoot("Project/Features/Challenge")),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "MulimiAnalyticsData", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "CorePresentation", path: .relativeToRoot("Project/Core")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "HydrationPresentation", path: .relativeToRoot("Project/Features/Hydration")),
                .project(
                    target: "HydrationReminderPresentation",
                    path: .relativeToRoot("Project/Features/HydrationReminder")
                ),
                .project(target: "RoutinePresentation", path: .relativeToRoot("Project/Features/Routine")),
                .project(
                    target: "Localization",
                    path: .relativeToRoot("Project/Shared/Localization")
                ),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                )
            ],
            settings: .settings(
                base: [
                    "OTHER_LDFLAGS": .string("$(inherited) -ObjC")
                ]
            )
        ),
        .target(
            name: "WidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(bundleId).WidgetExtension",
            deploymentTargets: .iOS("26.0"),
            infoPlist: .file(path: .relativeToRoot("Project/Widget/Resources/Info.plist")),
            sources: .paths([
                .relativeToRoot("Project/Widget/Sources/**"),
                .relativeToCurrentFile("Sources/AppIntents/LogWaterAppIntent.swift")
            ]),
            resources: .resources([.glob(pattern: .relativeToRoot("Project/Widget/Resources/Assets.xcassets"))]),
            entitlements: .file(
                path: .relativeToRoot("Supporting Files/WidgetExtension.entitlements")
            ),
            dependencies: [
                .project(target: "AccountDomain", path: .relativeToRoot("Project/Features/Account")),
                .project(target: "MulimiAnalytics", path: .relativeToRoot("Project/Core/Analytics")),
                .project(target: "HydrationDomain", path: .relativeToRoot("Project/Features/Hydration")),
                .project(target: "RoutineDomain", path: .relativeToRoot("Project/Features/Routine")),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                ),
                .project(
                    target: "DependencyInjection",
                    path: .relativeToRoot("Project/Shared/DependencyInjection")
                )
            ],
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
            )
        ),
        .target(
            name: "MulimiWatch",
            destinations: [.appleWatch],
            product: .watch2App,
            bundleId: "\(bundleId).watchkitapp",
            deploymentTargets: .watchOS("26.0"),
            infoPlist: .file(path: .relativeToCurrentFile("Watch/Supports/Info.plist")),
            sources: [],
            resources: [
                "Watch/Resources/Assets.xcassets"
            ],
            dependencies: [
                .target(name: "MulimiWatchExtension")
            ],
            settings: .settings(
                base: [
                    "APP_MARKETING_VERSION": .string(AppVersion.marketingVersion),
                    "APP_BUILD_NUMBER": .string(AppVersion.buildNumber),
                    "ASSETCATALOG_COMPILER_APPICON_NAME": .string("AppIcon"),
                    "ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME": .string(""),
                    "SWIFT_VERSION": .string("6.0")
                ],
                configurations: [
                    .debug(name: "Debug"),
                    .release(name: "Release")
                ]
            )
        ),
        .target(
            name: "MulimiWatchExtension",
            destinations: [.appleWatch],
            product: .watch2Extension,
            bundleId: "\(bundleId).watchkitapp.watchkitextension",
            deploymentTargets: .watchOS("26.0"),
            infoPlist: .file(path: .relativeToCurrentFile("Watch/Supports/ExtensionInfo.plist")),
            sources: ["Watch/Sources/App/**"],
            resources: ["Watch/Resources/**"],
            entitlements: .file(
                path: .relativeToCurrentFile("Watch/Supports/MulimiWatch.entitlements")
            ),
            dependencies: [
                .project(
                    target: "WatchDependencyInjection",
                    path: .relativeToRoot("Project/Shared/DependencyInjection")
                )
            ],
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
            )
        )
    ]
)
