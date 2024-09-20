import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Mulimi",
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
                "CFBundleVersion": "5",
                "CFBundleShortVersionString": "1.0.4",
                "UILaunchStoryboardName": "LaunchScreen",
                "ITSAppUsesNonExemptEncryption": false,
                "UIApplicationSceneManifest": [
                    "UIApplicationSupportsMultipleScenes": true,
                    "UISceneConfigurations": [:]
                ]
            ]),
            sources: ["App/Sources/**"],
            resources: ["App/Resources/**"],
            dependencies: [
                .external(name: "ComposableArchitecture"),
                .external(name: "Lottie"),
                .target(name: "Utils"),
                .target(name: "WidgetExtension")
            ]
        ),
        .target(
            name: "Utils",
            destinations: .iOS,
            product: .framework,
            bundleId: "\(bundleId).Utils",
            deploymentTargets: .iOS("17.0"),
            sources: ["Util/Sources/**"]
        ),
        .target(
            name: "WidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(bundleId).WidgetExtension",
            infoPlist: .extendingDefault(with: [
                "NSExtension": [
                    "NSExtensionPointIdentifier": "com.apple.widgetkit-extension"
                ],
                "CFBundleDisplayName": "물리미 위젯",
                "CFBundleExecutable": "$(EXECUTABLE_NAME)",
                "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
                "CFBundleName": "$(PRODUCT_NAME)",
                "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
                "CFBundleVersion": "5",
                "CFBundleShortVersionString": "1.0.4",
            ]),
            sources: ["Widget/Sources/**"],
            resources: ["Widget/Resources/**"],
            entitlements: .file(path: .relativeToRoot("Supporting Files/WidgetExtension.entitlements")),
            dependencies: [
                .target(name: "Utils")
            ]
        ),
        .target(
            name: "MulimiTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "\(bundleId).MulimiTests",
            infoPlist: .default,
            sources: ["App/Tests/**"],
            resources: [],
            dependencies: [.target(name: "Mulimi")]
        ),
    ]
)
