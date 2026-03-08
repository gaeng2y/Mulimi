//
//  SharedHydrationStore.swift
//  Persistence
//
//  Created by Codex on 3/8/26.
//

import Foundation
import SwiftData

public enum SharedHydrationStoreError: Error, LocalizedError {
    case missingAppGroupContainer(identifier: String)

    public var errorDescription: String? {
        switch self {
        case .missingAppGroupContainer(let identifier):
            return "App Group container is not available: \(identifier)"
        }
    }
}

public enum SharedHydrationStore {
    public static let appGroupIdentifier = "group.com.gaeng2y.drinkwater"

    public static func makeModelContainer(
        cloudKitDatabase: ModelConfiguration.CloudKitDatabase = .none,
        isStoredInMemoryOnly: Bool = false
    ) throws -> ModelContainer {
        if !isStoredInMemoryOnly {
            guard FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: appGroupIdentifier
            ) != nil else {
                throw SharedHydrationStoreError.missingAppGroupContainer(
                    identifier: appGroupIdentifier
                )
            }
        }

        let effectiveCloudKitDatabase: ModelConfiguration.CloudKitDatabase =
            isStoredInMemoryOnly ? .none : cloudKitDatabase

        let configuration = ModelConfiguration(
            "Hydration",
            schema: Schema([HydrationEventModel.self]),
            isStoredInMemoryOnly: isStoredInMemoryOnly,
            allowsSave: true,
            groupContainer: isStoredInMemoryOnly ? .none : .identifier(appGroupIdentifier),
            cloudKitDatabase: effectiveCloudKitDatabase
        )

        return try ModelContainer(
            for: HydrationEventModel.self,
            configurations: configuration
        )
    }
}
