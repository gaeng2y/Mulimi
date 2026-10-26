import ProjectDescription

let tuist = Tuist(
    fullHandle: "gaeng2y/mulimi",
    project: .tuist(
        generationOptions: .options(optionalAuthentication: true),
        cacheOptions: .options(storages: [.local])
    )
)
