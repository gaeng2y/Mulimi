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
    case failedToCreateContainer(primary: Error, fallback: Error)

    public var errorDescription: String? {
        switch self {
        case .missingAppGroupContainer(let identifier):
            return "App Group container is not available: \(identifier)"
        case let .failedToCreateContainer(primary, fallback):
            return """
            Failed to create CloudKit-backed container (\(primary)).
            Fallback local container also failed (\(fallback)).
            """
        }
    }
}

public enum SharedHydrationStore {
    public static let appGroupIdentifier = "group.com.gaeng2y.drinkwater"
    public static let cloudKitContainerIdentifier = "iCloud.gaeng2y.DrinkWater"

    public static func makeModelContainer(
        cloudKitDatabase: ModelConfiguration.CloudKitDatabase = .automatic,
        isStoredInMemoryOnly: Bool = false,
        cloudSyncEnabled: Bool = true,
        shouldFallbackToLocalStore: Bool = true
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
            (isStoredInMemoryOnly || !cloudSyncEnabled) ? .none : cloudKitDatabase

        let configuration = ModelConfiguration(
            "Hydration",
            schema: Schema([HydrationEventModel.self]),
            isStoredInMemoryOnly: isStoredInMemoryOnly,
            allowsSave: true,
            groupContainer: isStoredInMemoryOnly ? .none : .identifier(appGroupIdentifier),
            cloudKitDatabase: effectiveCloudKitDatabase
        )
        
        do {
            return try ModelContainer(
                for: HydrationEventModel.self,
                configurations: configuration
            )
        } catch let primaryError {
            guard shouldFallbackToLocalStore,
                  !isStoredInMemoryOnly,
                  cloudSyncEnabled else {
                throw primaryError
            }

            do {
                return try makeModelContainer(
                    cloudKitDatabase: cloudKitDatabase,
                    isStoredInMemoryOnly: false,
                    cloudSyncEnabled: false,
                    shouldFallbackToLocalStore: false
                )
            } catch let fallbackError {
                throw SharedHydrationStoreError.failedToCreateContainer(
                    primary: primaryError,
                    fallback: fallbackError
                )
            }
        }
    }
}
