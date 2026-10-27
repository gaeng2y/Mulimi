import ProjectDescription

// Fork CI and unauthenticated builds can opt out with TUIST_MULIMI_CLOUD_ENABLED=0.
let cloudEnabled = Environment.mulimiCloudEnabled.getBoolean(default: true)

let tuist = Tuist(
    fullHandle: cloudEnabled ? "gaeng2y/mulimi" : nil,
    project: .tuist(
        generationOptions: .options(
            optionalAuthentication: !cloudEnabled,
            buildInsightsDisabled: !cloudEnabled,
            testInsightsDisabled: !cloudEnabled,
            enableCaching: cloudEnabled
        ),
        cacheOptions: .options(
            profiles: .profiles(default: .onlyExternal),
            storages: cloudEnabled ? [.local, .remote] : [.local]
        )
    )
)
