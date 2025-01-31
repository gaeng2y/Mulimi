//
//  Project.swift
//  Config
//
//  Created by Kyeongmo Yang on 10/4/24.
//

import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Mulimi App",
    organizationName: "gaeng2y",
    targets: [
        .target(
            name: "Mulimi",
            destinations: .iOS,
            product: .app,
            bundleId: bundleId,
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "LSApplicationCategoryType": "public.app-category.healthcare-fitness",
                "CFBundleDisplayName": "물리미",
                "CFBundleExecutable": "$(EXECUTABLE_NAME)",
                "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
                "CFBundleName": "$(PRODUCT_NAME)",
                "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
                "CFBundleVersion": "9",
                "CFBundleShortVersionString": "1.0.7",
                "UILaunchStoryboardName": "LaunchScreen",
                "ITSAppUsesNonExemptEncryption": false,
                "NSHealthShareUsageDescription": "We need access to your health data to display your water intake.",
                "NSHealthUpdateUsageDescription": "We need access to your health data to log your water intake.",
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": true,
                    "UISceneConfigurations": [:]
                ]
            ]),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(
                path: .relativeToRoot("Supporting Files/Mulimi.entitlements")
            ),
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .target(name: "WidgetExtension"),
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Utils")
                ),
            ]
        ),
        .target(
            name: "MulimiTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).MulimiTests",
            infoPlist: .default,
            sources: ["Tests/**"],
            resources: [],
            dependencies: [.target(name: "Mulimi")]
        ),
        .target(
            name: "WidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(bundleId).WidgetExtension",
            deploymentTargets: .iOS("17.0"),
            infoPlist: .extendingDefault(with: [
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
                ],
                "CFBundleDisplayName": "물리미 위젯",
                "CFBundleExecutable": "$(EXECUTABLE_NAME)",
                "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
                "CFBundleName": "$(PRODUCT_NAME)",
                "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
                "CFBundleVersion": "9",
                "CFBundleShortVersionString": "1.0.7",
            ]),
            sources: ["../Widget/Sources/**"],
            resources: ["../Widget/Resources/**"],
            entitlements: .file(path: .relativeToRoot("Supporting Files/WidgetExtension.entitlements")),
            dependencies: [
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Utils")
                )
            ]
        )
    ]
)
