import ProjectDescription

let project = Project(
    name: "Widget",
    targets: [
        .target(
            name: "WidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "gaeng2y.DrinkWater.WidgetExtension",
            deploymentTargets: .iOS("18.0"),
            infoPlist: .file(path: .relativeToCurrentFile("Resources/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(
                path: .relativeToRoot("Supporting Files/WidgetExtension.entitlements")
            ),
            dependencies: [
                .project(
                    target: "Utils",
                    path: .relativeToRoot("Project/Utils")
                )
            ]
        )
    ]
)
