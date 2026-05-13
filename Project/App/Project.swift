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
            .release(name: "Release", xcconfig: .relativeToRoot("XCConfig/Release.xcconfig"))
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
            resources: [
                "Resources/**",
                "Supports/GoogleService-Info.plist"
            ],
            entitlements: .file(
                path: .relativeToCurrentFile("Supports/Mulimi.entitlements")
            ),
            dependencies: [
                .target(name: "MulimiWatch"),
                .target(name: "WidgetExtension"),
                .project(
                    target: "DependencyInjection",
                    path: .relativeToRoot("Project/Shared/DependencyInjection")
                ),
                .project(
                    target: "DomainLayerInterface",
                    path: .relativeToRoot("Project/Domain")
                ),
                .project(
                    target: "Localization",
                    path: .relativeToRoot("Project/Shared/Localization")
                ),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Shared/Utils")
                ),
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseCrashlytics")
            ]
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
