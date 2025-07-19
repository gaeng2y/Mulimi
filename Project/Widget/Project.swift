import ProjectDescription

let bundleId = "gaeng2y.DrinkWater"

let project = Project(
    name: "Widget",
    targets: [
        .target(
            name: "WidgetExtension",
            destinations: .iOS,
            product: .appExtension,
            bundleId: "\(bundleId).WidgetExtension",
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
                    path: .relativeToRoot("Project/Shared/Utils")
                )
            ]
        )
    ]
)
