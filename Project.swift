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
            infoPlist: .extendingDefault(with: [
                "LSApplicationCategoryType": "public.app-category.healthcare-fitness",
                "CFBundleDisplayName": "물리미",
                "CFBundleExecutable": "$(EXECUTABLE_NAME)",
                "CFBundlePackageType": "$(PRODUCT_BUNDLE_PACKAGE_TYPE)",
                "CFBundleName": "$(PRODUCT_NAME)",
                "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
                "CFBundleVersion": "$(CURRENT_PROJECT_VERSION)",
                "CFBundleShortVersionString": "$(MARKETING_VERSION)",
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
                .external(name: "Lottie")
            ]
        ),
        .target(
            name: "MulimiWidget",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(bundleId).WidgetExtension",
            infoPlist: .file(path: .relativeToRoot("Widget/Sources/Info.plist")),
            sources: ["Widget/Sources/**"],
            resources: ["Widget/Resources/**"],
            entitlements: .file(path: .relativeToRoot("Supporting Files/WidgetExtension.entitlements")),
            dependencies: []
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
